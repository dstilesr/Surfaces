using Calculus
using LinearAlgebra


"""
Given a test function and a restriction function, returns the corresponding
Lagrange function. This function takes a length 4 vector as argument with the 
fourth entry acting as the lambda parameter.
"""
function lagrange(func, restriction)
    
    l(x::Array{T,1}) where {T <: AbstractFloat} = 
        func(x[1:3]) + x[4] * restriction(x[1:3])
    
    return l
end


"""
Gives the index of the hessian of func at the point x.
"""
function hessianindex(func, x::Array{T, 1}) where {T <: AbstractFloat}
    h :: Symmetric{T, Array{T,2}} = Symmetric(Calculus.hessian(func, x))
    vals :: Array{T,1} = eigvals(h)
    
    index :: Int64 = 0
    for v in vals
        if v < 0
            index += 1
        elseif v == 0
            println("WARNING: Degenerate hessian at $(x).")
        end
    end
    
    index
end


"""
Given a function f and a restriction g, searches for critical points of the
lagrangian f + lambda * g and returns a vector with the indices of these 
critical points.
"""
function criticalindices(f, g, gridsize :: Float64 = 50.0, gridpoints :: Int64 = 500)
    
    lag = lagrange(f,g)
    lagrangegradient = Calculus.gradient(lag)
    
    criticalindiceslagrange(lag, lagrangegradient, gridsize, gridpoints)
end;


"""
Given the lagrangian f + lambda * g of a function f and its retriction g as 
well as the gradient of the lagrangian, searches for its critical points 
and returns a vector with the indices of these critical points.
"""
function criticalindiceslagrange(lag, lgrad, gridsize::Float64 = 50.0, gridpoints :: Int64 = 5000)
    grida::LinRange{Float64} = LinRange(-gridsize, gridsize, gridpoints)
    gridb::LinRange{Float64} = copy(grida)
    gridc::LinRange{Float64} = copy(grida)
    gridd::LinRange{Float64} = copy(grida)
    
    scale :: Float64 = 4.5 * gridsize / gridpoints
    
    indices :: Vector{Int64} = []
    
    for i in grida, j in gridb, k in gridc, l in gridd
        grad = lgrad([i,j,k,l])
        if approximatelyzero(grad, scale)
            println("INFO: Critical point found at $([i,j,k,l])")
            append!(indices, hessianindex(lag, [i,j,k,l]))
        end
    end
    
    indices
end;


"""
Returns true if the norm of the given vector is les than the scale coefficient.
"""
function approximatelyzero(x :: Array{T,1}, scale :: T = 0.0001) where {T <: AbstractFloat}
    normsq :: T = sum(map(abs, x))
    return normsq <= scale
end;
