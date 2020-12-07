### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ ab0644de-3775-11eb-105a-61c6e3544a16
## Unconstrained Optimization (Derivative Methods)
#
# https://www.youtube.com/watch?v=RYKyhUglVZA

begin
	using Plots
	using Optim
	using LsqFit
end

# ╔═╡ d8852808-3775-11eb-1b4e-a3e498032286
md"**Objective**:
find the minimum of a multi-dimensional function ``f(\vec{x})`` by finding a solution to ``\nabla f=0``

---
"

# ╔═╡ 69127b98-3776-11eb-3b47-a5cb9b1d568f
begin
	f(x,y)=x^2+3*y^2
	surface(-3:.1:3, -3:.1:3, f, cam=[50,50] )
end

# ╔═╡ 93a7fb72-37f5-11eb-0007-a5666f190a9e
md"If we pick a starting point on the surface, then we can look at the slope (or gradient) at that point, and use it to head toward the minimum.  Unfortunately the gradient may not point directly toward the minimum, so we must follow the surface along that initial direction until we reach the low point of that slice, then re-sample the gradient again, and head off in a new direction.

So we take our ``f`` and calculate its gradient
```math
\begin{align}
f(x,y) &= x^2+3y^2\\
\nabla f &= \frac{\partial F}{\partial x}+ \frac{\partial F}{\partial y} \\
&= 2x \hat x + 6y \hat y
\end{align}
```
With the gradient worked out, we can create a function ``\xi(\tau)`` which starts at point ``x`` and moves opposite the gradient.  Then we can evaluate that function for ``f`` and find its minimum point by taking the derivative with respect to ``\tau`` and solving for ``\tau`` at the zero point.
```math
\begin{align}
\xi(\vec x, \tau) &= \vec x - \tau \nabla f(\vec x) \\
  &= (1-2\tau)x\hat x + (1-6\tau)y\hat y \\
f(\xi(\vec x, \tau)) &= (1-2\tau)^2x^2 + 3(1-6\tau)^2y^2 \\
\frac{\partial f(\xi(\vec x, \tau))}{\partial \tau}
  &= -4(1-2\tau)x^2 + -36(1-6\tau)y^2 \\
  & -4(1-2\tau)x^2 + -36(1-6\tau)y^2 = 0\\
  & (1-2\tau)x^2 + 9(1-6\tau)y^2 = 0\\
  & x^2 + 9y^2 = (2x^2+54y^2)\tau \\
\tau &= \frac{x^2+9y^2}{2x^2+54y^2}
\end{align}
```
"

# ╔═╡ 069cd72e-37fb-11eb-06a6-5f125a674788
begin
	f(x::Vector{<:Number})= f(x[1],x[2])
	τ(x::Vector{<:Number})= (x[1]^2+9x[2]^2)/(2x[1]^2+54x[2]^2)
	ξ(x::Vector{<:Number},τ)= [(1-2τ)*x[1], (1-6τ)*x[2]]
	ξ(x::Vector{<:Number})= ξ(x, τ(x))
end

# ╔═╡ 95973a4a-37fc-11eb-1493-df9e490246aa
begin
	vtrace= []
	sizehint!(vtrace, 20)  ## create some space in advance
	
	function gradient_decent( f, ξ, x₀, ϵ= 1e-10 )
		resize!(vtrace,0)  ## clear vtrace
		push!(vtrace,x₀)
		x= x₀
		f_past= f( x )
		Δ = 1
		while ( Δ > ϵ )
			x= ξ( x )
			push!(vtrace, x )
			f_new= f( x )
			Δ= abs(f_new - f_past) ;  f_past = f_new
		end
		return x
	end

	gradient_decent( f, ξ, [3,2] )
	contour( -3:.1:3, -3:.1:3, f )
	plot!( map(x->x[1], vtrace), map(x->x[2], vtrace), lc=:red, w=3, lab="trace" )
end

# ╔═╡ 7df63a6e-382c-11eb-3ea9-498004c707e6
md"### General fit

Lets say we have some data points that look roughly sinusoidal.  And we want to fit a ``sin`` or ``cos`` to it.  We could guess at the offset, amplitude, period and phase; but that's probably not going to match perfectly.
"

# ╔═╡ d4331e02-3830-11eb-0c54-47764c31da83
begin
	temps= [75, 77, 76, 73, 69, 68, 63, 59, 57, 55, 54, 52,
		    50, 50, 49, 49, 49, 50, 54, 56, 59, 63, 67, 72,]
	xs= collect(1:1:length(temps))
	
	plot( temps, lab= "temps")
	let
		A= 10 ;  B= (2*π)/24 ;  C= π/6 ;  D= 60 ;
		fc(x)= A * cos( B * x - C) + D ;
		fs(x)= A * sin( B * x + C) + D ;
		plot!( xs, fc, lab="cos")
		plot!( xs, fs, lab="sin")
	end
end

# ╔═╡ f8153546-382e-11eb-10e8-f711a1c3398f
md"As we saw in [lecture 12](./amath301_W04L12_DataFit.jl), we can setup a fitness function explicitly, but we want a least squares solution, we can just use the canned point fitter directly:"

# ╔═╡ 1e24d9f8-382f-11eb-3a89-c7a0383c246a
let
	f(xvec, β)= [ β[1] * sin(β[2] * x + β[3]) + β[4] for x in xvec ]
	r= curve_fit( f, xs, temps, [ 10, (2*π)/24, π/6, 60 ] )
	
	plot( temps, lab= "temps")
	plot!( xs, f(xs,r.param), lab= "fit")
end

# ╔═╡ Cell order:
# ╠═ab0644de-3775-11eb-105a-61c6e3544a16
# ╟─d8852808-3775-11eb-1b4e-a3e498032286
# ╠═69127b98-3776-11eb-3b47-a5cb9b1d568f
# ╟─93a7fb72-37f5-11eb-0007-a5666f190a9e
# ╠═069cd72e-37fb-11eb-06a6-5f125a674788
# ╠═95973a4a-37fc-11eb-1493-df9e490246aa
# ╟─7df63a6e-382c-11eb-3ea9-498004c707e6
# ╠═d4331e02-3830-11eb-0c54-47764c31da83
# ╟─f8153546-382e-11eb-10e8-f711a1c3398f
# ╠═1e24d9f8-382f-11eb-3a89-c7a0383c246a
