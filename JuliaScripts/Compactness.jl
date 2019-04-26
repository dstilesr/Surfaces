
"""Tests whether the zero set of a function R^3 -> R intersects a cube
of the given size around 0. The function returns 1 if all values
of the function on the cube are positive, -1 if they are all
negative and 0 if there are both positive and negative values
(and hence zeros)."""
function searchcube(func::Function,
        size::Float64=50.0,
        gridpoints::Int64=200
    )
    
	grida::LinRange{Float64} = LinRange(-size,size,gridpoints)
    gridb::LinRange{Float64} = copy(grida)
	
	initval::Float64 = func(-size,-size,-size)
	initval == 0.0 && return 0
	
	retval::Int64 = 1
	if initval < 0.0
        retval = -1
    end
	
	temp::Int64 = 0
	
	for i in grida, j in gridb
		temp = pointcheck(func, i, j, size)
		temp * retval <= 0 && return 0
	end
	
	return retval
end


function pointcheck(func::Function, i::Float64, j::Float64, size::Float64)
	val::Float64 = func(-size,i,j)
	val == 0 && return 0
	
	temp::Float64 = func(size,i,j)
	temp*val <= 0.0 && return 0
	
	temp = func(i,-size,j)
	temp*val <= 0.0 && return 0
	
	temp = func(i,size,j)
	temp*val <= 0.0 && return 0
	
	temp = func(i,j,-size)
	temp*val <= 0.0 && return 0
	
	temp = func(i,j,size)
	temp*val <= 0.0 && return 0
	
	if val > 0
		return 1
	else
		return -1
	end
end
