### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# ╔═╡ f63fac3c-285d-11eb-2e03-e1457ba87f04
## Matrix diagnostics - determinant and condition numbers
#
# https://www.youtube.com/watch?v=yh68lAxsDQE
# https://www.youtube.com/watch?v=1aUD3bYbrjY

begin
	using LinearAlgebra
	using Random
end

# ╔═╡ 4742be70-2875-11eb-28d2-a70eaca3146a
begin
	A1 = [0.00001 1; 1 1]
	A2 = [1 1; 1 1.00001]
	
	b= [2; 2]
	Δb= [0; 0.0001]
end	

# ╔═╡ fc8a7dc6-2877-11eb-2dfd-618435aea4d0
det(A1), det(A2)  # zero is unsolvable

# ╔═╡ 6fbffa46-2878-11eb-3603-49c2f923d596
cond(A1), cond(A2)  # large is bad

# ╔═╡ 8864f994-2879-11eb-2a47-959d8dad959b
( A1 \ b ), ( A2 \ b )

# ╔═╡ 9560e8ce-2879-11eb-2b7e-3ffdf3ebba42
( A1 \ (b+Δb) ), ( A2 \ (b+Δb) )

# ╔═╡ d1ddfa56-287b-11eb-3d65-11ccfad1b734
eigen(A1), eigen(A2)

# ╔═╡ Cell order:
# ╠═f63fac3c-285d-11eb-2e03-e1457ba87f04
# ╠═4742be70-2875-11eb-28d2-a70eaca3146a
# ╠═fc8a7dc6-2877-11eb-2dfd-618435aea4d0
# ╠═6fbffa46-2878-11eb-3603-49c2f923d596
# ╠═8864f994-2879-11eb-2a47-959d8dad959b
# ╠═9560e8ce-2879-11eb-2b7e-3ffdf3ebba42
# ╠═d1ddfa56-287b-11eb-3d65-11ccfad1b734
