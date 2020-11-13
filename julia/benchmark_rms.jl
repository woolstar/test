### A Pluto.jl notebook ###
# v0.12.10

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

# ╔═╡ 910bbf8a-2566-11eb-20fe-093a58757d39
begin
	using Libdl ;
	cleanuplibs = [] ;
	
	## make copies of the source library so changes between runs are loaded
	function templib(Name)
		temp = tempname() ;
		fi = string( temp, ".", Libdl.dlext )
		cp( Name, fi )
		push!(cleanuplibs, fi )
		temp
	end
	function tempclean()
		map( rm, cleanuplibs )
		global cleanuplibs = []
	end
end

# ╔═╡ 6e1e7800-220a-11eb-1a6c-27f61fef490d
begin
	const A = 2 * rand(7 * 10^5)
	
	sqrt(mean(A .^ 2. )),
	sqrt(sum(x->x^x, A)/ length(A)),
	norm(A) / sqrt(length(A))
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
	run( Tbf, seconds=2, samples=64 )
end

# ╔═╡ 8415c05a-254d-11eb-16bb-e38e55c989ef
if ( isfile( "native_rms_clang.so" ) )
	const Lib_clang_temp= templib("native_rms_clang.so")
	c_rms( X::Array{Float64} )=
		ccall(( :c_rms, Lib_clang_temp ),
				Float64, (Csize_t, Ptr{Float64},), length(X), X )
	c_rmsv( X::Array{Float64} )=
		ccall(( :c_rmsv, Lib_clang_temp ),
				Float64, (Csize_t, Ptr{Float64},), length(X), X )
	Tbn = @benchmarkable c_rms( $A ); Tbnv = @benchmarkable c_rmsv( $A )
	let a =run( Tbn, samples=64 ), b= run( Tbnv, samples=64 )
		tempclean()
		a,b
	end
end

# ╔═╡ 02bf27d0-2555-11eb-297b-c76a478eed30
if ( isfile( "native_rms_gcc.so" ) )
	const Lib_gcc_tmp= templib("native_rms_gcc.so") ;
	g_rms( X::Array{Float64} )=
		ccall(( :c_rms, Lib_gcc_tmp ),
				Float64, (Csize_t, Ptr{Float64},), length(X), X )
	g_rmsv( X::Array{Float64} )=
		ccall(( :c_rmsv, Lib_gcc_tmp ),
				Float64, (Csize_t, Ptr{Float64},), length(X), X )
	Tbng = @benchmarkable g_rms( $A ); Tbngv = @benchmarkable g_rmsv( $A )
	let a =run( Tbng, seconds=2, samples=64 ), b= run( Tbngv, seconds=2, samples=64 )
		tempclean()
		a,b
	end
end

# ╔═╡ Cell order:
# ╠═c45132e0-2178-11eb-35d0-5d7d7fe035bf
# ╠═6e1e7800-220a-11eb-1a6c-27f61fef490d
# ╠═c29dde50-220c-11eb-1d8b-1be102884039
# ╠═013b0850-220c-11eb-045f-1d8806443ffa
# ╠═a5427500-220c-11eb-0f7a-db97f380ef6f
# ╠═f14fc1a0-220c-11eb-098a-558458ecff16
# ╠═8415c05a-254d-11eb-16bb-e38e55c989ef
# ╠═02bf27d0-2555-11eb-297b-c76a478eed30
# ╠═910bbf8a-2566-11eb-20fe-093a58757d39
