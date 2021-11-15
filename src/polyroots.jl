using Pkg; Pkg.add("DoubleFloats")

using PolynomialRoots
using DelimitedFiles
using BenchmarkTools
using DoubleFloats

# Our program takes an input of a .csv file of formatted vectorrs with the first row devoted to the header, 
# a string representation of the rational vector composing the polynomial. The program exports the resulting
# roots to a csv in the same directory. 

function loadData(filename)
    datadirpath = "data/"
    filepath = joinPath(datadirpath, filename)
    try
        qRootsMatrix, headers = readdlm(filepath, ',', Double64; header=true) 
        return qRootsMatrix, headers
    catch
        println("ERROR: File not found or of invalid type.")
    end
end

function joinPath(a, b)
    try
        c = a * b
        return c
    catch
        println("ERROR: Input must be valid String") 
    end
end

# Function takes in a matrix of roots, and their respective headers returning a dictionary (hashmap)
# of the roots keyed on headers. 
function polyRoots(qRootsSource, headers)
    global rootsdict = Dict(headers[1]=>[], headers[2]=>[1+0im], headers[3]=>[1+0im], headers[4]=>[0+0im])
    n = 1
    for col in eachcol(qRootsSource)
        if get(rootsdict, headers[n], 0) == 0
           r = roots(col)
           rootsdict[headers[n]] = r
        end
        n += 1
    end  
    return rootsdict
end 

qRootsMatrix, headers = loadData("q_to_denom_30.csv")
@btime roots = polyRoots(qRootsMatrix, headers)
