#= 
Run from root directory of repository like this:

     julia --project=dashboards/ dashboards/test_simpletext.jl
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
using HmtArchive, HmtArchive.Analysis

THUMBHEIGHT = 200
TEXTHEIGHT = 600



function loaddata() 
    src = hmt_cex()
    normed = hmt_normalized(src)
    triples = hmt_dse(src)[1].data
    textcat = hmt_textcatalog(src)
    demopage = Cite2Urn("urn:cite2:hmt:msA.v1:12r")
    sampletriples = filter(tr -> tr.surface == demopage, triples)
    urnlist = map(tr -> tr.passage,sampletriples)
    
    info = hmt_releaseinfo(src)
    (normed, textcat, info, urnlist)
end
(corpus, catalog, release, sampleurns) = loaddata()




app = dash(assets_folder = assetfolder, include_assets_files=true)

app.layout = html_div(className = "w3-container") do

    
    html_h1(
        dcc_markdown("`HmtDashUtils`: simple text display")),
    dcc_markdown("Test/demo using data loaded from **$(release)**."),
    dcc_markdown("Formatting selection of $(length(sampleurns)) passages occurring on folio 12 recto of the Venetus A."),
   
    html_div(className = "w3-container",
        dcc_markdown(md_simpletext(sampleurns, corpus, catalog))
    )
end


run_server(app, "0.0.0.0", debug=true)