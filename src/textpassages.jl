
"""Format markdown header at level `level` from information in a text catalog entry.
$(SIGNATURES)
"""
function textheader(catentry::CatalogedText; level = 3)
    title = catentry.group * ", *" * catentry.work * "* (" * catentry.version * ")"
    repeat("#", level) * " " * title
end

"""Remove examplar IDs from CTS URNs.
$(SIGNATURES)
"""
function normalizehmtreff(reff::Vector{CtsUrn})
    map(u -> dropexemplar(u), reff)
end


"""Convert URNs to HMT normal form so we can subsequently optimize by comparing on strings
rather than costly `urncontains`.
$(SIGNATURES)
"""
function normalizehmtreff(psgs::Vector{CitablePassage})
    map(p -> CitablePassage(dropexemplar(p.urn), p.text), psgs)
    #=
    scholia = filter(p -> HmtArchive.Analysis.isscholion(p.urn), psgs)
    other  = filter(p -> ! HmtArchive.Analysis.isscholion(p.urn), psgs)
    otherpsgs = map(p -> CitablePassage(dropexemplar(p.urn), p.text), other)
    scholiapsgs = map(p -> CitablePassage(dropversion(p.urn), p.text), scholia)
    vcat(scholiapsgs, otherpsgs)
    =#
end




"""Format markdown for all citable passages in `psgs` identified by `urns`.
$(SIGNATURES)
""" 
function md_textpassages(rawurns::Vector{CtsUrn}, rawpassages::Vector{CitablePassage}, catalog::TextCatalogCollection;  mode = :simpletext)    
    
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

        # Switch on mode!
        if mode == "simpletext"
            push!(md, md_simpletext(u, psgs))
        else
            push!(md, "UNRECOGNIZED/UNSUPPORTED MODE: $(mode) ($(u))")
        end
    end
    join(md, "\n\n")
end


"""Format markdown for all citable passages in `c` identified by `urns`.
$(SIGNATURES)
"""
function md_textpassages(urns::Vector{CtsUrn}, c::CitableTextCorpus, catalog::TextCatalogCollection; mode = "simpletext")
    md_textpassages(urns, c.passages, catalog, mode = mode)
end
