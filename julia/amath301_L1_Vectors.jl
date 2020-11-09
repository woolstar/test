### A Pluto.jl notebook ###
# v0.12.6

using Markdown
using InteractiveUtils

# ╔═╡ df2df3b0-1f1f-11eb-1ea6-7fd0ab74cdaa
## Some vector noodling
#
# https://www.youtube.com/watch?v=-lCHw8Kzpok

# ╔═╡ cdc451c0-1f1d-11eb-04d4-29ddc5d02ff7
A= [1 3 4; 8 9 0; 2 5 6]

# ╔═╡ 2aa812f0-1f1e-11eb-38fb-9fe0d84b5815
B= A[2:3,2:3]  

# ╔═╡ 3f81e750-1f1e-11eb-1b54-c7262c509bf4
A'  ## transpose

# ╔═╡ 6cc6cd20-1f1e-11eb-3c4b-2353982bda7e
begin
	x= [-2 0 -1 1 0 3 4 -3]
	b= (x .> 0)  ## vectorized dot version
end

# ╔═╡ Cell order:
# ╠═df2df3b0-1f1f-11eb-1ea6-7fd0ab74cdaa
# ╠═cdc451c0-1f1d-11eb-04d4-29ddc5d02ff7
# ╠═2aa812f0-1f1e-11eb-38fb-9fe0d84b5815
# ╠═3f81e750-1f1e-11eb-1b54-c7262c509bf4
# ╠═6cc6cd20-1f1e-11eb-3c4b-2353982bda7e
