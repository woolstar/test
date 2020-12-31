### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 69f676a6-4b18-11eb-289a-953859b50011
## Phase plots
#
# https://www.youtube.com/watch?v=7ye8PBQGVpg

begin
	using WGLMakie
	using AbstractPlotting
	using AbstractPlotting.MakieLayout
	
	AbstractPlotting.inline!(true)
end

# ╔═╡ 83a8febc-4b91-11eb-1981-1128f4b53ecb
md"While there are not good interative data exploration receipes yet for Julia, there are better and better visualization developed.  The `Makie` meta-package is an alternative ecosystem to `Plots`, with different trade-offs and tools.  There is more of a learning curve, but more power in some cases.

Here we see the pendulum ODE plotted as a vector field with some dampening."

# ╔═╡ b9867ad2-4b8f-11eb-0404-65a79cd4256b
let
	pendulum_ode(x,y)= Point( y, sin(x) - 0.25y )
	scene= Scene( resolution=(640,480))
	streamplot!(scene, pendulum_ode, -2π..2π, -3π/2..3π/2,
		colormap = :plasma,
		gridsize= (40,40), arrow_size= 0.18 )
end

# ╔═╡ e8141bb4-4b91-11eb-3cff-75816ea3da8e
md"And this is reminiscent of our attempt to visualize the Van der Paul field by constructing 100 random starting positions."

# ╔═╡ b83002ce-4b90-11eb-1c70-978f72c17830
let
	vanderpaul_ode(x,y)= Point(y, (1-x^2)*y -x)
	scene= Scene( resolution=(512,512))
	streamplot!(scene, vanderpaul_ode, -5..5, -5..5,
		colormap = :rainbow1, 
    	gridsize= (50,50), arrow_size = 0.1, title= "Stable" )

end

# ╔═╡ Cell order:
# ╠═69f676a6-4b18-11eb-289a-953859b50011
# ╟─83a8febc-4b91-11eb-1981-1128f4b53ecb
# ╠═b9867ad2-4b8f-11eb-0404-65a79cd4256b
# ╟─e8141bb4-4b91-11eb-3cff-75816ea3da8e
# ╠═b83002ce-4b90-11eb-1c70-978f72c17830
