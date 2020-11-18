### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# ╔═╡ 51848716-28ef-11eb-28bf-6d63e800cc8f
## Stability of Iteration Methods 
#
# https://www.youtube.com/watch?v=TroK68kOn24

begin
	using LinearAlgebra
	using Plots
	using Random
end

# ╔═╡ ed2372cc-28ef-11eb-2a3e-33136864c5f8
md"## Stability

So we previously attempted to solve a set of equations by factoring them into the diagonal (``D``) and the off-diagonal parts (``T``):

```math
\begin{align}
A\vec{x} &= \vec{b} \\
D\vec{x} + T\vec{x} &= \vec{b} \\
D\vec{x} &= -T\vec{x} + \vec{b} \\
\vec{x} &= -D^{-1}T\vec{x} + D^{-1}\vec{b}
\end{align}
```

The Jacobi iteration strategy takes this final form and splits it into round ``k`` and round ``k+1``

```math
\vec{x}_{k+1}=-D^{-1}T\vec{x}_k + D^{-1}b
```

Analysing this for the delta between rounds
( ``\epsilon_{k+1}=\vec{x}_{k+1} - \vec{x}_k `` ), we get

```math
ϵ_{k+1}= -D^{-1}T\epsilon_k
```

So clearly, when ``D^{-1}T`` amplifies, our error is going to grow and the solution is not going to converge, but when it dampens, our error is going to tend to zero, and we're going to reach a solution.

The eigenvalues point the way.  When ``|\lambda_i|<0`` the iterations will converge.
"

# ╔═╡ 0258119a-291b-11eb-2f20-ade8d1ad3d7c
begin
	A_stable = [ 4 -1 1;
	    	  4 -8 1;
	    	 -2 1 5]
	## same equations, different order
	A_unstable = [ -2 1 5; 
		    	  4 -8 1;
		    	  4 -1 1 ]
end

# ╔═╡ 350b4936-28f3-11eb-330e-edb3f69e230f
let D= Diagonal(diag(A_stable)), T= A_stable - D
	U = -inv(D) * T
	abs.(eigen( U ).values)
end

# ╔═╡ a56f98d0-28f3-11eb-2ddc-ef3bc45965aa
let D= Diagonal(diag(A_unstable)), T= A_unstable - D
	U = -inv(D) * T
	abs.(eigen( U ).values)
end

# ╔═╡ df58360e-28f5-11eb-3972-b99948ae576a
md"## Gauss-Seidel

Enhanse the iteration process, by using newer data in our substitution

`` y_{k+1} = ({\bf 4x_{k+1}} + z_k +21) / 8 ``\
vs\
`` y_{k+1} = (4x_k + z_k +21) / 8 ``

That's great if you're doing it line by line, but what does that look like in matrix form?  So instead of the ``k+1`` terms being only on the diagonal, now its on the lower triangular half of the matrix.  So we split ``A`` into the lower triangular ``S``, and the remaining ``T``.  The rest of the derivation looks pretty similar, leaving us with:

```math
\begin{align}
\vec{x}_{k+1} &= -S^{-1}T\vec{x}_k + S^{-1}\vec{b} \\
\vec{\epsilon}_{k+1} &= -S^{-1}T\vec{\epsilon}_k
\end{align}
```
"

# ╔═╡ 274d399a-290e-11eb-1813-574195485d21
begin
	function step_gaussseidel( A, b, x₀, n )
		S = tril( A )
		T = A-S  ## you could use triu(A) - D, but it benchmarked slower
		Z = -inv(S) * T ;  zb = inv(S) * b ;
		x = zeros( Float64, (3,n) )
		x[:,1]= x₀
		for i in 1:n-1 x[:,i+1]= Z* x[:,i] + zb ; end
		x		
	end
	
	function step_jacobi( A, b, x₀, n )
		D = Diagonal(diag(A))
		T = A - D
		Z = -inv(D) * T ;  zb = inv(D) * b ;
		x = zeros( Float64, (3,n) )
		x[:,1]= x₀
		for i in 1:n-1 x[:,i+1]= Z* x[:,i] + zb; end
		x
	end
	
	A = [ 4 -1 1;
    	  4 -8 1;
    	 -2 1 5]
	b = [ 7; -21; 15]
end

# ╔═╡ 9ce878b8-2915-11eb-187f-3f91e93120f0
plot( plot(step_jacobi( A, b, [1;2;2], 6 )'),
	  plot(step_gaussseidel( A, b, [1;2;2], 6)') )

# ╔═╡ 534eea24-2916-11eb-08ac-3331091b5f26
plot(( step_gaussseidel(A, b, [1;3;2], 8) - step_jacobi(A, b, [1;3;2], 8) )' )

# ╔═╡ 83a7a576-291b-11eb-1cf3-bfc3d8f2b2bb
md"Gauss-Seidel eigenvalues tend to be smaller on which lends to faster convergence, but its not a fix-all."

# ╔═╡ 38966c2a-291b-11eb-362b-9dffe67bc65d
let S= tril(A_stable), T= A_stable - S
	U = -inv(S) * T
	abs.(eigen( U ).values)
end

# ╔═╡ 3ac09b10-291b-11eb-167b-fb671b116395
let S= tril(A_unstable), T= A_unstable - S
	U = -inv(S) * T
	abs.(eigen( U ).values)
end

# ╔═╡ a9ea34c4-291b-11eb-17ef-557001a6ff47
md"Inverting a diagonal matrix is much faster than a full matrix.  Inverting a lower diagonal should be easier as well, but the speed doesn't seem to indicate that this form has been optimized."

# ╔═╡ 4f3acca0-2918-11eb-1a0c-9fde2f82dfe0
begin
	A_big = rand( 1000, 1000 )
	t_full= @elapsed inv(A_big)
	
	D_big= Diagonal(diag(A_big))
	t_diag= @elapsed inv(D_big)  ## really fast
	
	S_big= tril( A_big )
	t_lower= @elapsed inv( S_big )  ## about half that of t_full
	
	t_full, t_diag, t_lower
end

# ╔═╡ Cell order:
# ╠═51848716-28ef-11eb-28bf-6d63e800cc8f
# ╟─ed2372cc-28ef-11eb-2a3e-33136864c5f8
# ╠═0258119a-291b-11eb-2f20-ade8d1ad3d7c
# ╠═350b4936-28f3-11eb-330e-edb3f69e230f
# ╠═a56f98d0-28f3-11eb-2ddc-ef3bc45965aa
# ╟─df58360e-28f5-11eb-3972-b99948ae576a
# ╠═274d399a-290e-11eb-1813-574195485d21
# ╠═9ce878b8-2915-11eb-187f-3f91e93120f0
# ╠═534eea24-2916-11eb-08ac-3331091b5f26
# ╟─83a7a576-291b-11eb-1cf3-bfc3d8f2b2bb
# ╠═38966c2a-291b-11eb-362b-9dffe67bc65d
# ╠═3ac09b10-291b-11eb-167b-fb671b116395
# ╟─a9ea34c4-291b-11eb-17ef-557001a6ff47
# ╠═4f3acca0-2918-11eb-1a0c-9fde2f82dfe0
