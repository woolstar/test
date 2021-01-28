### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 0db7db88-607a-11eb-3f43-fb26e748d65f
## Generating the Discrete Fourier Transform
#
# https://www.youtube.com/watch?v=l-kH5h387bo

begin
	using Plots
	using Random
	using Colors
	using FFTW
end

# ╔═╡ ff4ce602-607d-11eb-221b-615b28ed4ae5
begin
	n= 512
	ω= exp(-im * 2π / n )
	b= 33  # padding needed to preserve original resolution
end

# ╔═╡ 110e8568-6085-11eb-133d-033c8ccadff0
md"First generate the ``DFT`` using a julia for loop iterating through all the cells of the matrix."

# ╔═╡ 7e7691e8-607a-11eb-339d-fdcd48349ba5
let
	M= im .* zeros(n, n)
	for i ∈ CartesianIndices(M)
		(u,v)=Tuple(i)
		M[ i]= ω^((u-1)*(v-1))
	end
	
	heatmap( real.(M), legend=false, axis=nothing, border=:none,
		aspect_ratio=:equal, size=(n+b,n+b) )
end

# ╔═╡ 3559fe9a-6085-11eb-0083-b98d4fca9337
md"But of course a better way is to use list comprehension, this time lets plot the angle just for fun."

# ╔═╡ f08c357a-607d-11eb-39b4-cd6d9fd06342
let
	M= [ω^((u-1)*(v-1)) for u ∈ 1:n, v ∈ 1:n]
	
	heatmap( angle.(M),	legend=false, axis=nothing, border=:none,
		aspect_ratio=1, size=(n+b,n+b) )
end

# ╔═╡ 4d863c36-6085-11eb-3c90-8f78a4e964b2
md"Try another visualization mechanism, this time convolving a color primative by the matrix.  Unfortunately there's less control over scaling."

# ╔═╡ 63795ffc-6083-11eb-3efa-cf13f0d313b4
let
	n= 128
	ω= exp(-im * 2π / n )
	M= [ω^((u-1)*(v-1)) for u ∈ 1:n, v ∈ 1:n]
	Gray.(real.(M))
end

# ╔═╡ 6d82605a-6085-11eb-3c5d-9185691e42d3
md"Do the test of comparing the dft with the fft, also plotting the difference."

# ╔═╡ fb6748ec-6083-11eb-102b-d3b98d0e805d
begin
	boring= ones(n)
	M= [ω^((u-1)*(v-1)) for u ∈ 1:n, v ∈ 1:n]
	
	f1= fft( boring )
	pw1= @. abs(f1) / n
	
	f2= M * boring
	pw2= @. abs(f2) / n
	
	pw1 ≈ pw2
end

# ╔═╡ a001d0d2-6084-11eb-0a26-9f8c3d392f91
plot( pw1 .- pw2, size=(400, 220), lab="", title="Error" )

# ╔═╡ Cell order:
# ╠═0db7db88-607a-11eb-3f43-fb26e748d65f
# ╠═ff4ce602-607d-11eb-221b-615b28ed4ae5
# ╟─110e8568-6085-11eb-133d-033c8ccadff0
# ╠═7e7691e8-607a-11eb-339d-fdcd48349ba5
# ╟─3559fe9a-6085-11eb-0083-b98d4fca9337
# ╠═f08c357a-607d-11eb-39b4-cd6d9fd06342
# ╟─4d863c36-6085-11eb-3c90-8f78a4e964b2
# ╠═63795ffc-6083-11eb-3efa-cf13f0d313b4
# ╟─6d82605a-6085-11eb-3c5d-9185691e42d3
# ╠═fb6748ec-6083-11eb-102b-d3b98d0e805d
# ╠═a001d0d2-6084-11eb-0a26-9f8c3d392f91
