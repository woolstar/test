### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 3c30e4b0-6051-11eb-05c0-4b42d0d30940
## Fast Fourier Transform
#
# https://www.youtube.com/watch?v=1tx0LPJowMo

begin
	using Plots
	using Random
	using FFTW
	using SampledSignals
	
end

# ╔═╡ e306fbdc-6059-11eb-28f5-63658a179307
begin
	Δt= 0.001
	T= 0:Δt:0.3
	
	signal = @. sin(2π*50T) + sin(2π*120T)
	noisy = signal + 2 * randn( length(T) )
end

# ╔═╡ 5eacf886-605f-11eb-0474-7ddb9089e726
md"If you run enough different cases, sometimes you will see the two fundamental frequencies with enough power to be selected, sometimes only one will be selected."

# ╔═╡ 0f95d198-605d-11eb-27c1-95ad077bb4bd
function plbundle(a, b...)
	reshape( [a ; b... ], :, 1+length(b) )
end

# ╔═╡ 347a3c98-605a-11eb-3404-f77168188e69
let
	plotly()
	plot( T, plbundle( signal, noisy ), lab=["original" "noisy"], size=(670,300))
end

# ╔═╡ b3b0d32a-605a-11eb-27a5-e5cb2eca13a2
begin
	freq= fft( noisy )
	power= abs2.( freq ) ./ length(signal)
	strong= power .> 50
	filtpower = power .* strong
	filtsignal= real.( ifft( freq .* strong ) )
	let
		n= length( power ) ÷ 2
		plot( plbundle( power[1:n], filtpower[1:n]),
			lab="", title="Power", size=(600,200) )
	end
end

# ╔═╡ 954dd54c-605d-11eb-3f2e-29107c94e9d1
plot( T[100:200], plbundle( signal[100:200], noisy[100:200], filtsignal[100:200]),
					lab=["original" "noisy" "filtered"])


# ╔═╡ Cell order:
# ╠═3c30e4b0-6051-11eb-05c0-4b42d0d30940
# ╠═e306fbdc-6059-11eb-28f5-63658a179307
# ╠═347a3c98-605a-11eb-3404-f77168188e69
# ╠═954dd54c-605d-11eb-3f2e-29107c94e9d1
# ╟─5eacf886-605f-11eb-0474-7ddb9089e726
# ╠═b3b0d32a-605a-11eb-27a5-e5cb2eca13a2
# ╠═0f95d198-605d-11eb-27c1-95ad077bb4bd
