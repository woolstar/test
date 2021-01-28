### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 7bcbdd30-6044-11eb-2fab-cbcff88c3ad9
## Fourier Transform Theory
#
# https://www.youtube.com/watch?v=YOWLoNQDFsk

begin
	using Plots
	using Random
	using FFTW
end

# ╔═╡ 20484a46-6046-11eb-3dd8-9392430c607d
begin
	Δt= 0.001
	T= 0:Δt:1
	
	signal = @. sin(2π*50T) + sin(2π*120T)
end

# ╔═╡ 6317458e-6046-11eb-0272-ffbd50d9148c
let
	plot( signal )
end

# ╔═╡ 8c2eef6c-6046-11eb-1e09-9356910ad345
let
	freq= fft( signal )
	power= abs2.( freq ) ./ length(signal)
	plot( power[1:500], lab="", title="Power" )
end

# ╔═╡ Cell order:
# ╠═7bcbdd30-6044-11eb-2fab-cbcff88c3ad9
# ╠═20484a46-6046-11eb-3dd8-9392430c607d
# ╠═6317458e-6046-11eb-0272-ffbd50d9148c
# ╠═8c2eef6c-6046-11eb-1e09-9356910ad345
