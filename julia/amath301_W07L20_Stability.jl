### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ a0f32984-4897-11eb-1b92-c9ee11aca24a
## Time Stepping Stability
#
# https://www.youtube.com/watch?v=Oel1wEFIaDI

begin
	using Plots
	using DifferentialEquations
end

# ╔═╡ deec1e74-489b-11eb-1bf8-0ddc4fb444c2
md"If we want to model a pendulum (vs the previous spring), the equations are similar, but we are now working in a rotational coordinate system, so we form the constraints as a Lagrange.

```math
\begin{align}
\mathcal{L} & =T-V=E_{kinetic}-E_{potential} \\
\frac{d}{dt}(\frac{\partial\mathcal{L}}{\partial \dot q_j})
	- \frac{\partial\mathcal{L}}{\partial q_j} &= Q_j \\
\frac{d}{dt}\frac{\partial T}{\partial \dot q_j}
	- \frac{d}{dt}\frac{\partial V}{\partial \dot q_j}
	- \frac{\partial T}{\partial q_j}
	+ \frac{\partial V}{\partial q_j} &= Q_j
\end{align}
```

and in this case, a few things simplify out.  We only need one axis, the rotation about ``\theta``.  There are no external forces so ``Q=0``.  Our energies are ``T=\frac{1}2 m(L\dot \theta)^2`` and ``V=mgL(1-\cos\theta)`` giving us

```math
\begin{align}
\frac{d}{dt}\frac{\partial T}{\partial \dot\theta} &= \frac{d}{dt} mL^2\dot\theta = mL^2\ddot\theta \\
\frac{d}{dt}\frac{\partial V}{\partial \dot\theta} &= 0 \\
\frac{\partial T}{\partial\theta} &= 0 \\
\frac{\partial V}{\partial\theta} &= mgL \sin\theta
\end{align}
```

Plugging back into the Lagrange, we get.
```math
\begin{align}
mL^2\ddot\theta -mgL\sin\theta &=0 \\
\ddot\theta &= \frac{g}L\sin\theta
\end{align}
```

And splitting up into first order terms again, we end up with
```math
\frac{d}{dt}\left [\matrix{ x \\ v } \right ]=
   \left [ \matrix{ f_1(x,v) \\ f_2(x,v) } \right ]
```
where ``f_1(x,v)= v`` and ``f_2(x,v)= (g/L)sin(x) - dv`` (we just tossed in some dampening after the fact for fun).  These are no longer linear equations, so we can't specify these in matrix form, but we can still create this composite function, and see what the solver does.
"

# ╔═╡ 96058eda-48b1-11eb-2490-87a1b81a6aba
begin
	g= -9.8
	L= 1
	d= 0.05
	
	function f(u,p,t)
		dx= u[2]
		dv= (g/L) * sin( u[1] ) - d * u[2]
		[dx, dv]
	end
	
	u₀ = [ π/4, 0 ]
	tspan= (0., 200.)
	prob= ODEProblem( f, u₀, tspan )
	sol= solve( prob, Tsit5(), saveat= 0.1 )
	plot( sol, lab=["x" "v"] )
end

# ╔═╡ fb7a11dc-48b1-11eb-1072-a56cbd12ab5d
let
	solm= Array(sol)
	plotly()
	plot( sol.t, solm[1,:], solm[2,:], lab="")
end

# ╔═╡ Cell order:
# ╠═a0f32984-4897-11eb-1b92-c9ee11aca24a
# ╟─deec1e74-489b-11eb-1bf8-0ddc4fb444c2
# ╠═96058eda-48b1-11eb-2490-87a1b81a6aba
# ╠═fb7a11dc-48b1-11eb-1072-a56cbd12ab5d
