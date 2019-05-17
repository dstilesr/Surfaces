# Libraries
using LinearAlgebra


"""Calculatesthe length of a curve given as an array of points."""
function curvelength(curve::Array{Array{T,1},1}) where {T <: AbstractFloat}
	numpoints::Int64 = length(curve)
	len::T = zero(T)
	diff::Array{T,1} = Array{T,1}(undef, length(curve[1]))
	
	for i = 2:numpoints
		diff = curve[i] - curve[i-1]
		len += sqrt(dot(diff,diff))
	end
	
	return len
end


"""Uses a simple Cauchy criterion to determine whether a curve (given as an 
array of points) converges as the index increases. Returns a boolean value that
tells whether convergence was found and an array (the point of convergence if found,
the last point on the curve if not)."""
function curveCauchy(curve::Array{Array{T,1},1}, ϵ::T=0.0001, start::Int64=10) where {T <: AbstractFloat}
	n::Int64 = length(curve)
	n <= start && error("Start index is out of curve bounds.")
	
	i::Int64 = start
	done::Bool = false
	converged::Bool = false
	diff::Array{T,1} = Array{T,1}(undef, length(curve[1]))
	
	while !done
		diff = curve[i] - curve[i-1]
		if sqrt(dot(diff,diff)) < ϵ
			done = true
			converged = true
		else if i == n
			done = true
		else
			i += 1
		end
	end
	
	return converged, curve[i]
end