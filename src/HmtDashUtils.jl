module HmtDashUtils
using Dash
using Documenter, DocStringExtensions

using CitableAnnotations
using CitableBase
using CitableCorpus
using CitableImage
using CitableObject
using CitablePhysicalText
using CitableText
using HmtArchive, HmtArchive.Analysis


export md_textpassages
export md_simpletext, ms_illustratedtext
export md_dseoverview

include("constants.jl")
include("dseoverview.jl")
include("textpassages.jl")
include("simpletext.jl")
include("illustratedtext.jl")


end # module
