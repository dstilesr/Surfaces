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