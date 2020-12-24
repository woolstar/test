### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 5da32822-44dd-11eb-0cc8-9527c16cb416
## Higher order accuracy for differentiation
#
# https://www.youtube.com/watch?v=1ExoTzoz7FQ

begin
	using Plots
	using Polynomials
	using ForwardDiff
	
	# temporary scaling bug introduced in plots() 1.9 with Gr
	# so using plotly in the short term.
	plotly()
end

# ╔═╡ a58af3d8-44dd-11eb-36c4-f9f4001f94e6
md"Looking still at pointwise differentiation, lets gather some data from ``sin(\theta)``, but lets mix it up just a bit."

# ╔═╡ d0d32ffe-44dd-11eb-3b66-e7d2fbcbe0ab
begin
	Δx= 0.075
	x= -π:Δx:2π
	
	f(x)= sin(x)+1/5*sin(5x+π/6)
	Data = f.(x)
	
	
	plot( x, Data, lab="funky" )
end

# ╔═╡ 54c58256-44e0-11eb-28d0-f11c6e996f59
md"Now, as was discussed in the lecture before, when we take the taylor expansion about ``x`` of ``f(x+\Delta x)``, we get

```math
f(x+\Delta x)= f(x) + \Delta x\frac{df}{dx}(x)
	+\frac{\Delta x^2}{2!}\frac{d^2f}{dx^2}(x)
	+\frac{\Delta x^3}{3!}\frac{d^3f}{dx^3}(x)
	+\mathcal{O}(\Delta x^4)+\cdots
```

When we do a simple forward or back differentiation,
```math
\begin{align}
\frac{f(x+\Delta x)-f(x)}{\Delta x} &= \frac{df}{dx}(x)
	+ \frac{\Delta x}{2!}\frac{d^2f}{dx^2}
	+ \frac{\Delta x^2}{3!}\frac{d^3f}{dx^3}
	+ \mathcal{O}(\Delta x^3)+ \cdots \\
\frac{f(x)-f(x-\Delta x)}{\Delta x} &= \frac{df}{dx}(x)
	- \frac{\Delta x}{2!}\frac{d^2f}{dx^x}
	+ \frac{\Delta x^2}{3!}\frac{d^3f}{dx^3}
	+ \mathcal{O}(\Delta x^3)+ \cdots
\end{align}
```
we get our derivative, plus some error terms, with the largest begin proportional to ``\Delta x``, and as we saw in our previous workbook, the forward and back differentiations had a fairly large error when ``\Delta x`` was somewhat coarse.

The interesting thing is that because ``f(x)-f(x-\Delta x)`` had terms which alternated positive and negative, if we combine the two, some of the terms cancel out.  This gave us the much more accurate central differentiation, and we're also going to use that to get higher order derivatives.

So if we want the second derivative, we can take the difference of two first derivatives, but we can mix one forward and one back, and fun things happen

```math
\frac{f(x+\Delta x) -2f(x) + f(x-\Delta x)}{\Delta x^2}=
	\frac{d^2f}{dx^2}(x)
	+ \frac{2\Delta x^2}{4!}\frac{d^4f}{dx^4}(x)
	+ \mathcal{O}(\Delta x^4)+ \cdots
```
"

# ╔═╡ ba7ab5d0-44ea-11eb-343a-2bc24f02ee24
md"Unfortunately, we can't always use central differentiation if we're working with finite data, and so we often have to do less precise calculations on the boundary."

# ╔═╡ f3024a26-44ea-11eb-2072-8b455290d4df
let
	function Diff_i(arr, i)
		if ( i == 1 )
			return (arr[i+1]-arr[i])
		end
		if ( i == length(arr) )
			return (arr[i]-arr[i-1])
		end
		return (arr[i+1]-arr[i-1])/2
	end
	
	df= x -> ForwardDiff.derivative( f, x )  ## symbolic df/dx on f(x)
	DxData= [Diff_i(Data, i)/Δx for i in 1:length(Data)]
	
	plot( x, hcat( Data, df.(x), DxData ), lab=["f" "df" "data diff"] )
end

# ╔═╡ Cell order:
# ╠═5da32822-44dd-11eb-0cc8-9527c16cb416
# ╟─a58af3d8-44dd-11eb-36c4-f9f4001f94e6
# ╠═d0d32ffe-44dd-11eb-3b66-e7d2fbcbe0ab
# ╟─54c58256-44e0-11eb-28d0-f11c6e996f59
# ╟─ba7ab5d0-44ea-11eb-343a-2bc24f02ee24
# ╠═f3024a26-44ea-11eb-2072-8b455290d4df
