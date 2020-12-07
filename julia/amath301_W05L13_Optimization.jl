### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ 3b7311e6-36bf-11eb-00b3-696efd093bf3
## Constrained Optimization (Derivative Free)
#
# https://www.youtube.com/watch?v=9l2u3cntayE

begin
	using Plots
	using Optim
end

# ╔═╡ 5f0fda24-36bf-11eb-2abf-3f2eb9b5fe09
md"**Objective**: Finding the minimum within a range of a function ``f(x)`` without accessing/calculating derivatives or gradients.  We're implement one strategy for converging on the minimum, and also explore the optimizers available within the *Optim* package in Julia."

# ╔═╡ d32ddb86-36bf-11eb-1fd3-abb5b9099ab1
md"---
So it all starts with data or a function we're looking for the bottom of.  Say for example

```math
f_{ugly}(x)= x^4 +10x sin(x^2)
```
which looks something like"

# ╔═╡ 37366b20-36c0-11eb-39a6-f384d20bd9b7
begin
	f(x)=x^4+10x*sin(x^2)
	x_lower= -1.75
	x_upper= 1
	plot( x_lower:0.05:x_upper, f, lab="ugly function" )
end

# ╔═╡ 4970e01e-3750-11eb-1a15-697c74dade6a
md"The first strategy is to section the range ``[x_{lower},x_{upper}]`` and work our way down to the bottom.  We pick two new points ``x_l,x_r`` such that ``x_{lower}<x_l<x_r<x_{upper}``, and then evaluate the function at ``f(x_l)`` and ``f(x_r)``.  Then we perform the following update
```math
\begin{align}
f(x_l) > f(x_h) &: x_{lower} \leftarrow x_l \\
f(x_l) \leq f(x_h) &: x_{upper} \leftarrow x_h
\end{align}
```
and repeat until the interval is small enough.  Done arbitrarily, we have to evaluate ``f`` twice at each step.  However the mathmetician [Kiefer](https://en.wikipedia.org/wiki/Jack_Kiefer_(statistician)) proposed picking the spacing between the bounds and samples, so that the points could be reused.  IE, if the various spacing between our points:
```math
\begin{align}
l &= x_{upper} - x_{lower} \\
a &= (x_l - x_{lower} ) / l &=& (x_{upper} - x_h)/l \\
c &= (x_h - x_l) / l &=& 1 - 2a
\end{align}
```
After one round of sectioning, the span would be reduced proportionally to ``1-a``.  If you wished to reuse a point, you'd want the original gap in the middle ``c`` (or ``1-2a``) to be equal to the new ``a`` which would be ``a(1-a)`` from the original.  Setting those equal and solving for ``a`` we get
```math
\begin{align}
1-2a &= a-a^2 \\
a^2 - 3a +1 &= 0 \\
a &= \frac{-(-3)\pm\sqrt{(-3)^2-4\cdot 1\cdot 1}}{2\cdot 1}={ 3 -\sqrt5 \over 2 }
\end{align}
```
Of course there's another solution to ``a`` but we're looking for ``0<a<1``, so we stick with this one. \
The ``\sqrt5`` should put you on alert that there's a magic number near by, and in fact if we start playing with the different ratios, we eventually find:
```math
{1-a \over a}
= { 1 - {3 -\sqrt5 \over 2} \over {3 -\sqrt5 \over 2} }
= {\sqrt5 - 1\over 3 - \sqrt5}\times { 3 + \sqrt5\over 3 + \sqrt5}
= {1 + \sqrt5 \over 2}
= \varphi
```
giving this proportion its name: the *golden section search*
"

# ╔═╡ bdaaa590-376a-11eb-3373-cf5ced156e58
begin
	function golden_section(f, x_lower::Number, x_upper::Number, iter=1_000, ϵ=1e-15)
		a= (3 - sqrt(5))/2 ;  b = 1 - a
		xₗ= b * x_lower + a * x_upper ;  fₗ= f(xₗ)
		xₕ= b * x_upper + a * x_lower ;  fₕ= f(xₕ)
		while (iter > 0)
			iter -= 1
			if ( (x_upper - x_lower) < ϵ ) break ;  end
			if ( fₗ > fₕ )
				x_lower= xₗ
				xₗ= xₕ                 	  ;	fₗ= fₕ
				xₕ= b*x_upper + a*x_lower ;	fₕ= f(xₕ)
			else
				x_upper= xₕ
				xₕ= xₗ 					  ;	fₕ= fₗ
				xₗ= b*x_lower + a*x_upper ;	fₗ= f(xₗ)
			end
		end
		return (x_lower + x_upper)/2
	end
end

# ╔═╡ 49743e4e-376e-11eb-3750-2b4accdc1336
golden_section( f, x_lower, x_upper, 0 )  ## no steps

# ╔═╡ 6cc2e828-376e-11eb-32ea-857eebd40923
golden_section( f, -2, 1, 5 )  ## five sectionings

# ╔═╡ 54e7713e-3772-11eb-2010-c310ed4807ad
golden_section( f, x_lower, x_upper, 100, 1e-6 )  ## pretty close

# ╔═╡ 80034cf2-376e-11eb-2ae1-cdfd93325e7c
x_min= golden_section( f, -2, 1 )

# ╔═╡ 06583c22-376f-11eb-19be-9dc8c388f6b4
let
	plot( -1.4:.01:-1.1, f, lab="f" )
	scatter!( [x_min], [f(x_min)], lab="x_min" )	
end

# ╔═╡ b396f14e-376f-11eb-2573-eb8a2aa3a060
md"It should come as no surprise that the Julia module *Optim* has the golden sectioning algorithm as an available option."

# ╔═╡ ade7a018-376f-11eb-2c1d-d3326f6ae011
optimize(f, x_lower, x_upper, GoldenSection())

# ╔═╡ 9c9d075a-3772-11eb-1976-4d59a23092f3
md"Another bounded solver, gets to the solution even faster."

# ╔═╡ 8f0f3b3a-3772-11eb-24a7-b52486fabf50
optimize(f, x_lower, x_upper, Brent())

# ╔═╡ Cell order:
# ╠═3b7311e6-36bf-11eb-00b3-696efd093bf3
# ╟─5f0fda24-36bf-11eb-2abf-3f2eb9b5fe09
# ╟─d32ddb86-36bf-11eb-1fd3-abb5b9099ab1
# ╠═37366b20-36c0-11eb-39a6-f384d20bd9b7
# ╟─4970e01e-3750-11eb-1a15-697c74dade6a
# ╠═bdaaa590-376a-11eb-3373-cf5ced156e58
# ╠═49743e4e-376e-11eb-3750-2b4accdc1336
# ╠═6cc2e828-376e-11eb-32ea-857eebd40923
# ╠═54e7713e-3772-11eb-2010-c310ed4807ad
# ╠═80034cf2-376e-11eb-2ae1-cdfd93325e7c
# ╠═06583c22-376f-11eb-19be-9dc8c388f6b4
# ╟─b396f14e-376f-11eb-2573-eb8a2aa3a060
# ╠═ade7a018-376f-11eb-2c1d-d3326f6ae011
# ╟─9c9d075a-3772-11eb-1976-4d59a23092f3
# ╠═8f0f3b3a-3772-11eb-24a7-b52486fabf50
