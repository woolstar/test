### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 35be27de-4e11-11eb-08d5-63b4b1b27195
## The speed of Julia, loops and animations
#
# https://www.youtube.com/watch?v=f0dRidnR2dw

begin
	using Plots
	using Random
	using ParameterizedFunctions
	using WGLMakie
end

# ╔═╡ da0070a8-4e17-11eb-24c1-af90d06a4659
md"This notebook is where we go way off into the weeds.  Mostly because the lecture was about the shortcomings of *Matlab*, and we're not subject to those problems.  But also we programming in a notebook, so we don't have quite the immediacy in some cases as running directly in the application would have.  But lets see what we can setup, and learn."

# ╔═╡ 2e9f746a-4e18-11eb-216f-8195ed53f0e9
begin
	Lorenz= @ode_def begin
		dx= σ * (y-x)
		dy= x * (ρ-z) -y
		dz= x*y - β*z
	end σ ρ β	
end

# ╔═╡ 7c73d596-4e18-11eb-1c78-477b71fbcf92
begin
	function rk4step!( uout, f, Δt, u, p, t )
		dh= Δt/2
		
		f₁= f(u,p,t)
		f₂= f(u +dh*f₁,p,t+dh)
		f₃= f(u +dh*f₂,p,t+dh)
		f₄= f(u +Δt *f₃, p, t+Δt )
		
		uout[:]= @. u + (Δt/6)*(f₁ + 2f₂ + 2f₃ + f₄)
	end
end

# ╔═╡ f302ef34-4e4b-11eb-118e-8d91cb725b20
md"Setting up our simulation with a field of data in the traditional fashion, we see that the calculation of thousands of points is relatively quickly, but here we're only plotting the final state.  Not very satisfying for observing the behavior."

# ╔═╡ ba982a44-4e21-11eb-347c-03344a4dd182
let
	r= 20; λ= 2
	U= hcat( reshape( collect(
				[1. *x,y,z] for x ∈ -r:λ:r, y ∈ -r:λ:r, z ∈ -r:λ:r
		), (:) )... )
	
	gr()
	for n ∈ 1:400
		for i ∈ 1:size(U,2)
			rk4step!( @view( U[:,i]), Lorenz.f, 0.01, U[:,i], (10, 28, 8/3), 0 )
		end
	end
	Plots.scatter( U[1,:], U[2,:], U[3,:], lab= "" )
end

# ╔═╡ 10086680-4e57-11eb-27a2-81d6a0e32593
md"With the normal `Plots` package, we can improve on this a little bit with the **Animate** module, allowing us to run a series of plots and capture them frame by frame into a infinite looping gif, or in this case an mpeg move which we can play.  But you'll notice I've cut the number of particles down by almost two orders of magnitude just to make this bearable."

# ╔═╡ 8df0e22e-4e2b-11eb-1e5b-f500ac0a2019
let
	r= 20; λ= 8
	U= hcat( reshape( collect(
				[1. *x,y,z] for x ∈ -r:λ:r, y ∈ -r:λ:r, z ∈ -r:λ:r
		), (:) )... )
	
	anim= @animate for n ∈ 1:400
		for i ∈ 1:size(U,2)
			rk4step!( @view( U[:,i]), Lorenz.f, 0.01, U[:,i], (10, 28, 8/3), 0 )
		end
		Plots.scatter( U[1,:], U[2,:], U[3,:],
			xlims=(-40, 40), ylims=(-40,40), zlims=(0,50), lab="" )
	end
	
	mp4( anim, fps=20 )
end

# ╔═╡ 13b7bba2-4e58-11eb-10bc-fb7e0944b938
md"To do any better than this, we'll have to switch gears, switch plotting platforms, and mix in some advanced concepts.

The first part is to switch from `Plots` to `Makie`, a higher end visualization environment.  This involves some boilerplate to setup a **Scene**, but we are also going to use the concept of a *Node* which is an updatable data record.  In the normal julia REPL, you could create a plot at one line, then run your simulation further on, and modify the *Nodes* and the plot would update.  But this is *Pluto* and only the last expresion in a cell is visible.  So we have to start thinking out-of-order.

After creating the *Nodes*, we create a function which will update our state ``U`` and post it to the *Nodes*, then we schedule the function to run asynchronously.  And finally we create the plot.  Now it might seem a little difficult to work out what order things actually happen, but luckily Julia's concurrency model is rather simple.  There's only one thread, and there's a queue of things waiting for a chance to run on it.  So we add `update()` to the list, but it doesn't run.  Then we finish creating the chart and exit the cell.  Only then does `update()` start running, and if we didn't add one more piece of magic, we'd still be sorely disappointed.  The `yield()` call suspends `update()` so **Makie** can redraw the chart, and then the scheduler resumes further processing.
"

# ╔═╡ 715fd0da-4e2f-11eb-0920-b39a85c01c02
let
	Makie= WGLMakie
	
	# r= 20; λ= 2; u₀= [0.,0,0]  -- pick this one for a course starting grid.
	r= 1; λ= 0.08; u₀= [-8.,8,27]
	rnd3d(δ)=δ * rand(3) .- (δ/2)  # add a little noise for flavor
	
	U= hcat( reshape( collect(
				u₀ .+[x,y,z] +rnd3d(λ/2) for x ∈ -r:λ:r, y ∈ -r:λ:r, z ∈ -r:λ:r
		), (:) )... )
	
	lim= FRect3D((-40,-40,0),(80,80,50))  ## plot bounds
	scene= Scene(limits= lim) ;
	pts= Point3.(U[:,i] for i ∈ 1:size(U,2))
	nu_ = Node(pts)  ## create updatable records
	
	function update( k, n, U )
		for step ∈ 1:k
			for i ∈ 1:size(U,2)
				rk4step!( @view( U[:,i]), Lorenz.f, 0.01, U[:,i], (10, 28, 8/3), 0 )
			end
			pts= Point3.(U[:,i] for i ∈ 1:size(U,2))
			n[]= pts
			yield()
		end
	end
	@async update( 1200, nu_, U )  ## schedule updates to happen later
	
	Makie.meshscatter!(scene, nu_, markersize= 0.2, color=:red )
end

# ╔═╡ Cell order:
# ╠═35be27de-4e11-11eb-08d5-63b4b1b27195
# ╟─da0070a8-4e17-11eb-24c1-af90d06a4659
# ╠═2e9f746a-4e18-11eb-216f-8195ed53f0e9
# ╠═7c73d596-4e18-11eb-1c78-477b71fbcf92
# ╟─f302ef34-4e4b-11eb-118e-8d91cb725b20
# ╠═ba982a44-4e21-11eb-347c-03344a4dd182
# ╟─10086680-4e57-11eb-27a2-81d6a0e32593
# ╠═8df0e22e-4e2b-11eb-1e5b-f500ac0a2019
# ╟─13b7bba2-4e58-11eb-10bc-fb7e0944b938
# ╠═715fd0da-4e2f-11eb-0920-b39a85c01c02
