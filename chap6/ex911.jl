using JuMP, AmplNLWriter
m = Model(solver=CouenneNLSolver())
# m = Model(solver=BonminNLSolver())

@defVar(m, x>=0)
@defVar(m, y[1:2])
@defVar(m, s[1:5]>=0)
@defVar(m, l[1:5]>=0)

@setObjective(m, Min, -x -3y[1] + 2y[2])

@addConstraint(m, -2x +  y[1] + 4y[2] + s[1] ==  16)
@addConstraint(m,  8x + 3y[1] - 2y[2] + s[2] ==  48)
@addConstraint(m, -2x +  y[1] - 3y[2] + s[3] == -12)
@addConstraint(m,       -y[1]         + s[4] ==   0)
@addConstraint(m,        y[1]         + s[5] ==   4)
@addConstraint(m, -1 + l[1] + 3l[2] +  l[3] - l[4] + l[5] == 0)
@addConstraint(m,     4l[2] - 2l[2] - 3l[3]               == 0)
for i in 1:5
    @addNLConstraint(m, l[i] * s[i] == 0)
end

solve(m)

println("** Optimal objective function value = ", getObjectiveValue(m))
println("** Optimal x = ", getValue(x))
println("** Optimal y = ", getValue(y))
println("** Optimal s = ", getValue(s))
println("** Optimal l = ", getValue(l))
