@testset "Test simple formatting of text passages" begin
    f = joinpath(pwd(), "data", "hmt-2022k.cex")
    corpus = fromcex(f, CitableTextCorpus, FileReader)
    normalizedtexts = filter(
        psg -> endswith(workcomponent(psg.urn), "normalized"),
        corpus.passages)

    psg1 = CtsUrn("urn:cts:greekLit:tlg0012.tlg001.msA:1.1")    
    
    @test dash_passage(psg1, normalizedtexts) == ["Μῆνιν ἄειδε θεὰ Πηληϊάδεω Ἀχιλῆος"]
    @test dash_passage(psg1, normalizedtexts, citations = true) == ["1.1 Μῆνιν ἄειδε θεὰ Πηληϊάδεω Ἀχιλῆος"]
    
end