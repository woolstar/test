### A Pluto.jl notebook ###
# v0.12.7

using Markdown
using InteractiveUtils

# ╔═╡ f8a24230-2319-11eb-3f72-575159de5a6d
using Plots ;  using JLD ;  using JSON ;

# ╔═╡ 46f8ff10-2319-11eb-098c-9dc369d49b53
## Plotting and data
#
# https://www.youtube.com/watch?v=g5cg-lJIoKw

# ╔═╡ 9d323540-2319-11eb-0c70-11d5320e00ca
begin
	x1=-10:0.1:10 ; y1=sin.(x1) ;
	plot(x1,y1)
end

# ╔═╡ ef44a520-2319-11eb-22d0-55418da862de
begin
	x2=[-5; sqrt(3); π; 4]; y2= sin.(x2) ;
	plot(x1,y1, lw=4)
	plot!(x2,y2,lw=2, marker="o", ms=6)
end

# ╔═╡ d81b3410-231c-11eb-01cf-7d73b0f06587
begin
	# linspace is called range
	x3= range(-10,10,length=64) ; y3= x3 .* sin.(x3) ;

	# plotting attributes https://docs.juliaplots.org/latest/generated/attributes_series/
	pl= plot([x1, x2, x3], [y1,y2,y3],
		color= [:blue :cyan :magenta ],
		lw= [4 0 2], ls= [:auto :auto :dash],  # line width, line style
		shape= [:none :circle :diamond],
		ms= [0 6 4],  # marker size
		title="my graph", titlefontsize= 15,
		lab=["sin" "discrete" "sinx"], legend=(0.675,0.875), legendfont=10 )
end

# ╔═╡ 16330fc0-2390-11eb-0dd8-3380769b914b
plot(
	plot( [x1, x2, x3], [y1,y2,y3], lab=["sin" "discrete" "sinx"], border=:none ),
	plot( x1, y1, lab="sin θ" ),
	plot( x2, y2, lab="discrete", color=:red ),
	plot( x3, y3, lab="sinx", color=:green ),
	plot( x3, y3, proj=:polar, lab="", color=:green ),
	layout= @layout [a{0.7h} ; grid(1,4) ]
	)
	

# ╔═╡ aea66370-23a8-11eb-174c-416cec59daaa
collect( zip(x3,y3) )

# ╔═╡ f0736610-23a6-11eb-028d-eb377ab1a62a
## io, where will this go
begin
	save("sinx.jld", "x", x3, "y", y3 ) ;
	open("sinx.json"; lock=true, write=true) do f
		JSON.print( f, Dict(:x => x3, :y => y3 ) )
	end;
end

# ╔═╡ a9d830c0-2430-11eb-3ca5-fbd4ee370cdc
begin
	recᵤ= load("sinx.jld")
	recᵥ= JSON.parsefile("sinx.json")
	
	plot( [x3, recᵤ["x"], recᵥ["x"]], [y3, recᵤ["y"], recᵥ["y"]],
		color=[:blue :green :red], lab=["orig" "hld5" "json"],
		layout=(1, 3) )
end

# ╔═╡ 10f4fe10-2435-11eb-0035-eb977bd8ab46
savefig( pl, "myfig.pdf" ) ;  savefig( pl, "myfig.png" ) ;

# ╔═╡ Cell order:
# ╠═46f8ff10-2319-11eb-098c-9dc369d49b53
# ╠═f8a24230-2319-11eb-3f72-575159de5a6d
# ╠═9d323540-2319-11eb-0c70-11d5320e00ca
# ╠═ef44a520-2319-11eb-22d0-55418da862de
# ╠═d81b3410-231c-11eb-01cf-7d73b0f06587
# ╠═16330fc0-2390-11eb-0dd8-3380769b914b
# ╠═aea66370-23a8-11eb-174c-416cec59daaa
# ╠═f0736610-23a6-11eb-028d-eb377ab1a62a
# ╠═a9d830c0-2430-11eb-3ca5-fbd4ee370cdc
# ╠═10f4fe10-2435-11eb-0035-eb977bd8ab46
