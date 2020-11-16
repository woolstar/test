### A Pluto.jl notebook ###
# v0.12.10

using Markdown
using InteractiveUtils

# ╔═╡ f88f2b86-27ac-11eb-15f0-253b10c9be3b
## looking at errors in representations
#
# https://www.youtube.com/watch?v=jxpqAZ2JrPk

# ╔═╡ 4d8faac4-27ae-11eb-0bbd-d7f2e53585db
let val= 10
	for i in 1:100
		 val -= 0.1
	end

	bitstring(0.1),  ## repeating in-exact representation
	val
end

# ╔═╡ 4c8da490-27af-11eb-1582-d345ae0bd883
let val= 25
	for i in 1:100
		val -= 0.25
	end

	bitstring(0.25),
	val
end

# ╔═╡ b3f8f742-27af-11eb-2319-816d8c3b686d
eps(Float64)

# ╔═╡ Cell order:
# ╠═f88f2b86-27ac-11eb-15f0-253b10c9be3b
# ╠═4d8faac4-27ae-11eb-0bbd-d7f2e53585db
# ╠═4c8da490-27af-11eb-1582-d345ae0bd883
# ╠═b3f8f742-27af-11eb-2319-816d8c3b686d
