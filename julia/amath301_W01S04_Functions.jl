### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# ╔═╡ 240e4716-27db-11eb-2dd6-b737c4402639
using Plots

# ╔═╡ e06484f8-27d8-11eb-2b87-35f928532780
## functions
#
# https://www.youtube.com/watch?v=soYRopa7pSA

# ╔═╡ f9fec520-27d8-11eb-31f3-ff76571747cd
begin
	function f1(x)
		sin(x)
	end
	
	f2(x)=sin(x)
	
	f3 = x->sin(x)
	
	f1(π/2),f2(π/2),f3(π/2)
end

# ╔═╡ 6a66ceea-27d9-11eb-07e0-d94ec1cbe953
ex= Meta.parse("x->sin(x)")

# ╔═╡ a2809b8a-27d9-11eb-054e-177d5f36e24f
Meta.parse("f(x)=sin(x)")

# ╔═╡ bf6452c8-27d9-11eb-3466-d32295c9221c
eval(ex)(π/2)

# ╔═╡ bf5ad13e-27da-11eb-3477-753b670976ba
macro f4( v )
	return :( sin( $v ))
end

# ╔═╡ f41aef9e-27da-11eb-19d5-c9b86192917d
@f4(π/2)

# ╔═╡ d5965a94-27db-11eb-1c9a-fbdf195a658d
plot(f1,lab="sin")

# ╔═╡ aa3fe328-27dc-11eb-25c3-17a734f82829
plot(0:0.01:10, f2, lab="sin")

# ╔═╡ ccb33446-27dc-11eb-2bf1-6b7db67ffada
plot(@f4)  ## can't plot a macro

# ╔═╡ fbbdd640-27dc-11eb-326d-6df82d5b63ab
begin
	A = [1 2 ; 3 4 ]
	x = [1 ; 2]
	
	multA( x ) = A*x
	multA( x ), multA( [ 5 6 ; 8 9 ] )
end

# ╔═╡ 7cd39a66-27dd-11eb-3dbe-6740269f2111
begin
	f(t,θ)= t*sin(θ)
	g(ϕ)=f(5,ϕ)
	
	g(10),f(5,10)
end

# ╔═╡ Cell order:
# ╠═e06484f8-27d8-11eb-2b87-35f928532780
# ╠═240e4716-27db-11eb-2dd6-b737c4402639
# ╠═f9fec520-27d8-11eb-31f3-ff76571747cd
# ╠═6a66ceea-27d9-11eb-07e0-d94ec1cbe953
# ╠═a2809b8a-27d9-11eb-054e-177d5f36e24f
# ╠═bf6452c8-27d9-11eb-3466-d32295c9221c
# ╠═bf5ad13e-27da-11eb-3477-753b670976ba
# ╠═f41aef9e-27da-11eb-19d5-c9b86192917d
# ╠═d5965a94-27db-11eb-1c9a-fbdf195a658d
# ╠═aa3fe328-27dc-11eb-25c3-17a734f82829
# ╠═ccb33446-27dc-11eb-2bf1-6b7db67ffada
# ╠═fbbdd640-27dc-11eb-326d-6df82d5b63ab
# ╠═7cd39a66-27dd-11eb-3dbe-6740269f2111
