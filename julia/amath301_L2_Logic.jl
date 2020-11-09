### A Pluto.jl notebook ###
# v0.12.6

using Markdown
using InteractiveUtils

# ╔═╡ 01c0eb82-1f2a-11eb-2cb7-4da9041e6e3c
begin
	using Plots
	
	f(x) = exp(x) - tan(x)
	x= -10:0.1:5
	
	plot( x, f.(x), label="" )
end

# ╔═╡ d8d7c940-1f2a-11eb-0643-d7047027981f
begin
	track= Array{Float64}(undef,0,2)
	let xₗ= -4, xₕ= -2, xₘ
	
		for i=1:50
			xₘ= ( xₗ + xₕ ) / 2 ;
			y= f(xₘ)
			global track= vcat(track, [xₘ y] )
			if ( y > 0 )
				xₗ= xₘ
			else
				xₕ= xₘ
			end
		end
	xₘ
	end
end

# ╔═╡ 9961b980-1f2d-11eb-395a-dbe9f236f453
plot( 1:2:length(track), track, layout=2, label=["position" "value"] )

# ╔═╡ Cell order:
# ╠═01c0eb82-1f2a-11eb-2cb7-4da9041e6e3c
# ╠═d8d7c940-1f2a-11eb-0643-d7047027981f
# ╠═9961b980-1f2d-11eb-395a-dbe9f236f453
