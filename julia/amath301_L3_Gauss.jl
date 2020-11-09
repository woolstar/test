### A Pluto.jl notebook ###
# v0.12.6

using Markdown
using InteractiveUtils

# ╔═╡ 46b28280-1f2f-11eb-190d-a34cdd57bab4
## Gaussian Elimination
#
# https://www.youtube.com/watch?v=IQOUoTQd7Y8

begin
	using LinearAlgebra
	using Random
end

# ╔═╡ ff814270-1f2e-11eb-0117-c962c963371d
begin
	A = [ 1 1 1 ; 1 2 4 ; 1 3 9 ]
	b = [ 1; -1; 2 ]
	
	x = A \ b
end

# ╔═╡ 5d0673c0-1f2f-11eb-0b37-4f3d769cb246
begin
	Abad = [ 1 1 1 ; 1 2 4 ; 2 2 2 ]
	det( Abad )
end

# ╔═╡ 8bd92580-1f2f-11eb-25af-c9ea3c6b4742
cond( A )

# ╔═╡ 8fc294b0-1f2f-11eb-02bb-e14f3217e323
cond( Abad )

# ╔═╡ bde4e230-1f2f-11eb-0155-7be08a6d7de9
begin
	Arand = rand( 5000, 5000 )
	bᵣ = rand( 5000 )
	
	xᵣ = Arand \ bᵣ
end

# ╔═╡ 127fdc3e-1f31-11eb-04c6-19562af189e2
(L,U)= lu( A )

# ╔═╡ 43ce6370-1f31-11eb-1801-775a33824d85
(Lr,Ur,p)= lu( Arand )

# ╔═╡ 8a4442c0-1f31-11eb-1891-af29d7982bb4
p

# ╔═╡ Cell order:
# ╠═46b28280-1f2f-11eb-190d-a34cdd57bab4
# ╠═ff814270-1f2e-11eb-0117-c962c963371d
# ╠═5d0673c0-1f2f-11eb-0b37-4f3d769cb246
# ╠═8bd92580-1f2f-11eb-25af-c9ea3c6b4742
# ╠═8fc294b0-1f2f-11eb-02bb-e14f3217e323
# ╠═bde4e230-1f2f-11eb-0155-7be08a6d7de9
# ╠═127fdc3e-1f31-11eb-04c6-19562af189e2
# ╠═43ce6370-1f31-11eb-1801-775a33824d85
# ╠═8a4442c0-1f31-11eb-1891-af29d7982bb4
