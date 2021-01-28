### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 04f38824-548b-11eb-352d-137945ab2ee8
## Chaotic Dynamics
# Part 1: The double pendulum
#
# https://www.youtube.com/watch?v=RG9waSjj2dc

begin
	using Plots
	using Random
	using DifferentialEquations
end

# ╔═╡ bcdfab84-549c-11eb-2bff-330f73a55822
md"we start this lecture talking about the double pendulum, a pendulum hanging from another pendulum."

# ╔═╡ 4f15b966-54a0-11eb-15f9-d102f5c8638f
md"What's interesting about this is how chaotic the motion can be, and how sensitive it is to initial conditions.

Diving in with the Lagrange

```math
\begin{align}
\mathcal{L} &= T - V \\
T &= \frac{1}2(m_1+m_2)L_1^2\dot\theta^2 +\frac{1}2m_2(L_2^2\dot\phi^2 + 2L_1L_2\dot\theta\dot\phi\cos(\theta-\phi))\\
V &= (m_1+m_2)L_1g(1-\cos(\theta))+m_2L_2g(1-\cos(\phi))
\end{align}
```

Solving for the minimum by finding the zero of
``\frac{d}{dt}\frac{\partial T}{\partial \dot q} - \frac{\partial V}{\partial q}``
and doing all kinds of terrible trig substitutions (which you can try and follow along [here](https://www.youtube.com/watch?v=tc2ah-KnDXw)), we eventually come to:

```math
\begin{align}
M_k &= 2m_1 + m_2( 1- \cos(2\theta - 2\phi) ) \\
\ddot\theta &= \frac{-g(2m_1+m_2)\sin\theta - m_2g\sin(\theta-2\phi)
			-2\sin(\theta-\phi)m_2(L_2\dot\phi^2 + L_1\dot\theta^2\cos(\theta-\phi))
}{L_1 M_k} \\
\ddot\phi &= \frac{2\sin(\theta-\phi)((m_1+m_2)(L_1\dot\theta^2+g\cos\theta)
			+ L_2\dot\phi^2m_2\cos(\theta-\phi))}{L_2 M_k}
\end{align}
```

Beautiful.  Ok, so lets code that up.
"

# ╔═╡ f3d794be-54a4-11eb-3cbf-ad146c954c2c
begin
	function DoubleP!(du, u, p, t)
		(m₁, m₂, L₁, L₂, g)= p
		( θ, ϕ, dθ, dϕ )= u
		
		mk= 2m₁+m₂*(1-cos(2θ-2ϕ))
		du[1]= dθ
		du[2]= dϕ
		du[3]= -(g*(2*m₁+m₂)*sin(θ)+m₂*g*sin(θ-2ϕ)
				+2*sin(θ-ϕ)*m₂*(L₂*dϕ^2+L₁*dθ^2*cos(θ-ϕ)))/(L₁*mk)
		du[4]= (2*sin(θ-ϕ)*((m₁+m₂)*(L₁*dθ^2+g*cos(θ))+L₂*dϕ^2*m₂*cos(θ-ϕ)))/(L₂*mk)
	end
end

# ╔═╡ cd9bcca0-54a6-11eb-30ae-4788ee9293f3
md"So now all we have to do is throw it into our solver, and bamn.  Done deal."

# ╔═╡ ce3a60e6-54af-11eb-0e9d-43151ab220b6
md"Or plotted through time..."

# ╔═╡ eba2f936-54af-11eb-18f0-471135d922e8
md"Except there's more to the story.  Lets take a look at our solution, and convert it back into total energy using ``T`` and ``E``.  Somehow our total energy seems to be growing.  Quick call the patent office, we've invented a *perpetual motion machine*."

# ╔═╡ 0ecd6686-54b9-11eb-2684-63d4f7d13c1a
md"While Runge-Kutta 4 is good at minimizing local errors, chaotic systems tend to accumulate drift.  There's a different approach called Variational integrators, which are more stable, but in these brave new times, we can just crank up the number of terms in our RK system, and suddenly our energy seems a lot more stable."

# ╔═╡ 0f5bd034-54a9-11eb-22fe-6d07a5cfcb9b
md"Could you go even further?  Of course you could.
Someone did the math for a [Triple Pendulum](https://www.nickeyre.com/images/triplependulum.pdf) and then someone else built a triple pendulum on a cart, and created a [control algorithm](https://www.youtube.com/watch?v=syygHNU0RCY) for it."

# ╔═╡ 7f081a0c-54b9-11eb-1b18-c72b68f79730
md"
----
Some helper functions used above.
"

# ╔═╡ 329492a4-549d-11eb-38ab-155f83ef4e76
begin
	rot(θ)= [cos(θ), sin(θ)]
	part(dim,U...)=[u[dim] for u in U]
	function points( U, u₀, r1, r2 )
		v= zeros(4 * size(U,2))
		for i in axes(U, 2)
			(a1,a2)= U[:,i]
			pt1= u₀ .+ r1 * rot( a1 -π/2 )
			pt2= pt1 .+ r2 * rot( a2 - π/2 )
			v[4i-3:4i]=[pt1 pt2]
		end
		return reshape(v, 4, :)
	end
	
end

# ╔═╡ d4a5d298-549c-11eb-0e5f-1300f426da48
let
	pt0= [0., 10]
	l1= 4
	l2= 4
	theta= π/8
	phi= -π/3
	pt1= pt0 .+ l1 * rot(theta - π/2)
	pt2= pt0 .+ l1 * rot(theta - π/2) .+ l2 * rot(phi - π/2)
	
	gr()
	plot( reshape(part(1, pt0, pt1, pt1, pt2), 2, :),
		  reshape(part(2, pt0, pt1, pt1, pt2), 2, :),
			xlims= (-5,5), ylims= (0,10), size=(250,250),
		markershape= [:none :circle], ms=8,
		markercolor= [:black :blue; :black :red],
		lab= ""
	)
end

# ╔═╡ dd592796-54a6-11eb-123d-59728373a040
begin
	results_rk= zeros(4,4)
	pts_rk= zeros(4,4)
	p= (5., 5., 4., 4., 9.8)
	let
		u₀= [4π/5, -π/8, 0, 0.]
		prob= ODEProblem( DoubleP!, u₀, (0., 200.), p )
		sol= solve( prob, Tsit5(), saveat= 0.1 )

		plotly()
		results_rk= Array(sol) 
		pts_rk= points(results_rk[1:2,:], [0., 10], 4, 4 )'
	end
	plot( pts_rk[:,1:2:3], pts_rk[:,2:2:4], xlims=(-8,8),ylims=(2,14),size=(600,450))
end

# ╔═╡ a79ac8c2-54af-11eb-21d2-57dfe99b1d32
plot( axes(pts_rk, 1), pts_rk[:,3], pts_rk[:,4] )

# ╔═╡ 0893c28c-54b0-11eb-2b8f-cf996fd391d2
begin
	function energy( U, p )
		(m₁, m₂, L₁, L₂, g)= p
		m₀= m₁+m₂
		v= zeros( size(U,2) )
		for i in axes(U,2)
			( θ, ϕ, dθ, dϕ )= U[:,i]
			v[i]= 0.5*m₀*((L₁*dθ)^2)+0.5*m₂*((L₂*dϕ)^2+2*L₁*L₂*dθ*dϕ*cos(θ-ϕ)) + m₀*L₁*g*(1-cos(θ)) + m₂*L₂*g*(1-cos(ϕ))
		end
		v
	end

	plot( energy( results_rk, p ), lab="" )
end

# ╔═╡ 85f69d2c-54b4-11eb-27c6-21b242d24d85
let
	u₀= [4π/5, -π/8, 0, 0.]
	prob= ODEProblem( DoubleP!, u₀, (0., 200.), p )
	sol= solve( prob, TsitPap8(), reltol= 1e-6)

	results_rk8= Array(sol)
	E= energy( results_rk8, p ) 
	plot( E .- E[1] )
end

# ╔═╡ Cell order:
# ╠═04f38824-548b-11eb-352d-137945ab2ee8
# ╟─bcdfab84-549c-11eb-2bff-330f73a55822
# ╠═d4a5d298-549c-11eb-0e5f-1300f426da48
# ╟─4f15b966-54a0-11eb-15f9-d102f5c8638f
# ╠═f3d794be-54a4-11eb-3cbf-ad146c954c2c
# ╟─cd9bcca0-54a6-11eb-30ae-4788ee9293f3
# ╠═dd592796-54a6-11eb-123d-59728373a040
# ╟─ce3a60e6-54af-11eb-0e9d-43151ab220b6
# ╠═a79ac8c2-54af-11eb-21d2-57dfe99b1d32
# ╟─eba2f936-54af-11eb-18f0-471135d922e8
# ╠═0893c28c-54b0-11eb-2b8f-cf996fd391d2
# ╟─0ecd6686-54b9-11eb-2684-63d4f7d13c1a
# ╠═85f69d2c-54b4-11eb-27c6-21b242d24d85
# ╟─0f5bd034-54a9-11eb-22fe-6d07a5cfcb9b
# ╟─7f081a0c-54b9-11eb-1b18-c72b68f79730
# ╠═329492a4-549d-11eb-38ab-155f83ef4e76
