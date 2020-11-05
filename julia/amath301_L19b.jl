### A Pluto.jl notebook ###
# v0.12.6

using Markdown
using InteractiveUtils

# ╔═╡ c7a12260-1f21-11eb-079e-492a38dd15d7
## Initial Conditions
begin
using Plots
using LinearAlgebra
using ODE

	ω=2*π   # natural frequency
	ζ=0.13   # dampening

	A= [ 0    1 ;
		-ω^2 -2*ζ*ω]
	
	x₀= [2. ; 0.]
	T= 10
	Δt=0.01

end

# ╔═╡ 14845ca0-1f22-11eb-1242-170319c16750
x₀

# ╔═╡ fcbc1ae0-1f21-11eb-254f-0d16b73ba42d
A*x₀

# ╔═╡ 29cafc90-1f22-11eb-16ed-bd9d2ee1227e
ϵ= I + Δt * A

# ╔═╡ 41423820-1f22-11eb-2a4e-2bb0e663d957
ϵ * ( ϵ * x₀ )  ## two steps forward

# ╔═╡ 0c785060-1f23-11eb-3047-8124bf81acb0
begin
	vu= [ x₀ ]
	let x= x₀
		for i in 1:Int64(T/Δt)
			x= ϵ * x
			push!( vu, x )
		end
	end
	vu
end

# ╔═╡ eb165d80-1f23-11eb-27b5-bf3d06e6259d
plot( [ 0:Δt:T ], [e[1] for e in vu ], [ e[2] for e in vu ], label="" )

# ╔═╡ Cell order:
# ╠═c7a12260-1f21-11eb-079e-492a38dd15d7
# ╠═14845ca0-1f22-11eb-1242-170319c16750
# ╠═fcbc1ae0-1f21-11eb-254f-0d16b73ba42d
# ╠═29cafc90-1f22-11eb-16ed-bd9d2ee1227e
# ╠═41423820-1f22-11eb-2a4e-2bb0e663d957
# ╠═0c785060-1f23-11eb-3047-8124bf81acb0
# ╠═eb165d80-1f23-11eb-27b5-bf3d06e6259d
