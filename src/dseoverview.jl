

"""
"""
function md_dseoverview(pg::Cite2Urn, triples::Vector{DSETriple}; ht = 200, textfilter = [])
    iiif =  IIIFservice(HmtDashUtils.IIP_BASE, HmtDashUtils.IIP_ROOT)
    surfacetriples = filter(row -> urncontains(pg, row.surface), triples)

    textsurfacetriples = []
    if isempty(textfilter)
        textsurfacetriples = surfacetriples 
    else
        for u in textfilter
            temptriples = []
            push!(temptriples, filter(tr -> urncontains(u,tr.passage),  surfacetriples))
            textsurfacetriples = temptriples |> Iterators.flatten |> collect
        end
    end

    images = map(tr -> tr.image, textsurfacetriples)
    ictlink = ICT_BASE * "urn=" * join(images, "&urn=")
    imgmd = markdownImage(dropsubref(images[1]), iiif; ht = ht)
    string("[", imgmd, "](", ictlink, ")")

end