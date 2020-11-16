### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# ╔═╡ 2915fa48-27ce-11eb-11f3-89c9b07bf899
using Plots

# ╔═╡ e8d2928c-27ca-11eb-0d1e-5fdb5441de8c
## Vector elements
#
# https://www.youtube.com/watch?v=_RPjphz8o9Q
# https://www.youtube.com/watch?v=Lf8nF5yPUgk

# ╔═╡ 09716680-27cb-11eb-1685-5d2f4aa45d49
begin
	A = [1 2; 3 4]
	B = [6 7; 8 9]
	A , B
end

# ╔═╡ 29469688-27cb-11eb-2e38-3f4b8c15f3ea
# regular matrix mult
A * B

# ╔═╡ 39694206-27cb-11eb-128f-ab6b90a150af
# element mult
A .* B

# ╔═╡ 72ca6fa0-27cb-11eb-1ffd-1b37e1fc8b24
x = [1 2 4]

# ╔═╡ 7fcf5008-27cb-11eb-268a-3b76c2e5dc9c
x * x  ## not going to work

# ╔═╡ 88a74f46-27cb-11eb-3ae5-dd5eadefddba
x .* x

# ╔═╡ c5b26a98-27cd-11eb-05fb-ad39ac05eed4
x .^ 3

# ╔═╡ 96d66e26-27cb-11eb-396b-136b1fc04b93
begin
	u= 5 + im
	conj( u )
end

# ╔═╡ 74c004d6-27cc-11eb-33d5-65cc150b628c
begin
	ia = zeros(3,3) .+ u
	ia[2,1]= 0
	ia', transpose(ia)  ## Julia dropped .'
end

# ╔═╡ 078f2276-27cd-11eb-0ab9-85a23b9f30ed
sqrt(A), sqrt.(A)

# ╔═╡ eec40f42-27cd-11eb-0c1a-fd4895c4dc05
begin
	k= 100
	Z= zeros(k,k)
	t_loop= @elapsed for i in 1:k
		x= -5 + 0.1 * i
		for j in 1:k
			y = -5 + 0.1 * j
			global Z[i,j]= sin(y)*x^2
		end
	end
	
	## loops are really fast in Julia, so this form not substantially different
	t_list= @elapsed ZZ= [ sin(y)*x^2 for x=-5:.1:5, y=-5:.1:5 ]
	
	t_loop, t_list
end

# ╔═╡ 5b65685e-27d2-11eb-3899-73c0a6da66f1
plot(
	plot( Z, st=:surface, camera=(40,45) ),
	plot( ZZ, st=:surface, camera=(60,45) )
	)

# ╔═╡ Cell order:
# ╠═e8d2928c-27ca-11eb-0d1e-5fdb5441de8c
# ╠═2915fa48-27ce-11eb-11f3-89c9b07bf899
# ╠═09716680-27cb-11eb-1685-5d2f4aa45d49
# ╠═29469688-27cb-11eb-2e38-3f4b8c15f3ea
# ╠═39694206-27cb-11eb-128f-ab6b90a150af
# ╠═72ca6fa0-27cb-11eb-1ffd-1b37e1fc8b24
# ╠═7fcf5008-27cb-11eb-268a-3b76c2e5dc9c
# ╠═88a74f46-27cb-11eb-3ae5-dd5eadefddba
# ╠═c5b26a98-27cd-11eb-05fb-ad39ac05eed4
# ╠═96d66e26-27cb-11eb-396b-136b1fc04b93
# ╠═74c004d6-27cc-11eb-33d5-65cc150b628c
# ╠═078f2276-27cd-11eb-0ab9-85a23b9f30ed
# ╠═eec40f42-27cd-11eb-0c1a-fd4895c4dc05
# ╠═5b65685e-27d2-11eb-3899-73c0a6da66f1
