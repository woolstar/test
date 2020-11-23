### A Pluto.jl notebook ###
# v0.12.11

using Markdown
using InteractiveUtils

# ╔═╡ 2b3d5460-2896-11eb-00d3-0d595c4a44e9
## Iteration Methods and stability
#
# https://www.youtube.com/watch?v=IQOUoTQd7Y8
# https://www.youtube.com/watch?v=TroK68kOn24

begin
	using LinearAlgebra
	using Plots
	using Random
end

# ╔═╡ 6a57d0b0-2898-11eb-15f1-4dddef3c0290
md"If we have the equations

```math
\begin{align}
4x − y + z &= 7 \\
4x − 8y + z &= −21 \\
−2x + y + 5z &= 15
\end{align}
```
we could solve them in the usual way,"

# ╔═╡ 4078d636-2898-11eb-151d-577fc792356f
begin
	A = [ 4 -1 1;
    	  4 -8 1;
    	 -2 1 5]
	b = [ 7; -21; 15]

	A\b
end

# ╔═╡ 9a9acb26-2896-11eb-20e3-2543d91229af
md"But there may be barriers to doing it that way, such as size or other properties of the matrix.

We can rewrite them in terms of each other, and pick a starting point, and use them as ways to update the values in each round of iteration,
```math
\begin{align}
x_{k+1} &= {y_k-z_k+7\over 4} \\
x_{k+1} &= {4x_k + z_k +21 \over 8} \\
x_{k+1} &= {2x_k − y_k +15\over 5}
\end{align}
```

With a good guess for starting conditions, and some luck, this might converge.
"

# ╔═╡ 1fafa498-2898-11eb-3392-e1cc051f3e13
begin
	bⱼ = [7/4; 21/8; 15/5]
	Mⱼ = [0 1/4 -1/4;
  		  4/8 0 1/8;
 		  2/5 -1/5 0]
	k = 12
	
	x = zeros( Float64, (3, k) )
	x[:,1]= [ 0; 0; 0]  # initial guess
	for i in 1:k-1
		x[:,i+1]= Mⱼ*x[:,i] +bⱼ
	end
	
	ϵ= norm(x[:,k] - x[:,k-1])
	x[:,k], ϵ
end

# ╔═╡ 9e994bf2-289c-11eb-3ce0-f986715c3ede
plot( x', lab=["x" "y" "z"] )

# ╔═╡ edf80ade-289d-11eb-3e08-915ed1a4c097
md"But we can mess things up very easily.  For example if you swap the first and last original equations, and try to solve again, you get:

```math
\begin{align}
x_{k+1} &= {y_k+5z_k-15\over 2} \\
y_{k+1} &= {4x_k + z_k +21 \over 8} \\
z_{k+1} &= y_k − 4x_k +7
\end{align}
```"

# ╔═╡ 68ac40e4-289e-11eb-32dd-835e922dc7b4
begin
	bᵤ = [-15/2; 21/8; 7]
	Mᵤ = [0 1/2 5/2;
    	  4/8 0 1/8;
          -4 1 0]

	xu = zeros( Float64, (3, k) )
	xu[:,1]= [ 2; 2; 3]  # initial guess
	for i in 1:k-1
		xu[:,i+1]= Mᵤ*xu[:,i] +bᵤ
	end
	
	ϵᵤ= norm(xu[:,k] - xu[:,k-1])
	xu[:,k], ϵᵤ
end

# ╔═╡ 0683ea72-289f-11eb-0006-3bdb0038f798
plot( xu', lab=["x" "y" "z"] )

# ╔═╡ 62c26f20-289f-11eb-37b5-5f6520356f22
md"And for different initial conditions, it can head in entirely different directions:"

# ╔═╡ 7b59961c-289f-11eb-1552-3b964b75241d
begin
	function jacobi( A, b, x₀, n )
		x= zeros( Float64, (3,n) )
		x[:,1]= x₀
		for i in 1:n-1 x[:,i+1]= A* x[:,i] +b end
		x
	end
	
	jn= 25
	starts= 10 .* rand( 3, jn ) ;
	plot( vcat([ jacobi( Mᵤ, bᵤ, starts[:,j], 8 ) for j in 1:jn ]...)', lab="")
end

# ╔═╡ b8460b54-28eb-11eb-1619-cdffe8ba2c7c
md"So our luck did not hold here.  In the future we'll work out what this luck is that we need to have for this to work."

# ╔═╡ Cell order:
# ╠═2b3d5460-2896-11eb-00d3-0d595c4a44e9
# ╟─6a57d0b0-2898-11eb-15f1-4dddef3c0290
# ╠═4078d636-2898-11eb-151d-577fc792356f
# ╟─9a9acb26-2896-11eb-20e3-2543d91229af
# ╠═1fafa498-2898-11eb-3392-e1cc051f3e13
# ╠═9e994bf2-289c-11eb-3ce0-f986715c3ede
# ╟─edf80ade-289d-11eb-3e08-915ed1a4c097
# ╠═68ac40e4-289e-11eb-32dd-835e922dc7b4
# ╠═0683ea72-289f-11eb-0006-3bdb0038f798
# ╟─62c26f20-289f-11eb-37b5-5f6520356f22
# ╠═7b59961c-289f-11eb-1552-3b964b75241d
# ╟─b8460b54-28eb-11eb-1619-cdffe8ba2c7c
