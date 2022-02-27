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

export dash_passage
export dash_mspage

include("passage.jl")

end # module
