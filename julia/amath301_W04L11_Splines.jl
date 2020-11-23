### A Pluto.jl notebook ###
# v0.12.11

using Markdown
using InteractiveUtils

# ╔═╡ 30013688-2cf6-11eb-1e39-f96e3bb52f11
## Polynomial fits and Splines
#
# https://www.youtube.com/watch?v=bFOTmSsDtAA

begin
	using LinearAlgebra
	using Plots
	using Random
	using Statistics
	using Polynomials
	using Interpolations
end

# ╔═╡ e6803788-2cf6-11eb-2867-a57b43d85b59
begin
	D= [(1,4),(3,12),(6,14),(9,38),(12,44),(18,43),(20,53),(24,69),(29,76),(37,103),(41,116),(43,103),(44,113),(49,133),(50,138),(52,136),(54,145),(55,136),(56,135),(57,144),(61,157),(66,176),(68,178),(70,177),(72,174),(75,195),(76,185),(77,194),(78,190),(86,216),(87,223),(91,222),(92,232),(96,240),(99,245)]
	x = [1. * e[1] for e in D]
	y = [1. * e[2] for e in D]

	md"As in the previous lecture, we have some data points ``D = (x_1, y_1), (x_2, y_2) ... (x_n,y_n)``"
end

# ╔═╡ 1144536e-2cf7-11eb-3867-ed9802e37b4e
scatter(D,lab="",title="some points")

# ╔═╡ 5afc28d8-2cf7-11eb-17f8-bf7d8d284253
md"Previously we solved for a line going through these points by minimizing the square of the error of
```math
\varepsilon_2(f)= \sum_{k=1}^n(A x_k + B -y_k)^2
```
by finding the zero of the derivatives with respect to ``A`` and ``B``
```math
\begin{align}
{\partial \varepsilon_2 \over \partial A}
    &= \sum 2x_k(Ax_k + B -y_k)
    &=& A \sum x_k^2 + B \sum x_k - \sum x_k y_k &= 0 \\
{\partial \varepsilon_2 \over \partial B}
    &= \sum 2(Ax_k + B -y_k)
    &=& A \sum x_k + nB - \sum y_k &= 0
\end{align}
```
This wonderfully is a set of two linear equations with two unknowns, which we can solve.  But this happens to work out for any polynomial ``f(x)``, not just a line.  If we were to try and fit a fourth order polynomial ``f(x)=Ax^4+Bx^3+Cx^2+Dx+E`` then we now have five unknowns, and if we take the derivative with respect to each coefficient, we have five equations.  Bigger matrix, and bigger sum products, but still basically the same.
"

# ╔═╡ 7f3e9d78-2cf9-11eb-12e6-d148dffe763a
let
	f8= fit( x, y, 8)
	scatter(D, lab="")
	plot!(f8, extrema(x)..., color=:green, lab="")
end

# ╔═╡ 971d7b4e-2cf9-11eb-0f15-f73a1e30d929
md"Unfortunately solving these matrixes is an ``O(n^3)`` problem, and that time is going to grow significant for larger numbers of ``n``'s.
[Lagrange](https://en.wikipedia.org/wiki/Joseph-Louis_Lagrange) re-arranged the expression of line going through two points ``(x_0,y_0)`` and ``(x_1,y_1)`` into the direct form:
```math
p_1(x)= y_0 { x -x_1\over x_0-x_1 }+ y_1 { x-x_0 \over x_1-x_0 }
```
Testing this we see when we evaluate ``p_1(x_1)``, the first term is zero and we just get ``y_1`` (since ``{x_1-x_0 \over x_1-x_0}=1``), and similarly at ``x_0`` we just get ``y_0``.  Rewriting this in terms of *Lagrange coefficients*, this becomes
```math
\begin{align}
L_{n,k}&=\prod_{i=0,i\ne k}^n {x - x_i \over x_k - x_i } \\
p_1(x)&=\sum_{k=0}^1 y_kL_{1,k}(x)
\end{align}
```
Generalizing for any order polynomial (where ``n<k``):
```math
p_n(x)=\sum_{k=0}^n y_kL_{n,k}(x)
```

So now that we have a closed form solution, and 36 data points (``k``), we could do a 10th or 12th or 20th order fit and get even closer.  Right?"

# ╔═╡ bf7dca08-2cf9-11eb-3551-d33cafef9309
let
	f10= fit( x, y, 10)
	f12= fit( x, y, 12)
	f20= fit( x, y, 20)
	scatter(D, lab="data", legend=:bottomright)
	plot!(-10:.1:101,x->f10(x), lab="10th")
	plot!(-1:.1:101,x->f12(x), lab="12th")
	plot!(-1:.1:100.1,x->f20(x), lab="20th")
end

# ╔═╡ 9c2f3d9a-2d29-11eb-0d69-e54ae2e3b609
md"now the data here is terrible, because its noisy and not evenly spaced; but even if it was better behaved, there's [Runge's Phenomenon](https://en.wikipedia.org/wiki/Runge%27s_phenomenon) which describes how the points at the extremes start carrying greater weight which leads to errors if the points are evenly distributed, or concentrated heavier in the middle.
(Yes, this is the same [Runge](https://en.wikipedia.org/wiki/Carl_Runge) from [Runge-Kutta](https://en.wikipedia.org/wiki/Runge%E2%80%93Kutta_methods).)"  

# ╔═╡ ec23d816-2d2d-11eb-0ba0-6366dcfe2028
md"---
### Splines
![Drafting splines](https://upload.wikimedia.org/wikipedia/commons/thumb/f/fd/Spline_%28PSF%29.png/225px-Spline_%28PSF%29.png)  

Splines were originally a piece of metal or wood, constrained in multiple points with the tension in the bar creating a smooth path passing through the points.  Eventually mathmeticians worked out how to work with polynomials (usually cubics), to allow the same kind of modelling on the computer.

Splines are now typically cubic functions ``S(t)= At^3+Bt^2+Ct+D`` evaluated from 0 to 1.  To get larger functions, ``S`` curves are stacked up and made to fit together.  A whole host of basis were invented to map from target points (or knots), tangents, and control points into the co-efficients of ``S``.  This led to bezier representation, b-spline, hermite, catmull-rom and others.  Thankfully any form can be converted into any other form through their basis co-efficients.  For the purposes of interpolation of data, we'll focus on the Catmull-Rom version of Hermite curves which go through the endpoints ``P_0`` and ``P_1`` and use two more points outside the range ``P_{-1}`` and ``P_2`` to inform the slopes.
"

# ╔═╡ 1ca69dec-2d4d-11eb-00aa-7d133330ea2d
begin
	CR_basis = (1/2) * [-1 3 -3 1 ; 2 -5 4 -1 ; -1 0 1 0 ; 0 2 0 0 ]
		
	let
	P = [ 1, 3, 5, 2 ]
	scatter( -1:2, P, lab="" )
	
	S = CR_basis * P
	
	Spline(t)= S[1]*t^3 + S[2]*t^2 + S[3]*t + S[4] ;
	plot!( 0:.025:1, Spline, lab="" )
end
end

# ╔═╡ ef0904e0-2d4e-11eb-2896-8dcef80ce876
md"If we have more points, we can take them four at a time and interpolate between each set"	

# ╔═╡ e4879da8-2d4e-11eb-35af-493d1e57d6fa
let
	P = [ 1, 3, 5, 2, 6, 5, 4, 4 ]
	Z= scatter( P, lab="" )
	range= 0:0.025:1
	for i in 1:size(P)[1]-3
		Pseg= P[i:i+3]
		S = CR_basis * Pseg
		Spline(t)= S[1]*t^3 + S[2]*t^2 + S[3]*t + S[4] ;
		y= [Spline(x) for x in range ]
		plot!( Z, i+1:.025:i+2, y, lab="" )
	end
	Z
end

# ╔═╡ 54d41b2e-2d55-11eb-3e47-c1b9bbc34488
md"Using the built in spline fit functions it solves for continuous derivatives and second derivatives for the slopes, and it also doubles up the points at the beginning and the end, so the interpolation goes through all the points."

# ╔═╡ 5e550f2c-2d51-11eb-21b9-476882644b3c
let
	P = [ 1, 3, 5, 2, 6, 5, 4, 4 ]
	scatter( P, lab="" )
	itp= CubicSplineInterpolation( 1:8, P )
	range= 1:.025:8 ;
	plot!( range, itp(range) )
end

# ╔═╡ Cell order:
# ╠═30013688-2cf6-11eb-1e39-f96e3bb52f11
# ╟─e6803788-2cf6-11eb-2867-a57b43d85b59
# ╠═1144536e-2cf7-11eb-3867-ed9802e37b4e
# ╟─5afc28d8-2cf7-11eb-17f8-bf7d8d284253
# ╠═7f3e9d78-2cf9-11eb-12e6-d148dffe763a
# ╟─971d7b4e-2cf9-11eb-0f15-f73a1e30d929
# ╠═bf7dca08-2cf9-11eb-3551-d33cafef9309
# ╟─9c2f3d9a-2d29-11eb-0d69-e54ae2e3b609
# ╟─ec23d816-2d2d-11eb-0ba0-6366dcfe2028
# ╠═1ca69dec-2d4d-11eb-00aa-7d133330ea2d
# ╟─ef0904e0-2d4e-11eb-2896-8dcef80ce876
# ╠═e4879da8-2d4e-11eb-35af-493d1e57d6fa
# ╟─54d41b2e-2d55-11eb-3e47-c1b9bbc34488
# ╠═5e550f2c-2d51-11eb-21b9-476882644b3c
