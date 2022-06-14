### A Pluto.jl notebook ###
# v0.19.8

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ db4e0cc8-ec2e-11ec-3db1-3965cf2963c0
# ╠═╡ show_logs = false
begin
    import Pkg
    # activate a temporary environment
    Pkg.activate(mktempdir())

	Pkg.add("CitableBase")
	using CitableBase
	Pkg.add("CitableObject")
	using CitableObject
	Pkg.add("CitableText")
	using CitableText
	
	Pkg.add(url="https://github.com/homermultitext/HmtDashUtils.jl")	
	using HmtDashUtils
	Pkg.add("HmtArchive")
	using HmtArchive
	using HmtArchive.Analysis
	Pkg.add("PlutoUI")
	using PlutoUI

	Pkg.add("Markdown")
	using Markdown
end

# ╔═╡ 17e46b1d-3db5-4020-b763-5e2acdcbf7f1
md"""

TBD:

- √ select page from a menu of pages
- √ use DSE for that page to select appropriate texts
- apply selected view to format texts
"""

# ╔═╡ 904459ce-f547-4f01-b58e-b6660f82d18a
md"""> User selections"""

# ╔═╡ 36832354-f144-41ec-b0ef-75ce3b524795
md"""> UI elements"""

# ╔═╡ 4efe0789-756f-4f6e-829f-0ee498c72e8e
modesmenu = [
	"simpletext" => "Simple text",
	"illustratedtext" => "Text illustrated with physical context",
    "commentary" => "Text with commentary"
]

# ╔═╡ a484aa5e-604e-4e12-91b6-d85e0fa96e69
md"""> Load data from `hmt-current.cex`
"""

# ╔═╡ af0c8f35-d5bb-4537-94a9-a7875adf350f
   src = hmt_cex()

# ╔═╡ aeac9d9e-c521-496f-8cb8-ef91d7b49015
releaseinfo = hmt_releaseinfo(src)

# ╔═╡ 87ad09f8-d24c-4d4e-ad3b-6e3bfdc8f8c6
md"""
# Use `HmtDashUtils` to implement dynamic views of HMT texts

Viewing **$(releaseinfo)**
"""

# ╔═╡ 7a7aeafa-af4a-43c3-8eb6-136f0fc25ea9
codexlist = hmt_codices(src)

# ╔═╡ 5278eddc-e718-42ec-bef2-dbbe86aea991
codexmenu = begin
	menu = Pair{String, String}[]
    for c in codexlist
        #push!(menu, (label(c) => string(urn(c))))
		pr = string(urn(c)) =>  label(c)
		push!(menu,pr)
	end
	menu
end

# ╔═╡ 6ebefb2c-9583-44c7-9c29-af3f9bc310fe
md"""Manuscript: $(@bind codex Select(codexmenu, default="urn:cite2:hmt:msA.v1:"))  """

# ╔═╡ 3097cdcb-cbd3-42fd-af8a-8638863759ed
pagemenu = begin
	ms  = filter(c -> string(urn(c)) == codex, codexlist)[1]
	pagelist = Pair{String, String}[]
	
    for p in ms.pages
        lbl = urn(p) |> objectcomponent
        val = string(urn(p))
		pr = val => lbl
        push!(pagelist, pr)
    end
    pagelist
end

# ╔═╡ ac3c2612-5fff-43fa-a45e-2410e6b83844
md"""Page: $(@bind page Select(pagemenu, default="urn:cite2:hmt:msA.v1:1r")) Text display: $(@bind displaymode Select(modesmenu))"""

# ╔═╡ a2fb123d-79b7-4dce-b0a4-3f7fb370c5eb
normed = hmt_normalized(src)

# ╔═╡ df931d20-138a-4a8c-ba0d-f4a098ad215c
triples = hmt_dse(src)[1].data

# ╔═╡ 2af51eae-a9af-4cd1-a6fd-23c8ea0453fe
psglist =  begin
	triplesmatch = filter(tr -> tr.surface == Cite2Urn(page), triples)
	map(tr -> tr.passage,triplesmatch)
end

# ╔═╡ cf5ce922-e227-4746-b33c-c103be04b706
textcat = hmt_textcatalog(src)

# ╔═╡ 9ca27ff1-bb1b-465e-91b9-98ab89de4521
begin
	if isempty(psglist)
		md"""*No passages indexed for page **$(page)**.*
		"""
	else
		content = md_textpassages(psglist, normed, textcat, mode = displaymode)
		Markdown.parse(content)
		
	end

end

# ╔═╡ Cell order:
# ╟─db4e0cc8-ec2e-11ec-3db1-3965cf2963c0
# ╟─87ad09f8-d24c-4d4e-ad3b-6e3bfdc8f8c6
# ╟─6ebefb2c-9583-44c7-9c29-af3f9bc310fe
# ╟─ac3c2612-5fff-43fa-a45e-2410e6b83844
# ╠═9ca27ff1-bb1b-465e-91b9-98ab89de4521
# ╟─17e46b1d-3db5-4020-b763-5e2acdcbf7f1
# ╟─904459ce-f547-4f01-b58e-b6660f82d18a
# ╟─2af51eae-a9af-4cd1-a6fd-23c8ea0453fe
# ╟─36832354-f144-41ec-b0ef-75ce3b524795
# ╟─4efe0789-756f-4f6e-829f-0ee498c72e8e
# ╟─5278eddc-e718-42ec-bef2-dbbe86aea991
# ╟─3097cdcb-cbd3-42fd-af8a-8638863759ed
# ╟─a484aa5e-604e-4e12-91b6-d85e0fa96e69
# ╟─af0c8f35-d5bb-4537-94a9-a7875adf350f
# ╟─aeac9d9e-c521-496f-8cb8-ef91d7b49015
# ╟─7a7aeafa-af4a-43c3-8eb6-136f0fc25ea9
# ╟─a2fb123d-79b7-4dce-b0a4-3f7fb370c5eb
# ╟─df931d20-138a-4a8c-ba0d-f4a098ad215c
# ╟─cf5ce922-e227-4746-b33c-c103be04b706
