a = [1; 2; 3]
b = [4 5 6]
A = [1 2 3; 4 5 6]

@show A[1,3]
@show A[2,1]
@show transpose(A)

a = [1; 2; 3]
c = [7; 8; 9]
@show a'*c
@show dot(a,c)

@show eye(2)
@show eye(3)
@show zeros(4,1)
@show zeros(2,3)
@show ones(1,3)
@show ones(3,2)

B = [1 3 2; 3 2 2; 1 1 1]
@show inv(B)
@show B * inv(B)
@show inv(B)[2,1]

a = [1; 2; 3]
b = [1.0; 2; 3]

d = Array{Float64}(3)
d[1] = 1
d[2] = 2
d[3] = 3
@show d

p = Array{Float64}(3, 1)
q = Array{Float64}(1, 3)
@show p*q
@show q*p

pairs = Array{Tuple{Int64, Int64}}(3)
pairs[1] = (1,2)
pairs[2] = (2,3)
pairs[3] = (3,4)
@show pairs
pairs = [ (1,2); (2,3); (3,4) ]

ijk_array = Array{Tuple{Int64, Int64, Int64}}(3)
ijk_array[1] = (1,4,2)


# Indices and Ranges
a = [10; 20; 30; 40; 50; 60; 70; 80; 90]
@show a[1:3]
@show a[1:3:9]
@show a[end-2:end]

b = [200; 300; 400]
a[2:4] = b
@show a

c = collect(1:2:9)

A = [1 2 3; 4 5 6; 7 8 9]
@show A[:,2]
@show A[3,:]

# Printing Messages
println("Hello World")
print("Hello "); print("World"); print(" Again")
println("Hello "); println("World"); println(" Again")

a = 123.0
println("The value of a = ", a)
println("a is $a, and a-10 is $(a-10).")
b = [1; 3; 10]
println("b is $b.")
println("The second element of b is $(b[2]).")
@printf("The %s of a = %f", "value", a)

c = [ 123.12345  ;
    10.983   ;
    1.0932132  ]
for i in 1:length(c)
  println("c[$i] = $(c[i])")
end
for i in 1:length(c)
  @printf("c[%d] = %7.3f\n", i, c[i])
end

str = @sprintf("The %s of a = %f", "value", a)
println(str)

for i in 1:5
  println("This is number $i.")
end

for i in 1:5
  if i >= 3
  break
  end
  println("This is number $i.")
end

s = 0
for i in 1:length(a)
  s += a[i]
end

my_keys = ["Zinedine Zidane", "Magic Johnson", "Yuna Kim"]
my_values = ["football", "basketball", "figure skating"]

d = Dict()
for i in 1:length(my_keys)
  d[my_keys[i]] = my_values[i]
end
@show d
for (key, value) in d
	println("$key is a $value player.")
end

d["Diego Maradona"] = "football"
@show d

links = [ (1,2), (3,4), (4,2) ]
link_costs = [ 5, 13, 8 ]
link_dict = Dict()
for i in 1:length(links)
  link_dict[ links[i] ] = link_costs[i]
end
@show link_dict
for (link, cost) in link_dict
  println("Link $link has cost of $cost.")
end


# Function
function f(x,y)
	return 3x + y
end
@show f(1,3)
@show 3 * ( f(3,2) + f(5,6) )
g(x,y) = 3x+y
@show g(1,3)

function my_func(n, m)
	a = zeros(n,1)
	b = ones(m,1)
	return a, b
end
x, y = my_func(3,2)
@show x
@show y



# Scope of variables
function f1(x)
  return x+a
end
a = 0
for i in 1:10
  a = i
  println(f1(1))
end


function f2(x)
  a = 0
  return x+a
end
a = 5
println(f2(1))
println(a)


function f3(x)
  _a = 0
  return x + _a
end

a = 5
println(f3(1))
println(a)


function f4(x, a)
  return x + a
end

a = 5
println(f4(1, a))
println(a)



# Random Number Generation
@show rand()
@show rand()
@show rand(5)
@show rand(4,3)
@show rand() * 100
b = 10; a = 5; n = 10;
@show rand(n) * (b-a) + a
@show rand(1:10)
@show rand(1:10)

@show randn(2,3)
mu = 50; sigma = 3;
@show randn(10) * sigma + mu

function my_randn(n, mu, sigma)
	return randn(n) * sigma + mu
end
@show my_randn(10, 50, 3)

using StatsFuns
mu = 50; sigma = 3;
@show normpdf(mu, sigma, 52)
@show normcdf(mu, sigma, 50)
@show norminvcdf(mu, sigma, 0.5)


# File Input/Output
datafilename = "data.txt"
datafile = open(datafilename)
data = readlines(datafile)
close(datafile)
@show data

outputfilename = "results.txt"
outputfile = open(outputfilename, "w")
print(outputfile, "Magic Johnson")
println(outputfile, " is a basketball player.")
println(outputfile, "Michael Jordan is also a basketball player.")
close(outputfile)
cp(outputfilename, "results1.txt", remove_destination=true)

outputfilename = "results.txt"
outputfile = open(outputfilename, "a")
println(outputfile, "Yuna Kim is a figure skating player.")
close(outputfile)
cp(outputfilename, "results2.txt", remove_destination=true)

csvfilename = "data.csv"
csvdata = readcsv(csvfilename,  header=true)
data = csvdata[1]
header = csvdata[2]
@show data
@show header

@show start_node = round(Int, data[:,1])
@show end_node = round(Int, data[:,2])
@show link_length = data[:,3]

value1 = [1.4; 3.1; 5.3; 2.7]
value2 = [4.3; 7.0; 3.6; 6.2]

resultfile = open("result.csv", "w")
println(resultfile, "node, first value, second value")
for i in 1:length(value1)
	println(resultfile, "$i, $(value1[i]), $(value2[i])")
end
close(resultfile)
