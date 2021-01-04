### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 5fa56646-4c88-11eb-3c00-251edc847dde
begin
	using ParameterizedFunctions
	using Random
end

# ╔═╡ 9bd3bc48-4c89-11eb-3fd4-ef1ff5913688
vdp= @ode_def begin
		dx= y
		dy= μ*(1-x^2)*y -x
	end μ

# ╔═╡ 1ac1628a-4c8a-11eb-2ba5-799cbe0cf05d
vdp.f

# ╔═╡ c81bf46e-4c89-11eb-2c50-7d713d1d7ae3
vdp.f([-1.5,6], (7), 0.)

# ╔═╡ 0a127320-4c8a-11eb-1db4-cd4396bdb7b8
let
	u= zeros(2)
	vdp.f(u, [-1.5,6], (7), 0.)
	u
end

# ╔═╡ 0e57d3ac-4c8b-11eb-0206-c96e066f4a02
let
	U= [-1.5 0; 0 6] * ones(2, 10_000_000) + rand(2, 10_000_000)
	
	u= zeros(2)
	for i in 1:size(U,2)
		vdp.f(@view( U[:,i]), U[:,i], (7), 0.)
	end
	U[:,1]
end

# ╔═╡ 20fa5648-4c94-11eb-10a2-2359b0828d70
let
	U= ones(10_000_000, 2) *  [-1.5 0; 0 6] + rand(10_000_000, 2)
	
	u= zeros(2)
	for i in 1:size(U,1)
		vdp.f(@view( U[i,:]), U[i,:], (7), 0.)
	end
	U[1,:]
end

# ╔═╡ dea6cb78-4c8e-11eb-2500-31065936f221
let
	b= 2
	step= 0.1
	
	U= hcat( reshape(
		collect( [x,y,z] for x = -b:step:b, y= -b:step:b, z= -b:step:b),
		(:) )... )'
	U[1,:]
end

# ╔═╡ Cell order:
# ╠═5fa56646-4c88-11eb-3c00-251edc847dde
# ╠═9bd3bc48-4c89-11eb-3fd4-ef1ff5913688
# ╠═1ac1628a-4c8a-11eb-2ba5-799cbe0cf05d
# ╠═c81bf46e-4c89-11eb-2c50-7d713d1d7ae3
# ╠═0a127320-4c8a-11eb-1db4-cd4396bdb7b8
# ╠═0e57d3ac-4c8b-11eb-0206-c96e066f4a02
# ╠═20fa5648-4c94-11eb-10a2-2359b0828d70
# ╠═dea6cb78-4c8e-11eb-2500-31065936f221
