### A Pluto.jl notebook ###
# v0.12.7

using Markdown
using InteractiveUtils

# ╔═╡ c45132e0-2178-11eb-35d0-5d7d7fe035bf
begin
	using Plots
	using Random
	using Statistics
	using BenchmarkTools
	using LinearAlgebra
end

# ╔═╡ 6e1e7800-220a-11eb-1a6c-27f61fef490d
begin
	A = 2 * rand(10^5)
	v = sqrt(mean(A .^ 2. ))
end

# ╔═╡ c29dde50-220c-11eb-1d8b-1be102884039
Tb0 = @benchmarkable sqrt( mean( $A .^ 2.)) ; run( Tb0, seconds=1, samples=8 )

# ╔═╡ 013b0850-220c-11eb-045f-1d8806443ffa
Tb1 = @benchmarkable sqrt(sum(x->x^x, $A)/ length($A)) ; run( Tb1, seconds=1, samples=8 )

# ╔═╡ a5427500-220c-11eb-0f7a-db97f380ef6f
Tb2= @benchmarkable norm($A) / sqrt(length($A)) ; run( Tb2, seconds=1, samples=8 )

# ╔═╡ f14fc1a0-220c-11eb-098a-558458ecff16
begin
	function rms(A)
		s= zero(eltype(A))  # be generic
		@simd for e in A
			s += e * e
		end
		sqrt( s / length(A) )
	end
	Tbf = @benchmarkable rms( $A )
	run( Tbf, seconds=1, samples=8 )
end

# ╔═╡ Cell order:
# ╠═c45132e0-2178-11eb-35d0-5d7d7fe035bf
# ╠═6e1e7800-220a-11eb-1a6c-27f61fef490d
# ╠═c29dde50-220c-11eb-1d8b-1be102884039
# ╠═013b0850-220c-11eb-045f-1d8806443ffa
# ╠═a5427500-220c-11eb-0f7a-db97f380ef6f
# ╠═f14fc1a0-220c-11eb-098a-558458ecff16
