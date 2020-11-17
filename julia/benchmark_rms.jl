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

# ╔═╡ cff325d4-2828-11eb-092e-195721ca7000
md"## Benchmarking root mean square

Benchmarking: ``rms(\vec{x})= \sqrt{ \frac{1}{n} \sum_{i}^{n} x_i^2 }``

Why `rms()`?  Its an interesting function, but not too compilicated.  It doesn't seem to be built in to Julia.  There are a couple different strategies for accomplishing it with the functions that are available.  And it can be run from thousands to billions without too much growth in complexity, so memory performance can be observed as well."

# ╔═╡ 6e1e7800-220a-11eb-1a6c-27f61fef490d
begin
	const A = 2 * rand(5*10^5)
	
	sqrt(mean(A .^ 2. )),
	sqrt(sum(x->x*x, A)/ length(A)),
	norm(A) / sqrt(length(A))
end

# ╔═╡ c29dde50-220c-11eb-1d8b-1be102884039
Tb0 = @benchmarkable sqrt( mean( $A .^ 2)) ; run( Tb0, seconds=1 )

# ╔═╡ 013b0850-220c-11eb-045f-1d8806443ffa
Tb1 = @benchmarkable sqrt(sum(x->x^2, $A)/ length($A)) ; run( Tb1, seconds=1 )

# ╔═╡ a5427500-220c-11eb-0f7a-db97f380ef6f
Tb2= @benchmarkable norm($A) / sqrt(length($A)) ; run( Tb2, seconds=1 )

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
	run( Tbf, seconds=2 )
end

# ╔═╡ f287c514-2715-11eb-27bf-2d6692f4aa43
rms(A)  ## just to get the definition compiled before the benchmark

# ╔═╡ 85708564-2829-11eb-13ef-559461b7c508
md"### Benchmarking vs native libs.
If the local file `native_rms.c` has been compiled with either **gcc** or **clang** then these code blocks will pickup the shared library, copy it to a temporary file through `templib()` and then load it.  This allows iterating on compile flags and builds and having each new version loaded.  (Otherwise julia would cache the first shared library and ignore changes.)

Currently the highest performant results are obtained with:

    clang -fPIC -xc -shared -O3 -Ofast -march=native -o native_rms_clang.so native_rms.c
"

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
	let a =run( Tbn, seconds=2 ), b= run( Tbnv, seconds=2 )
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
	let a =run( Tbng, seconds=2 ), b= run( Tbngv, seconds=2 )
		tempclean()
		a,b
	end
end

# ╔═╡ Cell order:
# ╠═c45132e0-2178-11eb-35d0-5d7d7fe035bf
# ╟─cff325d4-2828-11eb-092e-195721ca7000
# ╠═6e1e7800-220a-11eb-1a6c-27f61fef490d
# ╠═f287c514-2715-11eb-27bf-2d6692f4aa43
# ╠═c29dde50-220c-11eb-1d8b-1be102884039
# ╠═013b0850-220c-11eb-045f-1d8806443ffa
# ╠═a5427500-220c-11eb-0f7a-db97f380ef6f
# ╠═f14fc1a0-220c-11eb-098a-558458ecff16
# ╟─85708564-2829-11eb-13ef-559461b7c508
# ╠═8415c05a-254d-11eb-16bb-e38e55c989ef
# ╠═02bf27d0-2555-11eb-297b-c76a478eed30
# ╠═910bbf8a-2566-11eb-20fe-093a58757d39
