### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ fe1d9766-4329-11eb-01e3-cde4ce25dc8e
## Numerical Differentiation
#
# https://www.youtube.com/watch?v=tcqsLqIyjmk

begin
	using Plots
	using Polynomials
end

# ╔═╡ 4e269672-432a-11eb-2835-6773e2a3f8c1
# looking at sin wave
plot( sin )

# ╔═╡ 89da7d14-432a-11eb-1f0a-5b1652cad850
md"The taylor series for ``sin(\theta)`` is
```math
{\theta\over 1!} -
{\theta^3\over 3!} +
{\theta^5\over 5!} -
{\theta^7\over 7!} + ...
```

I'm too lazy to type out all the factorials, and in fact its sloppy to calculate ``5!`` and then calculate ``7!`` from scatch when you could just add two terms to ``5!``.  So lets create an engine that constructs:

```math
\sum_{i=0}^n {a_i x^i \over i!}
```
Now Julia already has the `Poly()` function which takes polynomial coefficients, we just have to translate ``a_i`` into ``a_i/i!`` which we can feed to `Poly` and have our function.
"

# ╔═╡ 1b6402f4-4331-11eb-3c2d-2face47fb3c6
begin
	function taylor_function( a_v )
		n= 0
		nprod= 1
		v= Float64[]
		for a in a_v
			push!( v, a / nprod )
			n += 1
			nprod *= n
		end
		Poly(v)
	end
	
	taylor_function( [0 1 0 -1 0 1 0 -1] )
end

# ╔═╡ f7a0d6ce-434b-11eb-171e-c5bba2aa7f1b
md"We evaulate each function point-wise for ``range`` and then assemble them in a matrix with `hcat()` just because that's how `plot()` likes data."

# ╔═╡ 8eec58ac-4331-11eb-1de9-e5a5379a0803
let
	range= -3π/2:0.01:3π/2
	plot( range, hcat( sin.(range),
						taylor_function([0 1 0 -1]).(range),
						taylor_function([0 1 0 -1 0 1 0 -1]).(range),
						taylor_function([0 1 0 -1 0 1 0 -1 0 1 0 -1]).(range)),
		  lab= ["sin" "2nd Taylor" "4th Taylor" "6th Taylor"]
		)
end

# ╔═╡ da117f06-4347-11eb-2d06-95c652b1e42a
md"""
----
## Finite differences
"""

# ╔═╡ f69cf7d4-4347-11eb-1b6c-6924295b6899
begin
	Δt= 0.25
	t= -π:Δt:2π
end

# ╔═╡ aaa22a7c-4348-11eb-0f6a-b1f19b7d3243
let
	δ_forward(x) = (sin(x+Δt) -sin(x)) / Δt
	δ_backward(x) = (sin(x) - sin(x-Δt)) / Δt
	δ_central(x) = (sin(x+Δt) - sin(x-Δt)) / 2Δt

	plot( t, hcat( sin.(t),
				cos.(t),
				δ_forward.(t),
				δ_backward.(t),
				δ_central.(t)
			 ),
			lab= ["original func" "ideal diff" "fwd diff" "back diff" "central diff"]
	)
end

# ╔═╡ Cell order:
# ╠═fe1d9766-4329-11eb-01e3-cde4ce25dc8e
# ╠═4e269672-432a-11eb-2835-6773e2a3f8c1
# ╟─89da7d14-432a-11eb-1f0a-5b1652cad850
# ╠═1b6402f4-4331-11eb-3c2d-2face47fb3c6
# ╟─f7a0d6ce-434b-11eb-171e-c5bba2aa7f1b
# ╠═8eec58ac-4331-11eb-1de9-e5a5379a0803
# ╟─da117f06-4347-11eb-2d06-95c652b1e42a
# ╠═f69cf7d4-4347-11eb-1b6c-6924295b6899
# ╠═aaa22a7c-4348-11eb-0f6a-b1f19b7d3243
