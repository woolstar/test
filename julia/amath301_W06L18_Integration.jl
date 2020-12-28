### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 2133d30a-45b4-11eb-0620-659c0e02415c
## Numerical Integration
#
# https://www.youtube.com/watch?v=SsoLgZv_lOg

begin
	using Plots
	using Trapz
	using NumericalIntegration
	using QuadGK
	
	# temporary scaling bug introduced in plots() 1.9 with Gr
	# so using plotly in the short term.
	plotly()
end

# ╔═╡ 4c8a35da-45b4-11eb-0acb-2fcc72c27771
md"So as before, we want to work with numerical data which we're going to derive from a real function, but I'm going to go even more funky than I did last time, and go with something that's more positive than negative.  Lets say,

```math
f(x)=\sin(x)+\frac{1}5 \sin^2(5x+\pi / 6)
```

which looks as ugly as you'd expect.
"

# ╔═╡ b467bda6-45b4-11eb-380b-05b6922a893f
begin
	f(x)= sin(x)+1/5*sin(5x+π/6)^2
	
	plot( -π:.025:2π, f, lab="warp")
end

# ╔═╡ 87973dac-45b5-11eb-363a-f15d39f3aa7c
md"But for purposes of demonstrating the error, let's set a very course step, and look at one cycle."

# ╔═╡ a702c3f2-45b5-11eb-2c99-7168987814c6
begin
	Δx = 0.25
	x = 0:Δx:2π
	
	Data= f.(x)
	plot( x, Data, linetype=:steppre )
end

# ╔═╡ 1282786e-45b6-11eb-0eba-6105ecac19fd
let
	n= length(Data)
	## left and right rectangle rule (simple sum post-scaled, and generator form)
	sum(Data[1:n-1])*Δx , sum(x*Δx for x in Data[2:n])
end

# ╔═╡ 1cf08dc6-45b7-11eb-1178-cb6de6602b1c
md"At a course setting, the left and right results are far apart, but if we turn ``\Delta t`` down several of orders of magnetude, we get the same result as evaluating the true integral which is
```math
\int_{0}^{2\pi}f(x)\, dx
   =\frac{x+\pi/30}{10}-\cos(x)-\frac{1}{100}\sin(10x+\pi/3)\bigg\rvert_0^{2\pi}
```

Across the range ``[0,2\pi]`` the trig functions cancel out, leaving just ``x/10``, or
"

# ╔═╡ 2b62ff8c-45b8-11eb-1450-1b60d3c88d69
π/5

# ╔═╡ ccb96554-45ba-11eb-3073-679539aa20ad
md"Similar to *matlab*, Julia has a trapizoidal integration module, called `trapz()`
and it has a module `NumericalIntegration` with a *Trapezoidal* mode."

# ╔═╡ a08a716c-45ba-11eb-2fda-65351353ac1c
trapz( x, Data )

# ╔═╡ 61b047f0-45bf-11eb-1266-03056b1aaf6c
NumericalIntegration.integrate( x, Data, TrapezoidalEven() )

# ╔═╡ a5c58f1c-45bb-11eb-39bc-ef30040fae69
md"This is pretty close, but we can try to get closer.

Simpson's rule says that, for an integral across three points ``x_0,x_1,x_2``, we can approximate the integral:

```math
\int_{x_0}^{x_2}f(x)\,dx = \frac{\Delta x}3(f(x_0)+4f(x_1)+f(x_2))
	+ \mathcal{O}(\Delta x^5) + \cdots 
```

Which is essentially doing a spline interpolation across the points.
"

# ╔═╡ 8ddf4ccc-45bf-11eb-1740-25fb50442be8
begin
	function simpson(dx::Number, v)
		n= length(v)
		vs= (9v[1] + 28v[2] + 23v[3] + 23v[n-2] + 28v[n-1] + 9v[n]) / 24 ;
		vs += sum( v[4:n-3] )
		return dx * vs
	end
	simpson( vx::AbstractArray, vy )= simpson( vx[2]-vx[1], vy )
end

# ╔═╡ 28fd0e68-45c7-11eb-264c-8d6edfd89e34
md"For polynomials of order ``x^4`` and below, this would actually produce the exact answer.  But for our data this ends up coming out worse, due to its insensitivity to narrow peaks."

# ╔═╡ 78528736-45c7-11eb-3dc7-17d4b5e6d689
simpson( x, Data )

# ╔═╡ a46b1db8-45bf-11eb-0cb3-859df2073368
md"The `NumericalIntegration` has a *Simpson* mode as well, but its alternate 3/8 kernal does even worse here."

# ╔═╡ 1a430de0-45be-11eb-0c68-137218b56217
NumericalIntegration.integrate( x, Data, SimpsonEven() )

# ╔═╡ 83e445dc-45c0-11eb-321b-4f6440b44d0c
md"We can do adaptive integration on the original function, similar to *matlab* `quad` and get pretty much the same result as our hand calculation."

# ╔═╡ 4626c1d2-45c0-11eb-0d1d-bdaf9c66b5ee
let
	(val, ϵ)= quadgk(f, 0, 2π )
	val
end

# ╔═╡ Cell order:
# ╠═2133d30a-45b4-11eb-0620-659c0e02415c
# ╟─4c8a35da-45b4-11eb-0acb-2fcc72c27771
# ╠═b467bda6-45b4-11eb-380b-05b6922a893f
# ╟─87973dac-45b5-11eb-363a-f15d39f3aa7c
# ╠═a702c3f2-45b5-11eb-2c99-7168987814c6
# ╠═1282786e-45b6-11eb-0eba-6105ecac19fd
# ╟─1cf08dc6-45b7-11eb-1178-cb6de6602b1c
# ╠═2b62ff8c-45b8-11eb-1450-1b60d3c88d69
# ╟─ccb96554-45ba-11eb-3073-679539aa20ad
# ╠═a08a716c-45ba-11eb-2fda-65351353ac1c
# ╠═61b047f0-45bf-11eb-1266-03056b1aaf6c
# ╟─a5c58f1c-45bb-11eb-39bc-ef30040fae69
# ╠═8ddf4ccc-45bf-11eb-1740-25fb50442be8
# ╟─28fd0e68-45c7-11eb-264c-8d6edfd89e34
# ╠═78528736-45c7-11eb-3dc7-17d4b5e6d689
# ╟─a46b1db8-45bf-11eb-0cb3-859df2073368
# ╠═1a430de0-45be-11eb-0c68-137218b56217
# ╟─83e445dc-45c0-11eb-321b-4f6440b44d0c
# ╠═4626c1d2-45c0-11eb-0d1d-bdaf9c66b5ee
