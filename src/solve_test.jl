#using POMDPModels
using StaticArrays, Parameters, POMDPs, Random, QMDP, DiscreteValueIteration, POMDPModelTools
include("./mygridworld.jl")


mdp = MyGridWorld()

solver = ValueIterationSolver(max_iterations=100, belres=1e-6, verbose=true)
policy = solve(solver, mdp) # compute a pomdp policy
