# Pkg.update()

isTravis = false
if length(ARGS)>0
  if ARGS[1] == "travis"
    isTravis = true
    info("Travis is ON. Testing Cbc instead of Gurobi.")
    ENV["PYTHON"]=""
  end
end


no_test = Set(["runtests.jl", "mcnf.jl"])
if isTravis
    push!(no_test, "convex_jump.jl")
end


org_dir = pwd()
code_dir = normpath(joinpath(dirname(@__FILE__), ".."))
current = readdir(code_dir)

fails = Array{Any,1}()
errors = Array{Any,1}()



function turn_gurobi(onoff)

    old_string = ""
    new_string = ""

    if onoff == :on
        old_string = "Cbc"
        new_string = "Gurobi"
    elseif onoff == :off
        old_string = "Gurobi"
        new_string = "Cbc"
    end

    for item in current
      dirpath = joinpath(code_dir, item)
      if isdir(dirpath)
        sub = readdir(dirpath)

        for file in sub
          filepath = joinpath(dirpath, file)
          if isfile(filepath) && file[end-1:end] == "jl" && file != "runtests.jl"

              f = open(filepath)
              all_s = readstring(f)
              close(f)

              if contains(all_s, old_string)
                  all_s = replace(all_s, old_string, new_string)
                  open(filepath, "w") do cbc_f
                      write(cbc_f, all_s)
                  end
              end

          end
        end
      end
    end

end

if length(ARGS)>0
  if ARGS[1] == "gurobi_on"
      turn_gurobi(:on)
      error("Gurobi turned on. Test did not run.")
  end
end

if isTravis
    turn_gurobi(:off)
else
    turn_gurobi(:on)
end






for item in current
  dirpath = joinpath(code_dir, item)
  if isdir(dirpath)
    sub = readdir(dirpath)

    for file in sub
      filepath = joinpath(dirpath, file)
      if isfile(filepath) && file[end-1:end] == "jl" && !in(file, no_test)
        info("====== Testing ", filepath, " ===============")

        f = open(filepath)
        lines = readlines(f)
        for line in lines
          if contains(line, "using")
            s = replace(line, "using ", "")
            s = replace(s, " ", "")
            s = replace(s, "\n", "")
            s = replace(s, "\t", "")
            sharp = searchindex(s, "#")
            if sharp > 0
              s = replace(s, s[sharp:end], "")
            end

            pkgs = split(s, ",")
            for pkg in pkgs
              try
                if Pkg.installed(pkg) == nothing
                  info("Adding a package: Pkg.add($pkg)")
                  Pkg.add(pkg)
                end
              catch

              end
            end
          end
        end
        close(f)


        try
          cd(dirpath)
          run(`julia --check-bound=yes --color=yes $filepath`)
          # include(filepath)
          info("$filepath ran successfuly.")
        catch e
          @show typeof(e)
          @show fieldnames(e)
          warn(" error in ", filepath)
          push!(fails, filepath)
          push!(errors, e)
          # throw(e)
        end
      end
    end

  end

end

cd(org_dir)





if isTravis
    turn_gurobi(:on)
end



for i in 1:length(fails)
  info(fails[i], " fails")
  warn(errors[i])
end



println("JuMP v", Pkg.installed("JuMP"))
println("Optim v", Pkg.installed("Optim"))
println("MathProgBase v", Pkg.installed("MathProgBase"))

versioninfo()
