### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# ╔═╡ 1ef50f2a-2852-11eb-182b-63183ca9b1e0
## Matrix models
#
# https://www.youtube.com/watch?v=s7Lb8ISR-Z0

begin
	using LinearAlgebra
	using Random
	using Plots
end

# ╔═╡ 41011d5c-2852-11eb-2de6-a12552065b6d
md"A simple weather model

```math
\vec{x}_{today} = { \left[ \begin{array}{ c } 0 \\ 1 \\ 0 \end{array}\right] }
 \begin{array}{l} rain \\ clear \\ cloudy \end{array}
```

And a transformation matrix:
```math
A_{tomorrow}=\left[ \begin{array}{lll} 0.5&0.4&0.2 \\ 0.25&0&0.3 \\ 0.25&0.6&0.5 \end{array} \right]
```"

# ╔═╡ 3c79c54e-2858-11eb-3189-e77b00300473
begin
	A = [ 0.5 0.4 0.2 ;
		  0.25 0 0.3 ;
		  0.25 0.6 0.5 ]
	x₀= [ 0; 1; 0 ]
	weather= []
	
	let x= x₀
		for t in 1:10
			xn= A * x
			push!(weather, x')
			x= xn
		end
	end
	plot( [[ p[1] for p in weather ],
		  [ p[2] for p in weather ], 
		  [ p[3] for p in weather ]],
			lab = ["rain" "clear" "clouldy"]
	)
end

# ╔═╡ Cell order:
# ╠═1ef50f2a-2852-11eb-182b-63183ca9b1e0
# ╟─41011d5c-2852-11eb-2de6-a12552065b6d
# ╠═3c79c54e-2858-11eb-3189-e77b00300473
