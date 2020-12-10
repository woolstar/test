### A Pluto.jl notebook ###
# v0.12.16

using Markdown
using InteractiveUtils

# ╔═╡ b2efb380-398a-11eb-05ed-a90ac5f0677b
## Optimization (Linear Prog and Genetics)
#
# https://www.youtube.com/watch?v=wiQOsH8C-uQ

begin
	using Plots
	using JuMP
	using MathOptInterface
	using Clp
	using Random
end

# ╔═╡ e0d423ae-3a88-11eb-127c-e198427d9be9
begin
	using Base.Iterators
	function simple_mutate( starts, dim, n, scale )
		[ x .+ scale * (rand(dim) .- 0.5) for x=repeat(starts,n) ]
	end
end

# ╔═╡ 03c20cbc-398c-11eb-1b76-e5d4d9e483c9
md"
----

### Linear programming

is about finding the optimum solution within the bounds of linear constraints.

You are looking for ``\vec x`` such that ``c^\intercal x`` is minimized (or possibly maximized) where ``c`` is a set of weights.  In addition, you usually have a set of inequalities (``A\vec x\le b``) and some possible equalities as well (``\hat A\vec x=\hat b``), and some bounds on ``x``.

For example, you might want to maximize ``2x_1+x_2`` with the following constraints

```math
\begin{align}
x_1+{8 \over 3}x_2 &\le 4 \\
x_1 + x_2 &\le 2 \\
2 x_1 &\le 3 \\
x_1 &\ge 0 \\
x_2 &\ge 0
\end{align}
```
"

# ╔═╡ a999c1ec-39bf-11eb-1220-fd294482649e
let
	C= [2, 1]
	A= [ 1 8/3;
		 1  1;
		 2  0;
	    -1  0;  # negate ≥
	     0 -1 ]
	b= [4; 2; 3; 0; 0]

	m = Model( Clp.Optimizer )
	@variable( m, x[1:2] )
	@objective( m, Max, C'x )
	@constraint( m, cnx, A * x .≤ b )
	optimize!(m)
	
	if ( termination_status(m) == MOI.OPTIMAL )  ## OPTIMAL::TerminationStatusCode
		value.(x)
	end
end

# ╔═╡ c8d7273e-39bf-11eb-16e1-d9b9b3f25f9f
md"Alternately, we can describe the bounds on ``x`` in the variable declaration."

# ╔═╡ b7c50146-3990-11eb-2c02-1f63ce10baa7
let
	C= [2, 1]
	A= [ 1 8/3;
		 1  1;
		 2  0 ]
	b= [4; 2; 3]

	x = zeros(2)
	m = Model( Clp.Optimizer )
	@variable( m, x[1:2] ≥ 0 )
	@objective( m, Max, C'x )
	@constraint( m, cnx, A * x .≤ b )
	optimize!(m)
	value.(x), result_count(m), objective_value(m)
end

# ╔═╡ 86c4cb82-3a85-11eb-1c58-0d699c387d26
md"
----

### Genetic algorithms

In genetic algorithms, you start with multiple guesses, and you evaluate your function at each of those points, then you keep the best guesses, and generate new guesses near the good ones.  While this is not guarenteed to work, it is suprising how close the power of random sampling can get, and sometimes other methods may not be effective.

So if we revisit the fit of ``Ae^{-Bx^2}`` from [before](./amath301_W04L12_DataFit.jl)
"

# ╔═╡ 4b6fb712-3a86-11eb-1821-273f7b01aace
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
	scatter( xrow( D), yrow( D), lab="", size=(320,200))
end

# ╔═╡ 5c617a44-3aac-11eb-2111-919d3e28edb1
md"we will construct a similar fitness function ``\epsilon``, pass in an initial guess, and parameters for how many generations of what size to run passing all this to our function *simple_genetics*."

# ╔═╡ 2fe421a0-3aa6-11eb-24f1-771595ac5ab1
md"We can run a bunch of trials with much smaller populations, and even the best and worst often are very close to each other."

# ╔═╡ 6931f6ea-3aa7-11eb-0537-d9e8710e652e
md"Our *simple_genetics* takes the initial guess and creates a starting set by randomizing *keep* times.
	
Then we run a loop *generations* times, mutating the starting population into a set *explore_ratio* times as big, randomizing by ``\pm 1/gen``, we then evaluate all the candidates through our fitness criteria, and partially sort the results for the *keep* best which we pick out to form our new *starts*.
	
Finally we return the most fit candidate from the last round."

# ╔═╡ 5123ee48-3a87-11eb-02f5-2122258409b5
begin
	struct Genetics
		explore_ratio::Int
		keep::Int
		generations::Int
	end
	
	function simple_genetics( f, x_start, param )
		dim= size( x_start, 1 )
		starts= map( _ -> x_start .+ rand( dim ) .- 0.5, 1:param.keep )
		for gen in 1:param.generations
			candidates = simple_mutate( starts, dim, param.explore_ratio, 2. /gen )
			fit = f.(candidates)
			best_i= partialsortperm( fit, 1:param.keep )
			starts= candidates[best_i]
		end
		starts[1]
	end
end

# ╔═╡ e0d85980-3a86-11eb-2557-d357e2111fbc
begin
	A = 2 ;  B = 4 ;
	f( β, x )= β[1] * exp( -β[2] * x^ 2 ) ;
	ϵ( β ) = reduce(+, map( x->x^2 , map( p-> p[2] - f(β, p[1] ), D ) ) )

	result= simple_genetics( ϵ, [A, B], Genetics( 100, 5, 100 ) ) ;
	result, ϵ( result )
end

# ╔═╡ cc9cf1a4-3aa1-11eb-02ea-a97253523cee
begin
	scatter( xrow( D), yrow( D), lab="" )
	
	trials= 50
	β_v= [ simple_genetics( ϵ, [A, B], Genetics( 40, 2, 25 ) ) for _ in 1:trials ]
	ϵ_v= map( ϵ, β_v )
	idx= sortperm( ϵ_v )
	β_best= β_v[idx[1]]
	β_worst= β_v[idx[trials]]
	
	plot!( -2:.1:2, x-> f(β_best, x), lab="best" )
	plot!( -2:.1:2, x-> f(β_worst, x), lab="worst" )
end

# ╔═╡ 7d387fe2-3aa7-11eb-12dc-9be1d2b240f8
md"Our *simple_mutate* function explores the space around *starts* by duplicating it ``n`` times and adding ``\pm scale\times rand()`` to each point"

# ╔═╡ Cell order:
# ╠═b2efb380-398a-11eb-05ed-a90ac5f0677b
# ╟─03c20cbc-398c-11eb-1b76-e5d4d9e483c9
# ╠═a999c1ec-39bf-11eb-1220-fd294482649e
# ╟─c8d7273e-39bf-11eb-16e1-d9b9b3f25f9f
# ╠═b7c50146-3990-11eb-2c02-1f63ce10baa7
# ╟─86c4cb82-3a85-11eb-1c58-0d699c387d26
# ╟─4b6fb712-3a86-11eb-1821-273f7b01aace
# ╟─5c617a44-3aac-11eb-2111-919d3e28edb1
# ╠═e0d85980-3a86-11eb-2557-d357e2111fbc
# ╟─2fe421a0-3aa6-11eb-24f1-771595ac5ab1
# ╠═cc9cf1a4-3aa1-11eb-02ea-a97253523cee
# ╟─6931f6ea-3aa7-11eb-0537-d9e8710e652e
# ╠═5123ee48-3a87-11eb-02f5-2122258409b5
# ╟─7d387fe2-3aa7-11eb-12dc-9be1d2b240f8
# ╠═e0d423ae-3a88-11eb-127c-e198427d9be9
