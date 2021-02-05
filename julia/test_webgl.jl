### A Pluto.jl notebook ###
# v0.12.20

using Markdown
using InteractiveUtils

# ╔═╡ a35dfdd8-674c-11eb-0dd8-bb9478231fdd
using JSServe ; Page(exportable=true, offline=true)

# ╔═╡ b0c1d882-4e24-11eb-0162-eff5edb3e259
begin
	using Random
	using WGLMakie
end

# ╔═╡ 26f89c58-4e4c-11eb-0fdc-e92a81ba81ab
md"Create some initial points to plot"

# ╔═╡ 5a4dd6c2-4e4c-11eb-28f4-35b8ff167b3f
begin
	U= rand( -1.:.001:1, 3, 1000 )
	pts= Point3.(U[:,i] for i ∈ 1:size(U,2))
	
	scene= Scene()
	meshscatter!( scene, pts, markersize= 0.02, color=:red )
	scene
end

# ╔═╡ Cell order:
# ╠═a35dfdd8-674c-11eb-0dd8-bb9478231fdd
# ╠═b0c1d882-4e24-11eb-0162-eff5edb3e259
# ╟─26f89c58-4e4c-11eb-0fdc-e92a81ba81ab
# ╠═5a4dd6c2-4e4c-11eb-28f4-35b8ff167b3f
