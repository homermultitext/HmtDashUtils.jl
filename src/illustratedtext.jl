

"""Format markdown for citable passages in `psgs` identified by `u`.
$(SIGNATURES)
"""
function md_illustratedtext(
    u::CtsUrn, psgs::Vector{CitablePassage}, triples::Vector{DSETriple};    
    height = 600)

    iiif =  IIIFservice(HmtDashUtils.IIP_BASE, HmtDashUtils.IIP_ROOT)

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

        pagetriples = filter(tr -> ! isnothing(match(re, string(tr.passage))), triples)
        if isempty(pagetriples)
            @warn("NO DSE ENTRY FOUND for $(u)")
            push!(formatted, "(no index entry found)")
        else
            triple = pagetriples[1]
    
            mdimg = linkedMarkdownImage(HmtDashUtils.ICT_BASE, triple.image, iiif; ht=height, caption="image")
            push!(formatted, "\n\n" * mdimg * "\n\n---")
        end


        return "`$(psglabel)` " * join(formatted, "\n")
    end
end

