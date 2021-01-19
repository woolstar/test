### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 8ca81458-508a-11eb-3c89-ad1e2a0d0370
begin
	using Random
	using BenchmarkTools
end

# ╔═╡ 96dea4a0-508a-11eb-2552-1596fb728b12
md"Some very basic tests."

# ╔═╡ 9fd9d6d8-508a-11eb-3923-99a9e939bbb5
let
	U= rand(100,100)
	
	@benchmark size($U)
end

# ╔═╡ fa3a7da6-508a-11eb-15f4-430cd22a600f
let
	U= rand(500,500)
	
	U3d= rand(100,100,100)
	
	( @benchmark vec($U) ), (@benchmark vec($U3d))
end

# ╔═╡ 126a105a-508b-11eb-16f3-9be492abb8a8
let
	U= rand(200,200)
	
	( @benchmark reshape($U, 100, :) samples=25 evals=100 ),
	( @benchmark reshape($U, :, 100) samples=25 evals=100 )
end

# ╔═╡ 533ce7b0-508b-11eb-086c-bfbfb376ecda
let
	U= rand(200,200)
	
	@benchmark reshape(vec($U), 200, :) samples=100 evals=20
end

# ╔═╡ 6e752c0e-508b-11eb-1079-69912cefff4f
let
	U= [[i, 1-i] for i in rand(10000) ]
	
	@benchmark collect(hcat( $U... )') samples=20 evals=1
end

# ╔═╡ Cell order:
# ╠═8ca81458-508a-11eb-3c89-ad1e2a0d0370
# ╟─96dea4a0-508a-11eb-2552-1596fb728b12
# ╠═9fd9d6d8-508a-11eb-3923-99a9e939bbb5
# ╠═fa3a7da6-508a-11eb-15f4-430cd22a600f
# ╠═126a105a-508b-11eb-16f3-9be492abb8a8
# ╠═533ce7b0-508b-11eb-086c-bfbfb376ecda
# ╠═6e752c0e-508b-11eb-1079-69912cefff4f
