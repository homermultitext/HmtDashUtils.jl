#= 
Run from root directory of repository like this:

     julia --project=dashboards/ dashboards/simpletext.jl
=#
using Pkg
Pkg.activate(pwd())
Pkg.resolve()
Pkg.instantiate()

assetfolder = joinpath(pwd(), "dashboards", "assets")

DASHBOARD_VERSION = "0.1.0"

using Dash
using HmtDashUtils
using CitableBase
using CitableText
using CitableCorpus
using CitableObject
using CitableImage
using CitablePhysicalText
using HmtArchive, HmtArchive.Analysis
#using Orthography


THUMBHEIGHT = 200
TEXTHEIGHT = 600



function loaddata()
    src = hmt_cex()
    normed = hmt_normalized(src)
    triples = hmt_dse(src)[1].data

    demopage = Cite2Urn("urn:cite2:hmt:msA.v1:12r")
    sampletriples = filter(tr -> tr.surface == demopage, triples)
    urnlist = map(tr -> tr.passage,sampletriples)
    
    info = hmt_releaseinfo(src)
    (normed, info, urnlist)
end
(corpus, release, textsample) = loaddata()




app = dash(assets_folder = assetfolder, include_assets_files=true)

app.layout = html_div(className = "w3-container") do
    html_div(className = "w3-container w3-light-gray w3-cell w3-mobile w3-border-left  w3-border-right w3-border-gray", 
        children = [
        dcc_markdown("*Dashboard version*: **$(DASHBOARD_VERSION)** ([version notes](https://homermultitext.github.io/dashboards/alpha-search/))")
        ]
    ),
    
    html_h1("`HmtDashUtils`: simple text display"),
    dcc_markdown("Test/demo using data loaded from **$(release)**."),
    dcc_markdown("Formatting selection of $(length(textsample)) passages occurring on folio 12 recto of the Venetus A."),
   
    html_div(className = "w3-container",
        dcc_markdown(simpletext(textsample, corpus))
    )
end


run_server(app, "0.0.0.0", debug=true)