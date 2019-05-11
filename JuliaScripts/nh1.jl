# This is a program for finding umbilical points of a non-holonomic surface

# for taking numerical derivatives
using Calculus

# coordinates of normal vector field 
v1(x, y, z) = 2*x  
v2(x, y, z) = 2*y 
v3(x, y, z) = -1

# vector product
function vprod(v, w)
	return [ v[2]*w[3] - v[3]*w[2]; v[3]*w[1] - v[1]*w[3]; v[1]*w[2] - v[2]*w[1] ]  
end

# scalar product 
function sprod(v, w)
	return  (transpose(v)*w)[1, 1]  
end

# the norm of the vector field
normv(x, y, z) = sqrt(v1(x, y, z)^2 + v2(x, y, z)^2 + v3(x, y, z)^2) 

# coordinates of the unitary vector field n
nv1(x, y, z) = v1(x, y, z)/normv(x, y, z) 
nv2(x, y, z) = v2(x, y, z)/normv(x, y, z) 
nv3(x, y, z) = v3(x, y, z)/normv(x, y, z) 
# the unitary vector field n
nv(x, y, z) = [ nv1(x, y, z);  nv2(x, y, z);  nv3(x, y, z) ] 

# d(n)
function dnv(x, y, z) 
  a1 = Calculus.gradient(x -> nv1(x[1], x[2], x[3]))([x, y, z])
  a2 = Calculus.gradient(x -> nv2(x[1], x[2], x[3]))([x, y, z])
  a3 = Calculus.gradient(x -> nv3(x[1], x[2], x[3]))([x, y, z])
  A = [ a1[1] a1[2] a1[3]; a2[1] a2[2] a2[3]; a3[1] a3[2] a3[3] ]
  return(A)
end


# normal curvature
function ncurv(x, y, z, v)
	return sprod(v, dnv(x, y, z)*v)/sprod(v, v)
end

#principal curvatures
function princurv(x, y, z)
	AA = dnv(x, y, z)
	e1 = [ AA[1, 1]; AA[2, 1]; AA[3,1] ]
	e1 = e1/sqrt( (transpose(e1)*e1)[1, 1])
	e2 = vprod( nv(x, y, z), e1 )
	e(t) = cos(t)*e1 + sin(t)*e2 
	ncurv_values = [ ncurv(x, y, z, e(t)) for t in range(0, 2*pi, length = 100) ]
	return [minimum(ncurv_values), maximum(ncurv_values)] 
end

# umbilical points

function umbilic_points(a, b, c, N, eps)
         umbilic_points = [ ]  
	 for x in range(-a, a, length=N)
	  for y in range(-b, b, length=N)
	   for z in range(-c, c, length=N)
		   if abs(princurv(x, y, z)[1] - princurv(x, y, z)[2]) < eps
			   println("Umbilic point: ", "x=", x, " y=", y, " z=", z) 
			   push!(umbilic_points, [x, y, z])
		   end
	   end
          end
         end
	 println(umbilic_points)
 end

 umbilic_points(10, 10, 10, 100, 0.01)

           
