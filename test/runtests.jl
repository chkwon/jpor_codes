Pkg.update()

no_test = Set(["runtests.jl", "mcnf.jl"])

org_dir = pwd()
code_dir = normpath(joinpath(dirname(@__FILE__), ".."))
current = readdir(code_dir)

fails = Array{Any,1}()
errors = Array{Any,1}()

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


for i in 1:length(fails)
    info(fails[i], " fails")
    warn(errors[i])
end



println("JuMP v", Pkg.installed("JuMP"))
println("Optim v", Pkg.installed("Optim"))
println("MathProgBase v", Pkg.installed("MathProgBase"))

versioninfo()
