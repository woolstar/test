### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ 0c25d66a-2fb2-11eb-27a6-57707cfd4890
## Data Fitting with Julia
#
# https://www.youtube.com/watch?v=Zo3HhVVnsTM

begin
	using Plots
	using LinearAlgebra
	using Statistics
	using Polynomials
	using Interpolations
	using Dierckx
	using Optim
	using LsqFit
end

# ╔═╡ 448d46e6-2fce-11eb-2498-dfd3afc54a77
md"So we start with some data points ``(x,y)``"

# ╔═╡ cf9cc306-2fb2-11eb-318b-5b3f55267eab
begin
	x= vec( [0.0 0.5 1.1 1.7 2.1 2.5 2.9 3.3 3.7 4.2 4.9 5.3 6.0 6.7 7.0] )
	y= vec( [1.1 1.6 2.4 3.8 4.3 4.7 4.8 5.5 6.1 6.3 7.1 7.1 8.2 6.9 5.3] )
	
	scatter( x, y, lab="" )
end

# ╔═╡ 5caea0b2-2fce-11eb-09c1-8b7881664bae
md"And we use `Polynomials.fit()` to fit a 1st order curve"

# ╔═╡ 3d8f1a8a-2fb3-11eb-27c3-5b287ad72921
fit( x, y, 1 )

# ╔═╡ 5ecae21a-2fb3-11eb-0872-3d758caf42d4
begin
	x_hat= 0:0.05:7 
	
	p1= fit( x, y, 1 )
	p2= fit( x, y, 2 )
	
	scatter( x, y, lab="", legend=:bottomright )
	plot!( x_hat, [ p1( xᵢ ) for xᵢ in x_hat ], lab="p_1" )
	plot!( x_hat, [ p2( xᵢ ) for xᵢ in x_hat ], lab= "p_2" )
end

# ╔═╡ 3665d344-2fb7-11eb-220a-b58174306650
md"We can evaluate these two polynomials to see how close they fit the data, using the same fitness criteria that `fit()` uses, i.e. *RMS*.

There have been multiple suggestions for how to calculate *RMS* in Julia.  The fastest is to write it out, if you know the magic performance fairy dust.  Almost as good is to use list comprehension to transform each term of the difference into the difference squared, sum those up, divide and square root.  The most concice is to use **norm()** which is just ``(\sum x_i^2)^{1/2}`` which is pretty close to your final answer, but suprisingly this runs about 15% slower (as of Julia 1.4). "

# ╔═╡ 9c2b55c2-2fb6-11eb-2cbe-d9af7624c451
let
	ϵ₁= sqrt( sum(δ->δ^2, [p1( xᵢ ) for xᵢ in x] - y )/length(x))
	ϵ₂= norm( [p2( xᵢ ) for xᵢ in x] - y )/sqrt(length(x))
	
	ϵ₁, ϵ₂
end

# ╔═╡ 4875d1e4-2fb8-11eb-32b9-d19d8db9e6ca
md"As we explored before, we can turn **Polynomial.fit** loose and let it go completely mad, though curiously it goes mad in different ways than *matlab*."

# ╔═╡ 70e56498-2fb8-11eb-2cac-f9217dcf90a5
let
	pn= fit( x, y )
	scatter( x, y, lab="", legend=:topleft )
	plot!( x_hat, [ pn( xᵢ ) for xᵢ in x_hat ], lab="pn" )
end

# ╔═╡ 88f777f4-2fba-11eb-3226-b1fa750fb9ea
md"----
### Interpolations

An alternate strategy could be to connect the dots..."

# ╔═╡ 616287ba-2fba-11eb-02ae-7d2696d94f1d
let
	i_lin= LinearInterpolation( x, y )
	i_near= interpolate( (x, ), y, Gridded(Constant()) )
	i_spline= Spline1D(x, y )
	p1= scatter( x, y, lab="", legend=:topleft )
	plot!(p1, x_hat, [ i_lin( xᵢ ) for xᵢ in x_hat ], lab="linear" )
	plot!(p1, x_hat, [ i_near( xᵢ ) for xᵢ in x_hat ], lab="nearest" )
	p2= plot( x_hat, [ i_spline( xᵢ ) for xᵢ in x_hat ],legend=:topleft,lab="spline")
	plot( p1, p2 )
end

# ╔═╡ b178636c-2fc1-11eb-3448-f36f2d38f759
md"---
It becomes more complicated when finding the best fit for non-linear equations.\
Take a set of points ``D`` with an apparent symetry about zero."

# ╔═╡ cf481da6-2fc1-11eb-1d1f-a3b5b3b6e161
begin
	D= [(-3.0, -0.2),
        (-2.2, 0.1),
        (-1.7, 0.05),
        (-1.5, 0.2),
        (-1.3, 0.4),
        (-1.0, 1.0),
        (-0.7, 1.2),
        (-0.4, 1.4),
        (-0.25, 1.8),
        (-0.05, 2.2),
        (0.07, 2.1),
        (0.15, 1.6),
        (0.3, 1.5),
        (0.65, 1.1),
        (1.1, 0.8),
        (1.25, 0.3),
        (1.8, -0.1),
        (2.5, 0.2)]
	xrow( v )= [ p[1] for p in v ]
	yrow( v )= [ p[2] for p in v ]
	scatter( xrow( D), yrow( D), lab="")
end

# ╔═╡ d0984218-2fc5-11eb-1f5b-b37c8b23088e
md"Let us say we want to fit ``f(x)=ae^{-bx^2}`` for some unknown *a* and *b*.  Unfortunately the partial differential with respect to *b* is not a linear equation, so we can't use an analytic solution for this.  Instead we use an interative solution to look for a local minimum, given an initial starting point.  The most general tool is `Optim` which looks for a local minimum in an error function ``\varepsilon(a,b)``.
"

# ╔═╡ 5ca30cb6-2fc6-11eb-1d14-91d8f5ace9de
let
	function ϵ(β)
		f(x) = β[1] * exp( - β[2] * x^2 )
		err= reduce(+, map( x->x^2 , map( p-> p[2] - f(p[1] ), D ) ) )
	end
	function ϵ_max(β)
		f(x) = β[1] * exp( - β[2] * x^2 )
		err= maximum( map( abs, map( p-> p[2] - f(p[1] ), D ) ) )
	end
	 
	r= optimize( ϵ, [1., 1.] )
	β= r.minimizer
	r_max= optimize( ϵ_max, [2., 1.] )
	β2= r_max.minimizer
	
	f(x)= β[1] * exp( - β[2] * x^2 )
	f2(x)= β2[1] * exp( - β2[2] * x^2 )
	scatter( xrow( D), yrow( D), lab="")
	plot!( -3:.05:3, f, lab= "gauss fit" )
	plot!( -3:.05:3, f2, lab= "gauss min-max" )
	
end	

# ╔═╡ 3fb1987e-2fcc-11eb-3750-ad6c9a69e721
md"While `optimize()` will search for the minimum of any fitness function, if you're going to use least squares, you can take a shortcut, and call the `LsqFit` module with your model and data directly.  The only wrinkle, is that your model has to be in terms of ``\vec{x}`` and ``\beta`` which can take some mental gymnastics.
"

# ╔═╡ 989e6bcc-2fc9-11eb-3f4a-ad0872eb8a43
let
	f(x, β)= β[1] * [ exp( - β[2] * xᵢ^2 ) for xᵢ in x ]
	r= curve_fit( f, xrow( D), yrow( D), [1., 1.] )
	
	β= r.param
	f_it(x)= β[1] * exp( - β[2] * x^2 )
	scatter( xrow( D), yrow( D), lab="")
	plot!( -3:.05:3, f_it, lab= "lstsqr fit" )
end

# ╔═╡ Cell order:
# ╠═0c25d66a-2fb2-11eb-27a6-57707cfd4890
# ╟─448d46e6-2fce-11eb-2498-dfd3afc54a77
# ╟─cf9cc306-2fb2-11eb-318b-5b3f55267eab
# ╟─5caea0b2-2fce-11eb-09c1-8b7881664bae
# ╠═3d8f1a8a-2fb3-11eb-27c3-5b287ad72921
# ╠═5ecae21a-2fb3-11eb-0872-3d758caf42d4
# ╟─3665d344-2fb7-11eb-220a-b58174306650
# ╠═9c2b55c2-2fb6-11eb-2cbe-d9af7624c451
# ╟─4875d1e4-2fb8-11eb-32b9-d19d8db9e6ca
# ╠═70e56498-2fb8-11eb-2cac-f9217dcf90a5
# ╟─88f777f4-2fba-11eb-3226-b1fa750fb9ea
# ╠═616287ba-2fba-11eb-02ae-7d2696d94f1d
# ╟─b178636c-2fc1-11eb-3448-f36f2d38f759
# ╟─cf481da6-2fc1-11eb-1d1f-a3b5b3b6e161
# ╟─d0984218-2fc5-11eb-1f5b-b37c8b23088e
# ╠═5ca30cb6-2fc6-11eb-1d14-91d8f5ace9de
# ╟─3fb1987e-2fcc-11eb-3750-ad6c9a69e721
# ╠═989e6bcc-2fc9-11eb-3f4a-ad0872eb8a43
