### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# ╔═╡ dd523fdc-284c-11eb-0d97-83077fa26d2c
## LU Decomposition
#
# https://www.youtube.com/watch?v=CNoc2sEEScA
# https://www.youtube.com/watch?v=eZPR0OpGTIs

begin
	using LinearAlgebra
	using Random
end

# ╔═╡ f3cb93e6-284c-11eb-1feb-49d06259d890
md"Lets start with the following matrix

```math
A = \left(\begin{array}{rrr} 4&3&-1 \\ -2&-4&5 \\ 1&2&6 \end{array}\right)
```"

# ╔═╡ 6150043c-284e-11eb-19eb-932cc55c405a
begin
	A1 = [ 4 3 -1 ; -2 -4 5 ; 1 2 6 ]
	LUp1 = lu(A1)
end

# ╔═╡ 8015f160-284e-11eb-2705-3551f36d9d1d
LUp1.p  ## pivot is row indexes, not a matrix

# ╔═╡ b3bbc5c6-284e-11eb-07c1-eb07e616d67f
begin
	k= 2000
	A2 = rand(k,k) ;  b = rand(k)
	LUp2= lu( A2 )
	
	t_brute= @elapsed A2 \ b
	t_parts= @elapsed begin y= LUp2.L \ b[LUp2.p] ;  x = LUp2.U \ y ; end
	t_swift= @elapsed LUp2 \ b
	
	t_brute, t_parts, t_swift
end

# ╔═╡ f47e6cec-287d-11eb-3d7d-b9fa8bee1cab
begin
	# we can solve for multiple sets of b all in one go
	b_set= rand(k,100)
	LUp2 \ b_set
end

# ╔═╡ Cell order:
# ╠═dd523fdc-284c-11eb-0d97-83077fa26d2c
# ╟─f3cb93e6-284c-11eb-1feb-49d06259d890
# ╠═6150043c-284e-11eb-19eb-932cc55c405a
# ╠═8015f160-284e-11eb-2705-3551f36d9d1d
# ╠═b3bbc5c6-284e-11eb-07c1-eb07e616d67f
# ╠═f47e6cec-287d-11eb-3d7d-b9fa8bee1cab
