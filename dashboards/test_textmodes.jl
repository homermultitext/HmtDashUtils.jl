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
        dcc_markdown("`HmtDashUtils`: user-configurable text viewing")
    ),
    dcc_markdown("Test/demo using data loaded from **$(release)**."),
    dcc_markdown("Formatting selection of $(length(sampleurns)) passages occurring on folio 12 recto of the Venetus A."),

    html_div(className="w3-container",
        html_div(className="w3-col l4 m4",
            dcc_dropdown(
                id="textmode",
                options = [
                    (label = "Simple text", value = "simpletext"),
                    (label = "Text illustrated with physical context", value = "illustratedtext"),
                    (label = "Text with commentary", value = "commentary")
                ],
                value = :simpletext,
            )
        )
    ),

    html_div(id = "displaychoice",
    className = "w3-container w3-light-gray w3-cell w3-mobile w3-border-left  w3-border-right w3-border-gray"),
    

    html_div(className = "w3-container",
    id = "results"
        #dcc_markdown(md_textpassages(sampleurns, corpus, catalog))
    )
end


callback!(
    app,
    Output("displaychoice", "children"),
    Output("results", "children"),
    Input("textmode", "value")
) do mode
    msg = dcc_markdown("**Text display mode**: `$(mode)`")

    formatted = md_textpassages(sampleurns, corpus, catalog, mode = mode)
    (msg, dcc_markdown(formatted))
end

run_server(app, "0.0.0.0", debug=true)