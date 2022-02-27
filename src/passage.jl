
"""Format `u` in a vector of content suitable for wrapping 
in a Dash html container element.
$(SIGNATURES)
"""
function passage(
    u::CtsUrn, 
    corpus::CitableTextCorpus; 
    dse = nothing, 
    commentary = nothing,
    annotations = nothing,
    images = false,
    multiforms = false,
    citations = false
    )

    #if false == images == multiforms
        simpletext(u, corpus, citations)
    #end
end


function simpletext(u::CtsUrn,corpus::CitableTextCorpus, cites = false)
    psgs = filter(psg -> urncontains(u, urn(psg)), corpus)
    formatted = []
    for psg in psgs
        if cites
            txt = passagecomponent(urn(psg))  * " " * psg.text
            push!(formatted, txt)
        else
            push!(formatted, psg.text)
        end
    end
    formatted
end