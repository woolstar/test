### A Pluto.jl notebook ###
# v0.12.17

using Markdown
using InteractiveUtils

# ╔═╡ 51395710-431a-11eb-2d2d-037faedaf347
begin
	function main_width( x )
		property= "max-width: $(x)px"
		@htl """ <script> document.getElementsByTagName("main")[0].style= "$property" </script>"""
	end
end

# ╔═╡ 0808dc16-431a-11eb-2974-4ff22020e128
## hacking up the properties of this document

begin
	using HypertextLiteral
	
	## magic
	main_width(820)
end

# ╔═╡ Cell order:
# ╠═0808dc16-431a-11eb-2974-4ff22020e128
# ╠═51395710-431a-11eb-2d2d-037faedaf347
