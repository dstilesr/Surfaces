# Faster: using eigenvalues to find principal curvatures

using Calculus

using LinearAlgebra

using DelimitedFiles

f(x, y, z) = x^2 + 0.25*y^2 + z^2/9.0 - 1.0

# coordinates of normal vector field
v1(x, y, z) = 2*x
v2(x, y, z) = y/2
v3(x, y, z) = 2*z/9

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
function dnv(x::Float64, y::Float64, z::Float64)
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
function princurv(x::Float64, y::Float64, z::Float64)::Array{Float64,1}
        ncurv_values = [ ]
        AA = dnv(x, y, z)
        for aa in eigvals(AA)
                if abs(aa) > 10^(-9)
                        push!(ncurv_values, aa)
                end
        end
        return [minimum(ncurv_values), maximum(ncurv_values)]
end

# umbilical points
# a, b, c: the dimensions of the parallelipiped  which embraces the surface 
# condition for selecting umbilical points of the surface: |difference of the principal curvatures| < eps1
# condition for selecting points of the surface: |f|< eps1

function umbilic_points(a::Float64, b::Float64, c::Float64, N::Int64, eps::Float64,  eps1::Float64)
         surface_points = [ ]
         umbilic_points = [ ]                                                                                                                                                  
         for x in range(-a, a, length=N)
          for y in range(-b, b, length=N)
           for z in range(-c, c, length=N)
                   if abs(f(x, y, z)) < eps1 
                     push!(surface_points, [x, y, z])
                     if abs(princurv(x, y, z)[1] - princurv(x, y, z)[2]) < eps
#                           println("Umbilic point: ", "x=", x, " y=", y, " z=", z) 
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
   println("eps for umbilic points?")
   answer = readline()
   epsilon = parse(Float64, answer)
   println("eps1 for surface points?")
   answer = readline()
   epsilon1 = parse(Float64, answer)


# returning to calculus

  @time results = umbilic_points(1.0, 2.0, 3.0, number_of_points, epsilon, epsilon1)

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

