# Package for ODE solving
using DifferentialEquations

# From file
include("VectorFieldUtils.jl")

"""Given a vector field X and the gradient field of a function F"""
function findprojectedtrajectory(field::Function, 
        gradientfield::Function,
        u0::Array{T,1},
        tspan
        ) where {T <: AbstractFloat}
		
    odefunc(du, u, p, t) = findprojectedtrajectory(field
												   , gradientfield
												   , u
												  )
	prob = ODEProblem(odefunc, u0, tspan)
	return solve(prob)
end