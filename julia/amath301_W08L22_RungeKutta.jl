### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 74cc0e9e-4990-11eb-0302-53860d839cab
## Implementing Runge Kutta and the Lorenz Equation
#
# https://www.youtube.com/watch?v=EXvLju3DLMY

begin
	using Plots
	using Random
	using DifferentialEquations
end

# ╔═╡ 8c56e692-4995-11eb-224b-b5b249749095
md"### Runge-Kutta

While the forward and backwards Euler solvers, evaluated the function ``f`` once per step, the [Runge-Kutta scheme](https://en.wikipedia.org/wiki/Runge%E2%80%93Kutta_methods)
takes several different samples and combines them to construct a better slope for progessing to the next sample.  The simplest of these was the second order form, or midpoint method.

```math
\def\dh{\textstyle\frac{\Delta t}2}
\begin{align}
f_1 &= f(t_k, y_k) \\
f_2 &= f(t_k + \dh, y_k + \dh f_1 ) \\
y_{k+1} &= y_k + \Delta t\, f_2
\end{align}
```
The global error of  ``\mathcal{O}(\Delta t)`` of Euler was improved to ``\mathcal{O}(\Delta t^2)``, similar to the central differentiation approach.  But the family of RK generalized to
```math
\begin{align}
y_{k+1} &= y_k + \Delta t \sum_1^s b_if_i \\
f_1 &= f(t_k, y_k) \\
f_2 &= f(t_k + c_2\Delta t, y_k + \Delta t\, a_{21}f_1) \\
f_3 &= f(t_k + c_3\Delta t, y_k + \Delta t (a_{31}f_1 + a_{32}f_2)) \\
\vdots
\end{align}
```

with a very popular one being RK4, with ``c_i=\frac{1}2`` and ``a_{21}=a_{32}=\frac{1}2, a_{31}=a_{41}=a_{42}=0,a_{43}=1`` giving us

```math
\begin{align}
f_1 &= f(t_k, y_k) \\
f_2 &= f(t_k + \dh, y_k + \dh f_1 ) \\
f_3 &= f(t_k + \dh, y_k + \dh f_2 ) \\
f_4 &= f(t_k + \Delta t, y_k + \Delta t\, f_3 ) \\
y_{k+1} &= y_k + {\textstyle\frac{\Delta t}6}(f_1 + 2f_2 + 2f_3 + f_4)
\end{align}
```

---
Lorenz attractors

To experiment with, we use the [Lorenz system](https://en.wikipedia.org/wiki/Lorenz_system) which when set right, has some very chaotic systems.  The basic equations are,

```math
\begin{align}
\dot x &= \sigma(y-x) \\
\dot y &= x(\rho -z) -y \\
\dot z &= xy - \beta z
\end{align}
```

For ``\rho < 1`` the system has equilibrium about the origin and there is no convection (the system was originally a simplified atmospheric convection model).  At at ``\rho > 1`` new critical points appear and at ``\rho > 24.74`` the points become repulsors and chaotic solutions appear.  The most studied being

```math
\rho = 28, \sigma = 10, \beta={\textstyle\frac{8}3}
```
"

# ╔═╡ aa0313a8-499c-11eb-16d4-63fc7d2aa159
begin
	function lorenz(u,p,t)   # use a helper macro for more concise def
		(σ,ρ,β)= p
		dx= σ * (u[2]-u[1])
		dy= u[1] * (ρ-u[3]) -u[2]
		dz= u[1]*u[2] - β*u[3]
		[dx,dy,dz]
	end
end

# ╔═╡ 1dcc7f8a-49a8-11eb-2b33-b9c16cf96aa9
md"We now build the function which collects the four intermediate values and then combines them inplace."

# ╔═╡ b53ac7ba-499d-11eb-3fbc-bdc5f44e467a
begin
	function rk4step!(uout, f, Δt, u, p, t)
		dh=Δt/2
		f₁= f(u,p,t)
		f₂= f(u +dh*f₁,p,t+dh)
		f₃= f(u +dh*f₂,p,t+dh)
		f₄= f(u +Δt *f₃, p, t+Δt )
		
		uout[:]= u + (Δt/6)*(f₁ + 2f₂ + 2f₃ + f₄)
	end
end

# ╔═╡ 36ca7758-49a8-11eb-26dc-bd2201109a01
md"Testing a single step, we seem to get some data out."

# ╔═╡ 14054168-499d-11eb-1067-3be9c365309c
let
	u₀= [1., 0, 0]
	
	u1= zeros(3)
	rk4step!( u1, lorenz, 0.01, u₀, (10, 28, 8/3), 0 )
	u1
end

# ╔═╡ 2d384574-49aa-11eb-2d8e-81441e897e0a
md"Now lets wrap this up so we can call it for multiple steps"

# ╔═╡ 38af9ace-49aa-11eb-24d1-29c8c5f76b36
function rk4(f, t, Δt, u₀, p )
	trange= t[1]:Δt:t[2]
	U= zeros(length(trange)+1,length(u₀))
	U[1,:]= u₀
	for (i,t) in enumerate(trange)
		rk4step!( view(U,i+1,:), lorenz, Δt, U[i,:], p, t)
	end
	U
end		

# ╔═╡ ea4def5e-49a2-11eb-1443-15538ee370cd
begin
	u₀= [-8., 8, 20]
	p= (10, 28, 8/3)
	Δt= 0.01
	
	let
		U= rk4( lorenz, (0.,50.), Δt, u₀, p )
		gr()
		plot( U[:,1],U[:,2],U[:,3], lat="rk4" )
	end
end

# ╔═╡ 73b1d542-49a8-11eb-0325-fd68cffd506c
md"Comparing with `Tsit5` we see they start the same, but start hopping around to different tracks."

# ╔═╡ 8080ebde-49a8-11eb-2323-27ecdaf8c08e
let
	tmax= 9
	
	U= rk4( lorenz, (0.,tmax), Δt, u₀, p )
	
	prob_le= ODEProblem( lorenz, u₀, (0., tmax), p )
	sol= solve( prob_le, Tsit5() )
	
	plotly()
	plot( U[:,1],U[:,2],U[:,3], lab="rk4" )
	plot!( sol, vars=(1,2,3), lab="Tsit5" )

end

# ╔═╡ Cell order:
# ╠═74cc0e9e-4990-11eb-0302-53860d839cab
# ╟─8c56e692-4995-11eb-224b-b5b249749095
# ╠═aa0313a8-499c-11eb-16d4-63fc7d2aa159
# ╟─1dcc7f8a-49a8-11eb-2b33-b9c16cf96aa9
# ╠═b53ac7ba-499d-11eb-3fbc-bdc5f44e467a
# ╟─36ca7758-49a8-11eb-26dc-bd2201109a01
# ╠═14054168-499d-11eb-1067-3be9c365309c
# ╟─2d384574-49aa-11eb-2d8e-81441e897e0a
# ╠═38af9ace-49aa-11eb-24d1-29c8c5f76b36
# ╠═ea4def5e-49a2-11eb-1443-15538ee370cd
# ╟─73b1d542-49a8-11eb-0325-fd68cffd506c
# ╠═8080ebde-49a8-11eb-2323-27ecdaf8c08e
