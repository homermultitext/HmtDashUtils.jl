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
using CitableImage
using HmtArchive, HmtArchive.Analysis

THUMBHEIGHT = 200
TEXTHEIGHT = 600



function loaddata() 
    src = hmt_cex()
    triples = hmt_dse(src)[1].data
    demopage = Cite2Urn("urn:cite2:hmt:msA.v1:12r")
   
    
    info = hmt_releaseinfo(src)
    (triples, info, demopage)
end
(dse, release, pg) = loaddata()


app = dash(assets_folder = assetfolder, include_assets_files=true)
app.layout = html_div(className = "w3-container") do
    html_h1(
        dcc_markdown("`HmtDashUtils`: overview of DSE mapping")
    ),
    dcc_markdown("Test/demo using data loaded from **$(release)**."),
    dcc_markdown("Overview of DSE mapping for folio 12 recto of Venetus A ($(pg))."),


    html_div(className="w3-col l4 m4",
        children = [
        dcc_markdown("""### Minimum parameters\n\n`md_dseoverview(pg, dse)`)"""),
        dcc_markdown(md_dseoverview(pg, dse))
        ]
    ),
  
  

    html_div(className="w3-col l4 m4",
    children = [
        dcc_markdown("""### Filter texts\n\n`md_dseoverview(pg, dse, textfilter = [CtsUrn("urn:cts:greekLit:tlg0012.tlg001.msA:")])`)"""),
        dcc_markdown(
            md_dseoverview(pg, dse, textfilter = [CtsUrn("urn:cts:greekLit:tlg0012.tlg001.msA:")])
        )
    ]
    ),
    
    html_div(className="w3-col l4 m4",
    children = [
        dcc_markdown("""### Set image size\n\n`md_dseoverview(pg, dse, ht = 50)`)"""),
        dcc_markdown(md_dseoverview(pg, dse, ht = 50))
    ]
)
   
end


run_server(app, "0.0.0.0", debug=true)