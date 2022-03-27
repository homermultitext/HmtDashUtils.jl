
"""Format `u` in a vector of content suitable for wrapping 
in a Dash html container element.
$(SIGNATURES)
"""
function dash_passage(
    u::CtsUrn, passages::Vector{CitablePassage};
    dse = nothing, 
    commentary = nothing,
    annotations = nothing,
    images = false,
    multiforms = false,
    citations = false
    )

    #if false == images == multiforms
        simpletext(u, passages, citations)
    #end
end



"""Format markdown for citable passages in `psgs` identified by `u`.
$(SIGNATURES)
"""
function simpletext(u::CtsUrn, psgs::Vector{CitablePassage})
    selected = filter(psg -> urncontains(u, urn(psg)), psgs)
    formatted = []
    for psg in selected
        push!(formatted, psg.text)
    end
    join(formatted, "\n")
end


"""Format markdown for all citable passages in `psgs` identified by `urns`.
$(SIGNATURES)
"""
function simpletext(urns::Vector{CtsUrn}, psgs::Vector{CitablePassage})
    md  = []
    for u in urns
        push!(md, simpletext(u, psgs))
    end
    join(md, "\n")
end


"""Format markdown for all citable passages in `c` identified by `urns`.
$(SIGNATURES)
"""
function simpletext(urns::Vector{CtsUrn}, c::CitableTextCorpus)
    simpletext(urns, c.passages)
end