### A Pluto.jl notebook ###
# v0.12.19

using Markdown
using InteractiveUtils

# ╔═╡ 3c30e4b0-6051-11eb-05c0-4b42d0d30940
## Fast Fourier Transform
#
# https://www.youtube.com/watch?v=1tx0LPJowMo

# Music Sample Echo II by Crowander (https://crowander.com/) CC BY-NC4

begin
	using Plots
	using Random
	using FFTW
	using SampledSignals
	using DSP
	using FileIO: load
	using LibSndFile
end

# ╔═╡ e306fbdc-6059-11eb-28f5-63658a179307
begin
	Δt= 0.001
	T= 0:Δt:0.4
	
	signal = @. sin(2π*50T) + sin(2π*120T)
	noisy = signal + 2 * randn( length(T) )
end

# ╔═╡ 5eacf886-605f-11eb-0474-7ddb9089e726
md"If you run enough different cases, sometimes you will see the two fundamental frequencies with enough power to be selected, sometimes only one will be selected."

# ╔═╡ e643d994-6137-11eb-3c79-c385cbed3a8f
md"We can also process audio from files (wav or ogg)."

# ╔═╡ 544de61e-6129-11eb-0924-e7d6a444f98b
audio= load("echoii.ogg")

# ╔═╡ c591f7a2-6129-11eb-25d8-35d4f3f2c11d
begin
	gr()
	plot( audio[:, 1] )
end

# ╔═╡ ff1c1198-6137-11eb-02c9-f71a4660d236
md"And by doing an fft on blocks of samples moving through the file, we can build up a picture of its spectral content over time."

# ╔═╡ dd7e557a-612b-11eb-0348-2bee57f536d8
let
	S= spectrogram( audio[:,1], 11025, 5512; fs=44100, window=lanczos )
	pw= DSP.pow2db.(S.power)
	gr()
	heatmap( pw, ylim=(0, 800) )
end

# ╔═╡ 0f95d198-605d-11eb-27c1-95ad077bb4bd
# plot helper
plbundle(a, b...) = reshape( [a ; b... ], :, 1+length(b) )

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
# ╟─e643d994-6137-11eb-3c79-c385cbed3a8f
# ╠═544de61e-6129-11eb-0924-e7d6a444f98b
# ╠═c591f7a2-6129-11eb-25d8-35d4f3f2c11d
# ╟─ff1c1198-6137-11eb-02c9-f71a4660d236
# ╠═dd7e557a-612b-11eb-0348-2bee57f536d8
# ╠═0f95d198-605d-11eb-27c1-95ad077bb4bd
