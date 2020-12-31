### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 5caebbf0-48cc-11eb-1503-a17601ffbec7
## Using Differential Equations Solver
#
# https://www.youtube.com/watch?v=xA91bCcMpb0

begin
	using Plots
	using Random
	using DifferentialEquations
end

# ╔═╡ e2f3fbf8-48cc-11eb-20cb-4f1aa24c03a5
md"### Solving systems of ODEs

Lets work with [Van der Pol oscillators](https://en.wikipedia.org/wiki/Van_der_Pol_oscillator)

```math
\ddot x - \mu(1-x^2)\dot x + x=0
```

Of course we first break it up into ``x`` and ``v``, and so we end up with

```math
\frac{d}{dt}\left [\matrix{ x \\ v } \right ]=
   \left ( \matrix{ v \\ \mu(1-x^2)v-x } \right )
```

`DifferentialEquations` wants our function to be written in terms if ``u``, ``p``, ``t`` (our coordinates, optional parameters, and time).  In this case, as our system of equations are independent, we'd just like to write out the equations above, so using a handy macro from `ParameterizedFunctions`, we can write:
"

# ╔═╡ b40ffe3a-48cd-11eb-11dc-a16f43cfa49d
begin
	vdp= @ode_def begin
		dx= y
		dy= μ*(1-x^2)*y -x
	end μ
end

# ╔═╡ 489c15f0-4943-11eb-2038-258706a375d9
let
	μ= 7
	u₀= [-1.5, 6]
	prob= ODEProblem( vdp, u₀, (0., 40.), ( μ ) )
	sol= solve( prob )
	plotly()
	plot( sol, vars=(0,1,2) )
end

# ╔═╡ ae728b78-48cd-11eb-0c07-07cf91b7b712
let
	t=( 0., 50.)
	gr()
	graph= scatter( [0.], [0.], lab= "" )
	
	for i in 1:50
		u₀= 2 * rand( 2 ) .- 1
		prob_vdp= ODEProblem( vdp, u₀, t, ( 1.8 ) )
		sol= solve( prob_vdp )
		plot!( graph, sol, vars=(1,2), lab="" )
	end
	graph
end

# ╔═╡ Cell order:
# ╠═5caebbf0-48cc-11eb-1503-a17601ffbec7
# ╟─e2f3fbf8-48cc-11eb-20cb-4f1aa24c03a5
# ╠═b40ffe3a-48cd-11eb-11dc-a16f43cfa49d
# ╠═489c15f0-4943-11eb-2038-258706a375d9
# ╠═ae728b78-48cd-11eb-0c07-07cf91b7b712
