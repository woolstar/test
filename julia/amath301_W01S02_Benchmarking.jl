### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# ╔═╡ ec32c9c6-27be-11eb-3ee7-4f1338414589
using Random ;  using LinearAlgebra ;  using Polynomials ;  using Plots

# ╔═╡ 4a17b1a2-27bd-11eb-166b-af3c1975fcca
## benchmarking
#
# https://www.youtube.com/watch?v=coE5KO6_blk

# ╔═╡ 83eb63ce-27bd-11eb-1e05-d1f1d7f5f025
begin
	testsizes = [ 80 100 200 300 400 600 800 1000 1200 1600 1800 ]
end

# ╔═╡ ea2b7d8a-27c3-11eb-3bac-bb348b3feda8
## prime functions
let m1 = rand(20,20), m2 = rand(20,20)
	m1*m2
	lu(m2)
	inv(m1)
	""
end

# ╔═╡ 990f5706-27bd-11eb-187f-8d0d626b05a4
begin
	multₜ= []
	
	for sz in testsizes
		let m1 = rand(sz,sz), m2 = rand(sz,sz)
			ΔT= @elapsed prod= m1 * m2
			push!( multₜ, ΔT )
		end
	end
end

# ╔═╡ 7f04ca56-27bf-11eb-3a2f-77eff03b3310
begin
	invₜ= []
	
	for sz in testsizes
		let m= rand(sz,sz)
			ΔT= @elapsed inv( m )
			push!( invₜ, ΔT )
		end
	end
end

# ╔═╡ 319066d6-27c4-11eb-1f27-77d58c9b47fd
begin
	luₜ= []
	
	for sz in testsizes
		let m= rand(sz,sz)
			ΔT= @elapsed lu( m )
			push!( luₜ, ΔT )
		end
	end
end

# ╔═╡ 3aa4fcec-27be-11eb-0a9f-2921248fc0a5
plot( testsizes', [ multₜ invₜ luₜ ],
	xaxis=:log, yaxis=:log,
	lab=["mult" "inv" "lu"], legend = :bottomright )

# ╔═╡ 00d4df90-27c9-11eb-2a98-4b0607b10609
vec(log.(testsizes))

# ╔═╡ ba37c6a8-27c6-11eb-0f9e-f54063cd01bb
begin
	logsize= vec(log.(testsizes))
	
	function linlogfit( log_r, T )
		lt = log.(T)
		poly= fit( log_r, lt, 1 )
		collect(poly)[2]
	end
	
	linlogfit( logsize, multₜ ),
	linlogfit( logsize, invₜ ),
	linlogfit( logsize, luₜ )
	
end

# ╔═╡ Cell order:
# ╠═4a17b1a2-27bd-11eb-166b-af3c1975fcca
# ╠═ec32c9c6-27be-11eb-3ee7-4f1338414589
# ╠═83eb63ce-27bd-11eb-1e05-d1f1d7f5f025
# ╠═ea2b7d8a-27c3-11eb-3bac-bb348b3feda8
# ╠═990f5706-27bd-11eb-187f-8d0d626b05a4
# ╠═7f04ca56-27bf-11eb-3a2f-77eff03b3310
# ╠═319066d6-27c4-11eb-1f27-77d58c9b47fd
# ╠═3aa4fcec-27be-11eb-0a9f-2921248fc0a5
# ╠═00d4df90-27c9-11eb-2a98-4b0607b10609
# ╠═ba37c6a8-27c6-11eb-0f9e-f54063cd01bb
