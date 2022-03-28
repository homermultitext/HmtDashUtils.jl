

"""Format markdown for citable passages in `psgs` identified by `u`.
$(SIGNATURES)
"""
function md_illustratedtext(u::CtsUrn, psgs::Vector{CitablePassage})
    re  = string(u) * "(\\.lemma|\\.comment)*\$" |> Regex
    selected = filter(p -> ! isnothing(match(re, string(p.urn))), psgs)

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
    if isempty(selected)
        @warn("NO MATCHES FOR $(u)")
        ""
    else
        firstu = selected[1].urn
        psglabel = HmtArchive.Analysis.isscholion(u) ? passagecomponent(collapsePassageBy(firstu, 1)) : passagecomponent(firstu)

        return "`$(psglabel)` " * join(formatted, "\n")
    end
end


"""Format markdown for all citable passages in `psgs` identified by `urns`.
$(SIGNATURES)
""" 
function md_illustratedtext(rawurns::Vector{CtsUrn}, rawpassages::Vector{CitablePassage}, catalog::TextCatalogCollection)    
    
    # Convert URNs to HMT normal form so we can 
    # subsequently optimize by comparing on strings
    # rather than costly `urncontains`
    psgs = normalizehmtreff(rawpassages)
    urns = normalizehmtreff(rawurns)

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
        @debug("Formatting $(u)")
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
        push!(md, md_illustratedtext(u, psgs))
    end
    join(md, "\n\n")
end


"""Format markdown for all citable passages in `c` identified by `urns`.
$(SIGNATURES)
"""
function md_illustratedtext(urns::Vector{CtsUrn}, c::CitableTextCorpus, catalog::TextCatalogCollection)
    md_simpletext(urns, c.passages, catalog)
end