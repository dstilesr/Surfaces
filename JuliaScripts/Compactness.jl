
"""Tests whether the zero set of a function R^3 -> R intersects a cube
of the given size around 0. The function returns 1 if all values
of the function on the cube are positive, -1 if they are all
negative and 0 if there are both positive and negative values
(and hence zeros)."""
function searchcube(func::Function,
        size::Float64=50.0,
        gridpoints::Int64=200
    )
    
    retval::Int64 = searchxfaces(func, size, gridpoints)
	retval == 0 && return 0
	
	temp::Int64 = searchyfaces(func, size, gridpoints)
	if (retval > 0 && temp < 0) || (retval < 0 && temp > 0)
		return 0
	end
	
	temp = searchzfaces(func, size, gridpoints)
	if (retval > 0 && temp < 0) || (retval < 0 && temp > 0)
		return 0
	end
	
	return retval
end

"""Auxiliary to search cube faces with x fixed."""
function searchxfaces(func::Function,
                size::Float64=50.0,
                gridpoints::Int64=200
            )
    grida::LinRange{Float64} = LinRange(-size,size,gridpoints)
    gridb::LinRange{Float64} = copy(grida)
    
    retval::Int64 = 1
    temp::Float64 = func(-size, -size, -size)
    if temp < 0
        retval = -1
    elseif temp > 0
        retval = 1
    else
        return 0
    end
	
	for i in grida, j in gridb
		temp = func(-size, i, j)
		if (temp <= 0) && (retval > 0)
			return 0
		elseif (temp >= 0) && (retval < 0)
			return 0
		end
		
		temp = func(size, i, j)
		if (temp <= 0) && (retval > 0)
			return 0
		elseif (temp >= 0) && (retval < 0)
			return 0
		end
	end
    
    return retval
end


"""Auxiliary to search cube faces with y fixed."""
function searchyfaces(func::Function,
                size::Float64=50.0,
                gridpoints::Int64=200
            )
    grida::LinRange{Float64} = LinRange(-size,size,gridpoints)
    gridb::LinRange{Float64} = copy(grida)
    
    retval::Int64 = 1
    temp::Float64 = func(-size, -size, -size)
    if temp < 0
        retval = -1
    elseif temp > 0
        retval = 1
    else
        return 0
    end
	
	for i in grida, j in gridb
		temp = func(i, -size, j)
		if (temp <= 0) && (retval > 0)
			return 0
		elseif (temp >= 0) && (retval < 0)
			return 0
		end
		
		temp = func(i, size, j)
		if (temp <= 0) && (retval > 0)
			return 0
		elseif (temp >= 0) && (retval < 0)
			return 0
		end
	end
    
    return retval
end

"""Auxiliary to search cube faces with z fixed."""
function searchzfaces(func::Function,
                size::Float64=50.0,
                gridpoints::Int64=200
            )
    grida::LinRange{Float64} = LinRange(-size,size,gridpoints)
    gridb::LinRange{Float64} = copy(grida)
    
    retval::Int64 = 1
    temp::Float64 = func(-size, -size, -size)
    if temp < 0
        retval = -1
    elseif temp > 0
        retval = 1
    else
        return 0
    end
	
	for i in grida, j in gridb
		temp = func(i, j, -size)
		if (temp <= 0) && (retval > 0)
			return 0
		elseif (temp >= 0) && (retval < 0)
			return 0
		end
		
		temp = func(i, j, size)
		if (temp <= 0) && (retval > 0)
			return 0
		elseif (temp >= 0) && (retval < 0)
			return 0
		end
	end
    
    return retval
end