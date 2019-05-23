# The difference with nh5 is in the precomputed (by hand) derivatives of the vector field 
# Faster: using eigenvalues to find principal curvatures
# Save files to use with gnuplot
# Interactive
# Changed check if a point is umbilic


using LinearAlgebra

using DelimitedFiles 


f(x, y, z) = x^4 + y^4/16 + z^4/81 - 1.0

# coordinates of normal vector field
v1(x, y, z) = 4*x^3
v2(x, y, z) = y^3/4
v3(x, y, z) = 4*z^3/81

v(x, y, z) = [ v1(x, y, z); v2(x, y, z); v3(x, y, z) ] 

# coordinates of the differential of the normal vector field
dv11(x, y, z) = 12*x^2 
dv12(x, y, z) = 0
dv13(x, y, z) = 0
dv21(x, y, z) = 0
dv22(x, y, z) = 3*y^2/4
dv23(x, y, z) = 0
dv31(x, y, z) = 0
dv32(x, y, z) = 0
dv33(x, y, z) = 4*z^2/27

dv(x, y, z) = [ dv11(x, y, z) dv12(x, y, z) dv13(x, y, z); dv21(x, y, z) dv22(x, y, z) dv23(x, y, z); dv31(x, y, z) dv32(x, y, z) dv33(x, y, z) ]


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

# the differential of n = v/||v||
function dnv(x, y, z)
	vv = v(x, y, z)
	nn = normv(x, y, z)
	dvv = dv(x, y, z)
	tt = (1/nn^3) * vv' * dvv 
	A = (1/nn)*dvv - vv*tt
        return(A)
end


#principal curvatures
function is_umbilic_point(x, y, z, eps)
        AA = dnv(x, y, z)
	res = 1
        aa = eigvals(AA)
        if abs(aa[1]^2 + aa[2]^2 + aa[3]^2) < eps 
	   res = 0
	end
	if abs( (aa[1] - aa[2])*(aa[1] - aa[3])*(aa[2] - aa[3]) ) < eps
	   res = 0
        end
        return res
end

# umbilical points
# a, b, c: the dimensions of the parallelipiped  which embraces the surface 
# condition for selecting umbilical points of the surface: |difference of the principal curvatures| < eps1
# condition for selecting points of the surface: |f|< eps1

function umbilic_points(a, b, c, N::Int64, eps1, eps)
         surface_points = [ ]
         umbilic_points = [ ]                                                                                                                         
	 for x in range(-a, a, length=N)
          for y in range(-b, b, length=N)
           for z in range(-c, c, length=N)
                   if abs(f(x, y, z)) < eps1 
                      push!(surface_points, [x, y, z])
                      if is_umbilic_point(x, y, z, eps) == 0  
#                          println("Umbilic point: ", "x=", x, " y=", y, " z=", z) 
                           push!(umbilic_points, [x, y, z])
                     end
                   end
           end
          end
         end
#        println(surface_points)
#        println("Umbilic points=", umbilic_points)
         println("There are ", length(surface_points), " surface points")        
         println("There are ", length(umbilic_points), " umbilic points")        
    return [surface_points, umbilic_points]
 end

# some interactivity

stop = 1

while stop == 1 

   println("Number_of_points?")
   answer = readline()
   number_of_points = parse(Int64, answer)
   println("number_of_points= ", number_of_points)
   println("eps1 for surface points?")
   answer = readline()
   eps1 = parse(Float64, answer)
   println("eps1= ", eps1)
   println("eps for umbilical points?")
   answer = readline()
   eps = parse(Float64, answer)
   println("eps= ", eps)


# returning to calculus

  @time results = umbilic_points(1.0, 2.0, 3.0, number_of_points, eps1, eps)

# files to use with gnuplot

println("The name of file where to write the results? (Press n if you would like not to save the results)")
  answer = readline()
  if answer == "n"
      println("We will not write any results. They are awful, aren't they?")
  else
      println("So we write the results in " * answer * "_surface.out and in " * answer *"_umbilic.out.")
      writedlm(answer*"_surface.out", results[1])
      writedlm(answer*"_umbilic.out", results[2])
  end

  println("Finish ([y]/n)?")
  answer = readline()
  if answer == "n"
     println("Are you not tired? Ok, we will continue")
     else
     println("your answer is to stop here. I understand you :) Ciao")
     global stop=0
  end
end

