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
	
	Pkg.add(url="https://github.com/homermultitext/HmtDashUtils.jl")	
	using HmtDashUtils
	Pkg.add("HmtArchive")
	using HmtArchive
	using HmtArchive.Analysis
	Pkg.add("PlutoUI")
	using PlutoUI
end

# ╔═╡ 17e46b1d-3db5-4020-b763-5e2acdcbf7f1
md"""

TBD:

- select page from a menu of pages
- use DSE for that page to select appropriate texts
- apply selected view to format texts
"""

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

# ╔═╡ 7a0186b9-e756-4f01-9c1c-7bd2301b0f72
codexlist[6] |> urn

# ╔═╡ a2fb123d-79b7-4dce-b0a4-3f7fb370c5eb
normed = hmt_normalized(src)

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
md"""Manuscript: $(@bind codex Select(codexmenu, default="urn:cite2:hmt:msA.v1:"))"""

# ╔═╡ df931d20-138a-4a8c-ba0d-f4a098ad215c
triples = hmt_dse(src)[1].data

# ╔═╡ cf5ce922-e227-4746-b33c-c103be04b706
textcat = hmt_textcatalog(src)

# ╔═╡ Cell order:
# ╟─db4e0cc8-ec2e-11ec-3db1-3965cf2963c0
# ╟─87ad09f8-d24c-4d4e-ad3b-6e3bfdc8f8c6
# ╟─6ebefb2c-9583-44c7-9c29-af3f9bc310fe
# ╟─17e46b1d-3db5-4020-b763-5e2acdcbf7f1
# ╟─a484aa5e-604e-4e12-91b6-d85e0fa96e69
# ╟─af0c8f35-d5bb-4537-94a9-a7875adf350f
# ╟─aeac9d9e-c521-496f-8cb8-ef91d7b49015
# ╠═7a0186b9-e756-4f01-9c1c-7bd2301b0f72
# ╟─7a7aeafa-af4a-43c3-8eb6-136f0fc25ea9
# ╟─a2fb123d-79b7-4dce-b0a4-3f7fb370c5eb
# ╟─5278eddc-e718-42ec-bef2-dbbe86aea991
# ╟─df931d20-138a-4a8c-ba0d-f4a098ad215c
# ╟─cf5ce922-e227-4746-b33c-c103be04b706
