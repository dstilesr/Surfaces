
"""Given a vector field X (function R^n -> R^n), the gradient of a function F,
and a point p in R^n, this returns the projection of X at p onto the level set
of F (calculated using Gram-Schmidt)."""
function projectedvectorfield(field::Function, 
        gradientfield::Function, 
        point::Array{T,1}
        ) where {T <: AbstractFloat}
    
    grad::Array{T,1} = gradientfield(point)
    fld::Array{T,1} = field(point)
    
    return fld .- ((sum(grad .* fld)/sum(grad .^ 2)) .* grad)
end

