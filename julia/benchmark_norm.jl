### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 66ae55ba-5091-11eb-0cd7-755689e880e4
begin
	using Random
	using Statistics
	using LinearAlgebra
	using LoopVectorization
	using BenchmarkTools
	using Plots
end

# ╔═╡ e084ea70-5179-11eb-2449-f7d4ba86b3b6
begin
	function jnorm(A)
		norm(A)
	end
	
	function jnaivnorm(A)
		∑= 0.
		for i ∈ A
			∑ += i * i
		end
		sqrt( ∑ )
	end
	
	function jsimdnorm(A)
		∑= 0.
		@simd for i ∈ A
			∑ += i * i
		end
		sqrt( ∑ )
	end
	
	function javxnorm(A)
		∑= 0.
		@avx for i ∈ eachindex(A)
			∑ += A[i] * A[i]
		end
		sqrt( ∑ )
	end
	
	function jsumnorm(A)
		sqrt( sum( abs2, A ))
	end
end
		

# ╔═╡ 2c55099e-517a-11eb-2e72-f9681bf2a702
let
	U= rand(64)
	i= 80 ; j= 50

	( @benchmark jnorm($U) samples=i evals=j ),
	( @benchmark jnaivnorm($U) samples=i evals=j ),
	( @benchmark jsimdnorm($U) samples=i evals=j ),
	( @benchmark javxnorm($U) samples=i evals=j ),
	( @benchmark jsumnorm($U) samples=i evals=j ),
	jnorm(U) ≈ jnaivnorm(U)
end

# ╔═╡ da7f0c58-517b-11eb-2e9d-5f5134a10bae
let
	U= rand(2^14)
	
	a= @benchmark jnorm($U) samples=48 evals=10
	sort(a.times)[1:4]
end

# ╔═╡ c5ba20a6-517c-11eb-1d27-2b9747b32f60
begin
	function bench_range( f, range )
		times= Float64[]
		for n in range
			U= rand(n)
			perf= @benchmark $f($U) samples=200 evals=8
			t= sort(perf.times)
			push!(times, max(1, sum(t[1:4]))/(4. * n ))
		end
		times
	end
end

# ╔═╡ 4c6b074e-517d-11eb-3d89-050dca9918b2
let
	range= 16:16:1024
	
	U= [ bench_range( jnorm, range ) ;
		bench_range( jsumnorm, range ) ;
		bench_range( jsimdnorm, range ) ;
		bench_range( javxnorm, range )			
		]
	T= reshape( U , size(range,1), : )
	plot( range, T, lab=["norm" "sum" "simd" "avx"] )
end

# ╔═╡ Cell order:
# ╠═66ae55ba-5091-11eb-0cd7-755689e880e4
# ╠═e084ea70-5179-11eb-2449-f7d4ba86b3b6
# ╠═2c55099e-517a-11eb-2e72-f9681bf2a702
# ╠═da7f0c58-517b-11eb-2e9d-5f5134a10bae
# ╠═c5ba20a6-517c-11eb-1d27-2b9747b32f60
# ╠═4c6b074e-517d-11eb-3d89-050dca9918b2
