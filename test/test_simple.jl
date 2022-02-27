@testset "Test simple formatting of text passages" begin
    f = joinpath(pwd(), "data", "hmt-2022")
    corpus = fromcex(f, CitableTextCorpus, FileReader)
    normalizedtexts = filter(
        psg -> endswith(workcomponent(psg.urn), "normalized"),
        corpus.passages)

    dse =     

end