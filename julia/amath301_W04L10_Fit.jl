### A Pluto.jl notebook ###
# v0.12.11

using Markdown
using InteractiveUtils

# ╔═╡ 0c764554-2c8c-11eb-318a-b36577faf21b
## Least squares curve fit
#
# https://www.youtube.com/watch?v=3hz6Tb1i2FY

begin
	using LinearAlgebra
	using Plots
	using Random
	using Statistics
	using Polynomials
end

# ╔═╡ d7ce872c-2c8c-11eb-22cd-a783e9f8dfe8
begin
	D= [(1,4),(3,2),(6,14),(9,38),(12,44),(18,43),(20,53),(24,69),(29,76),(37,103),(41,116),(43,103),(44,113),(49,133),(50,138),(52,136),(54,145),(55,136),(56,135),(57,144),(61,157),(66,176),(68,178),(70,177),(72,174),(75,195),(76,185),(77,194),(78,190),(86,216),(87,223),(91,222),(92,232),(96,240),(99,245)]
	x = [1. * e[1] for e in D]
	y = [1. * e[2] for e in D]

	md"Lets collect some data points ``D = (x_1, y_1), (x_2, y_2) ... (x_n,y_n)``"
end

# ╔═╡ d6df6cf0-2c8c-11eb-1be1-610a185c41e3
scatter(D,lab="",title="some points")		

# ╔═╡ e8d57faa-2c94-11eb-2b7f-336f3f15cc6d
md"There is obviously no line that goes through all the points, because the points don't line up.  This problem is *overconstrained*.  Instead of solving this problem exactly, we have to decide how to pick the solution that is closest.  How to gauge the fitness of a solution vs the error it has with relation to each point.

We might try to minimize the biggest error:
```math
E_\infty(f)= \max_{1<k<n} |f(x_k)-y_k|
```
or just take the average error (``L_1``)
```math
E_1(f)= {1\over n}\sum_{k=1}^n|f(x_k)-y_k|
```
A common strategy is to minimize the square of the error (``L_2``), which comes from the original root mean square formula (also the formula for standard deviation)
```math
E_2(f)=\sqrt{{1\over n}\sum_{k=1}^n|f(x_k)-y_k|^2}
```
Though if you are trying to minimize ``E_2`` you can simplify by looking for the minimum of
```math
\varepsilon_2(f)= \min \sum_{k=1}^n(f(x_k)-y_k)^2
```
"

# ╔═╡ 91f90b62-2c9d-11eb-045b-cfc2e5f06f22
let
	f= fit( x, y, 1 )
	scatter(D, lab="")
	plot!(f, extrema(x)..., color=:green, lab="")
end

# ╔═╡ 69db00c4-2caa-11eb-3b2b-fdd68cb22e84
md"We can try to follow the points closer by using higher order polynomials, but at some point it goes somewhat wonky trying to follow the data."

# ╔═╡ 7c1470d6-2caa-11eb-325b-c33dba832854
let
	f8= fit( x, y, 8)
	f9= fit( x, y, 9)
	scatter(D, lab="")
	plot!(f8, extrema(x)..., color=:green, lab="")
	plot!(f9, extrema(x)..., color=:orange, lab="")
end

# ╔═╡ Cell order:
# ╠═0c764554-2c8c-11eb-318a-b36577faf21b
# ╟─d7ce872c-2c8c-11eb-22cd-a783e9f8dfe8
# ╠═d6df6cf0-2c8c-11eb-1be1-610a185c41e3
# ╟─e8d57faa-2c94-11eb-2b7f-336f3f15cc6d
# ╠═91f90b62-2c9d-11eb-045b-cfc2e5f06f22
# ╟─69db00c4-2caa-11eb-3b2b-fdd68cb22e84
# ╠═7c1470d6-2caa-11eb-325b-c33dba832854
