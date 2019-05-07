# Package for ODE solving
using DifferentialEquations

# From file
include("VectorFieldUtils.jl")


"""Given a vector field X and the gradient field of a function F"""
function findprojectedtrajectory(field::VecField, 
        gradientfield::VecField,
        u0::Array{T,1},
        tspan=(0.0,1.0)
        ) where {T <: AbstractFloat}
		
    odefunc(du, u, p, t) = findprojectedtrajectory(field
												   , gradientfield
												   , u
												  )
	prob = ODEProblem(odefunc, u0, tspan)
	return solve(prob)
end