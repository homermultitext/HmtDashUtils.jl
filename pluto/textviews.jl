### A Pluto.jl notebook ###
# v0.19.8

using Markdown
using InteractiveUtils

# ╔═╡ db4e0cc8-ec2e-11ec-3db1-3965cf2963c0
# ╠═╡ show_logs = false
begin
    import Pkg
    # activate a temporary environment
    Pkg.activate(mktempdir())
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
codexlist[5]

# ╔═╡ a2fb123d-79b7-4dce-b0a4-3f7fb370c5eb
normed = hmt_normalized(src)

# ╔═╡ df931d20-138a-4a8c-ba0d-f4a098ad215c
triples = hmt_dse(src)[1].data

# ╔═╡ cf5ce922-e227-4746-b33c-c103be04b706
textcat = hmt_textcatalog(src)

# ╔═╡ Cell order:
# ╠═db4e0cc8-ec2e-11ec-3db1-3965cf2963c0
# ╟─87ad09f8-d24c-4d4e-ad3b-6e3bfdc8f8c6
# ╟─17e46b1d-3db5-4020-b763-5e2acdcbf7f1
# ╟─a484aa5e-604e-4e12-91b6-d85e0fa96e69
# ╟─af0c8f35-d5bb-4537-94a9-a7875adf350f
# ╟─aeac9d9e-c521-496f-8cb8-ef91d7b49015
# ╠═7a0186b9-e756-4f01-9c1c-7bd2301b0f72
# ╟─7a7aeafa-af4a-43c3-8eb6-136f0fc25ea9
# ╟─a2fb123d-79b7-4dce-b0a4-3f7fb370c5eb
# ╟─df931d20-138a-4a8c-ba0d-f4a098ad215c
# ╟─cf5ce922-e227-4746-b33c-c103be04b706
