### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ c7a12260-1f21-11eb-079e-492a38dd15d7
## Time Stepping Ordinary Differential Equations
#
# https://www.youtube.com/watch?v=vg5nGfSnyrI

begin
	using Plots
	using LinearAlgebra
	using DifferentialEquations
end

# ╔═╡ 796c26c0-4675-11eb-0cbf-cd4217b82fde
md"We are going to start with simulating a simple system of a mass (``m``),
spring (``k``) and dampener (``c``).  The equations for this look something like

```math
\begin{align}
m\ddot x &= -kx -c\dot x \\
m\ddot x + kx + c\dot x &= 0 \\
\ddot x + \frac{k}mx + \frac{c}m\dot x &= 0
\end{align}
```
However, its useful to recast these in more fundamental terms like the natural frequency of the spring ``\omega_0=\sqrt\frac{k}m`` and damping ratio ``\zeta=\frac{c}{2\sqrt{km}}`` which gives us

```math
\ddot x + 2\zeta\omega_0\dot x+{\omega_0}^2 x= 0
```
But this is a second order differential equation, and we'd really like to just have first order differential equations.  So we apply a little slight of hand by saying ``v= \dot x``, turning our original equation into two equations

```math
\begin{align}
\dot x &= v \\
\dot v &= -2\zeta\omega_0 v-{\omega_0}^2 x
\end{align}
```

or in matrix form
```math
\frac{d}{dt}\left [\matrix{ x \\ v } \right ]=
   \left (\matrix{ 0 & 1 \\ -{\omega_0}^2 & -2\zeta\omega_0 } \right )
   \left (\matrix{ x \\ v } \right )
```

"

# ╔═╡ 4c4092d8-4657-11eb-1648-a91e661f76c0
begin
	ω₀=2*π   # natural frequency
	ζ=0.13   # dampening

	A= [ 0    1 ;
		-ω₀^2 -2*ζ*ω₀]
	
	x₀= [2.; 0.]
end

# ╔═╡ ae40164a-4678-11eb-18fc-dfa4d0b6ec3d
md"So I want to write something that will apply a small amount of ``A`` to ``x`` over and over again, and output the state ``x`` for each step.  I could write a function and a loop, but I want to use natural mechanisms of Julia like iterators so my best idea it to create the equivalent of a generator which in Julia is called a `Channel`.  Actually I want to make these repeatedly, so I have a function which constructs and returns a channel.
"

# ╔═╡ ef146d40-466d-11eb-20d7-0d4674a236ac
begin
	function forward_euler(x₀, A, Δt = 0.1)
		return Channel() do ch
			x= x₀
			ϵ= I + Δt * A
			while true
				put!(ch, x)
				x= ϵ * x
			end
		end
	end
end

# ╔═╡ 3b41d89e-4679-11eb-3a8d-33a03f6b731a
md"Once you have a channel, you call `take!` on it to capture a value."

# ╔═╡ e82a39b6-4672-11eb-078d-e55d5073769d
let
	feu= forward_euler(x₀, A)
	take!(feu), take!(feu), take!(feu)
end

# ╔═╡ 6362bb9a-4679-11eb-3306-79465d5090ae
md"Since this will function as an interator, I could try and use it in a loop, but I didn't write an end condition for `forward_euler`, and it will run forever.  I better wrap it in something that will stop after a certain number.
"

# ╔═╡ 4fbe0cfa-4673-11eb-2cf9-175af849e436
collect(Iterators.take(forward_euler(x₀, A, 0.025), 10))

# ╔═╡ a785c404-4679-11eb-2657-ff137e30a58d
md"Splat (`...`) is another way to cause the iterator to be evaluated, so we concatenate the results into a nice array and we can make some pictures.
"

# ╔═╡ 913b2cc4-4673-11eb-1f5f-b1b25f2112b1
let
	Δt=0.01
	T= 0:Δt:10
	results= hcat( Iterators.take(forward_euler(x₀, A, Δt), length(T) )... )
	plot(
		plot( T, results', lab= ["x" "x'"] ),
		plot( T, results[1,:], results[2,:], label="" )
	)
end

# ╔═╡ 2259d906-467b-11eb-3f6d-670c764b325d
md"We can also implement reverse euler"

# ╔═╡ 2e6b4d36-467b-11eb-09d4-a926600cc48e
begin
	function reverse_euler(x₀, A, Δt = 0.1)
		return Channel() do ch
			x= x₀
			ϵ= inv(I - Δt * A)
			while true
				put!(ch, x)
				x= ϵ * x
			end
		end
	end
end

# ╔═╡ f4979650-467c-11eb-230b-a73e37a92a97
md"and with a courser step (``\Delta t=0.025``) the forward euler struggles even to converge, while the reverse moves quickly to a stable solution.
"

# ╔═╡ 51e1b0ce-467b-11eb-1738-3b93ab819e5f
begin
	Δt=0.025
	T= 0:Δt:10
	# transpose the final results, as plot() prefers column series
	results= vcat(
		hcat( Iterators.take(forward_euler(x₀, A, Δt), length(T) )... ),
		hcat( Iterators.take(reverse_euler(x₀, A, Δt), length(T) )... ) )'
	
	plot(
		plot( T, results[:, 1:2:3], results[:, 2:2:4], lab= ""),
		plot( T, results, lab=["fwd x" "fwd v" "rev x" "rev v"] )
		)
end

# ╔═╡ 9825a7de-4688-11eb-1cbc-7bada109e8f0
md"
----
## Better solvers
(Runge-Kutta)

Julia has an entire meta-package system called `DifferentialEquations`, which after you get over the horror of installing all the dependencies (as of 1.5.1), provides a wealth of tools.  The tutorials alone are as involved as this entire course.  Needless to say for this particular problem, we are barely scratching the surface.

What we do is first define the problem in a form the module recognizes

```
f(u,p,t)= A * u
problem= ODEProblem(f, x₀, (t_start, t_range))
```

notice we don't specify a time step here.  Then we engage the solver, with a few extra parameters to help it along, and give us data that's easy to see.

```
solution= solve( problem, Tsit5(), saveat=Δt )
```

We've chosen `Tsit5` as the solver, as its closest to *ODE45* from *matlab*.  We've also asked for data at every ``\Delta t``, not because the solver requires that small a step, but at the step size the solver would naturally use, the path would be rather course when plotted.

Finally, we breakdown the data in `sol` to block form (similar to `hcat(sol.u...)`) to plot it cleanly.
"

# ╔═╡ 3e9aef4e-468a-11eb-24cb-d57c0a0662c3
let
	f(u,p,t)=A*u
	tspan = (0., 10.)
	prob= ODEProblem( f, x₀, tspan )
	sol= solve( prob, Tsit5(), saveat=Δt )
	plot( sol )
	
	solm= Array(sol)
	
	plot( T, results[:, 1:2:3], results[:, 2:2:4],
			lab= ["forward euler" "reverse euler" ])
	plot!( sol.t, solm[1,:], solm[2,:], lab= "runge kutta" )
end

# ╔═╡ Cell order:
# ╠═c7a12260-1f21-11eb-079e-492a38dd15d7
# ╟─796c26c0-4675-11eb-0cbf-cd4217b82fde
# ╠═4c4092d8-4657-11eb-1648-a91e661f76c0
# ╟─ae40164a-4678-11eb-18fc-dfa4d0b6ec3d
# ╠═ef146d40-466d-11eb-20d7-0d4674a236ac
# ╟─3b41d89e-4679-11eb-3a8d-33a03f6b731a
# ╠═e82a39b6-4672-11eb-078d-e55d5073769d
# ╟─6362bb9a-4679-11eb-3306-79465d5090ae
# ╠═4fbe0cfa-4673-11eb-2cf9-175af849e436
# ╟─a785c404-4679-11eb-2657-ff137e30a58d
# ╠═913b2cc4-4673-11eb-1f5f-b1b25f2112b1
# ╟─2259d906-467b-11eb-3f6d-670c764b325d
# ╠═2e6b4d36-467b-11eb-09d4-a926600cc48e
# ╟─f4979650-467c-11eb-230b-a73e37a92a97
# ╠═51e1b0ce-467b-11eb-1738-3b93ab819e5f
# ╟─9825a7de-4688-11eb-1cbc-7bada109e8f0
# ╠═3e9aef4e-468a-11eb-24cb-d57c0a0662c3
