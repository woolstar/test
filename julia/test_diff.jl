### A Pluto.jl notebook ###
# v0.12.11

using Markdown
using InteractiveUtils

# ╔═╡ 88c90c22-30b5-11eb-1dce-7bb65c29c992
using Pkg; Pkg.add("ForwardDiff")

# ╔═╡ 8a5e717e-30b1-11eb-01fa-fb14bb6a7392
begin
	using Plots
	using LinearAlgebra
	using Statistics
	using Polynomials
	using Optim
	using ForwardDiff
end

# ╔═╡ 1532658a-30b5-11eb-07ef-858fd6433834
begin
	x_hat= -3:.05:3
	f(x)= 2 * exp( - x * x )
	plot( x_hat, f )
end

# ╔═╡ 31100318-30b5-11eb-3738-3df76541d419
let
	g = x-> ForwardDiff.derivative( f, x )
	plot( x_hat, g )
end

# ╔═╡ Cell order:
# ╠═88c90c22-30b5-11eb-1dce-7bb65c29c992
# ╠═8a5e717e-30b1-11eb-01fa-fb14bb6a7392
# ╠═1532658a-30b5-11eb-07ef-858fd6433834
# ╠═31100318-30b5-11eb-3738-3df76541d419
