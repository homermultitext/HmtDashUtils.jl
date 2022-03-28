
"""Format markdown header at level `level` from information in a text catalog entry.
$(SIGNATURES)
"""
function textheader(catentry::CatalogedText; level = 3)
    title = catentry.group * ", *" * catentry.work * "* (" * catentry.version * ")"
    repeat("#", level) * " " * title
end

"""Format markdown for citable passages in `psgs` identified by `u`.
$(SIGNATURES)
"""
function md_simpletext(u::CtsUrn, psgs::Vector{CitablePassage})
    lbl = ""
    
    selected = filter(psg -> urncontains(u, urn(psg)), psgs)
 
    formatted = []
    for psg in selected
        if isempty(psg.text)
            # do nothing
        else
            if endswith(passagecomponent(psg.urn), "lemma")
                push!(formatted, "**" * psg.text * "**")
            else
                push!(formatted, psg.text)
            end
        end
    end
    firstu = selected[1].urn
    psglabel = HmtArchive.Analysis.isscholion(u) ? passagecomponent(collapsePassageBy(firstu, 1)) : passagecomponent(firstu)


    return "`$(psglabel)` " * join(formatted, "\n")
end

"""Format markdown for all citable passages in `psgs` identified by `urns`.
$(SIGNATURES)
""" 
function md_simpletext(urns::Vector{CtsUrn}, psgs::Vector{CitablePassage}, catalog::TextCatalogCollection)    
    currenttext = urns[1] |> droppassage
    catentries = filter(e -> e.urn == currenttext, catalog.entries)
    hdr = if isempty(catentries)
        @warn("NO CATALOG ENTRY for $(currenttext)")
        ""
    else
        textheader(catentries[1])
    end

    md  = [hdr]
    for u in urns
        @info("Formatting $(u)")
        if droppassage(u) == currenttext
        else
            catentries = filter(e -> e.urn == droppassage(u), catalog.entries)
            if isempty(catentries)
                @warn("NO CATALOG ENTRY for $(droppassage(u))")
            else
                push!(md, textheader(catentries[1]))
            end
            currenttext = droppassage(u)
        end
        push!(md, md_simpletext(u, psgs))
    end
    join(md, "\n\n")
end


"""Format markdown for all citable passages in `c` identified by `urns`.
$(SIGNATURES)
"""
function md_simpletext(urns::Vector{CtsUrn}, c::CitableTextCorpus, catalog::TextCatalogCollection)
    md_simpletext(urns, c.passages, catalog)
end
