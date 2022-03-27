
function textheader(catentry::CatalogedText; level = 3)
    title = catentry.group * ", *" * catentry.work * "* (" * catentry.version * ")"
    repeat("#", level) * " " * title
end



## MOVE LABEL FORMATTING OUT OF HERE INTO WRAPPING LOOP: PASS IN LABEL AS PARAM HERE.
"""Format markdown for citable passages in `psgs` identified by `u`.
$(SIGNATURES)
"""
function simpletext(u::CtsUrn, psgs::Vector{CitablePassage})
    selected = filter(psg -> urncontains(u, urn(psg)), psgs)
    formatted = []
    for psg in selected
        if isempty(psg.text)
            # do nothing
        else
            lbl = ""
            if HmtArchive.Analysis.isscholion(u)
                # ...
                lbl = "(scholion)"
            else
                lbl = passagecomponent(u)
            end
            if endswith(passagecomponent(psg.urn), "lemma")
                push!(formatted, "`$(lbl)` **" * psg.text * "**")
            else
                push!(formatted, "`$(lbl)` " * psg.text)
            end
        end
    end
    join(formatted, "\n")
end


"""Format markdown for all citable passages in `psgs` identified by `urns`.
$(SIGNATURES)
""" 
function simpletext(urns::Vector{CtsUrn}, psgs::Vector{CitablePassage}, catalog::TextCatalogCollection)
    
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
        if droppassage(u) == currenttext
        else
            catentries = filter(e -> e.urn == droppassage(u), catalog.entries)
            if isempty(catentries)
                @warn("NO CATALOG ENTRY for $(droppassage(u))")
                ""
            else
                push!(md, textheader(catentries[1]))
            end
            currenttext = droppassage(u)
        end
        push!(md, simpletext(u, psgs))
    end
    join(md, "\n\n")
end


"""Format markdown for all citable passages in `c` identified by `urns`.
$(SIGNATURES)
"""
function simpletext(urns::Vector{CtsUrn}, c::CitableTextCorpus, catalog::TextCatalogCollection)
    simpletext(urns, c.passages, catalog)
end