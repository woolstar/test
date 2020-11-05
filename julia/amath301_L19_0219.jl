### A Pluto.jl notebook ###
# v0.12.6

using Markdown
using InteractiveUtils

# ╔═╡ 808eada0-1e60-11eb-1c3a-b9ad04f85133
## Initial Conditions
begin
using Plots
using LinearAlgebra
using ODE

	ω=2*π   # natural frequency
	ζ=0.13   # dampening

	A= [0 -ω^2;
		1  -2*ζ*ω]
	
	x₀= [2. 0.]
	T= 10
	Δt=0.025

end

# ╔═╡ 508b3ee0-1e72-11eb-3d7c-cd6771480b5c
## ODEs and Time Stepping
#
# https://www.youtube.com/watch?v=vg5nGfSnyrI

# ╔═╡ 068f89a0-1e71-11eb-173b-7d078ac0b1a8
## forward euler iteration
begin
	Vᵤ= [ x₀; ]
	let ϵ = I + Δt * A
		for k in 1:Int64(T/Δt)
			global Vᵤ= vcat(Vᵤ, Vᵤ[k:k, :] * ϵ )
		end
	end
end

# ╔═╡ bd187510-1e6c-11eb-2373-59240a5df83e
plot( [0:Δt:T], Vᵤ, layout=2, label=["position" "velocity"], lc=[:green :red] )

# ╔═╡ 9a642e10-1e6c-11eb-1b70-578e4ab3556d
plot( Vᵤ[:,2], Vᵤ[:,1], label="", xguide="velocity", yguide="position" )

# ╔═╡ 82de3330-1e71-11eb-24e1-815bd37d089e
## reverse euler iteration (slightly more stable)
begin
	Vᵥ= [ x₀; ]
	let ϵ = inv(I - Δt * A)
		for k in 1:Int64(T/Δt)
			global Vᵥ= vcat(Vᵥ, Vᵥ[k:k, :] * ϵ )
		end
	end
end

# ╔═╡ a500c180-1e71-11eb-37b0-2bc7da8b93df
plot( [0:Δt:T], Vᵥ, layout=2, label=["position" "velocity"], lc=[:green :red] )

# ╔═╡ 1f9c63e2-1e72-11eb-1afe-519b3f4d5bcd
plot( Vᵥ[:,2], Vᵥ[:,1], label="", xguide="velocity", yguide="position" )

# ╔═╡ 5bd40c10-1f20-11eb-31bd-0b4e72e4ff4b
## using built in solvers, we have to present A as a function

begin
	function f(t,s)
		(x,v)=s
		dx= v
		dv= -2 * ζ * ω * v - ω * ω * x
		[ dx ; dv ]
	end
end

# ╔═╡ 7913cdc0-1e75-11eb-170a-898d1e27ffa0
begin
	Tᵣ, w = ode45( f, [2. ; 0.], 0:Δt:T )
	Vᵣ = hvcat( 2, (w...)... )
	plot( Tᵣ, Vᵣ, layout=2, label=["position" "velocity"], lc=[:green :red] )
end

# ╔═╡ 0976fbae-1e7d-11eb-2d12-692a6ad233cb
begin
	plot( Tᵣ, Vᵣ[:,2], Vᵣ[:,1], label= "runge kutta", camera=(22.5,45) )
	plot!( [0:Δt:T], Vᵥ[:,2], Vᵥ[:,1], label= "forward euler" )
	plot!( [0:Δt:T], Vᵤ[:,2], Vᵤ[:,1], label= "back euler" )
end

# ╔═╡ Cell order:
# ╠═508b3ee0-1e72-11eb-3d7c-cd6771480b5c
# ╠═808eada0-1e60-11eb-1c3a-b9ad04f85133
# ╠═0976fbae-1e7d-11eb-2d12-692a6ad233cb
# ╠═068f89a0-1e71-11eb-173b-7d078ac0b1a8
# ╠═bd187510-1e6c-11eb-2373-59240a5df83e
# ╠═9a642e10-1e6c-11eb-1b70-578e4ab3556d
# ╠═82de3330-1e71-11eb-24e1-815bd37d089e
# ╠═a500c180-1e71-11eb-37b0-2bc7da8b93df
# ╠═1f9c63e2-1e72-11eb-1afe-519b3f4d5bcd
# ╠═5bd40c10-1f20-11eb-31bd-0b4e72e4ff4b
# ╠═7913cdc0-1e75-11eb-170a-898d1e27ffa0
