"""Format markdown for citable passages in `psgs` identified by `u`.
$(SIGNATURES)
"""
function md_simpletext(u::CtsUrn, psgs::Vector{CitablePassage})
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


