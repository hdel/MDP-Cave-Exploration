using POMDPs
using POMDPModelTools
using POMDPModels
using POMDPPolicies
using POMDPSimulators
using Random

include("mygridworld.jl")
include("gridworld_visualization.jl")

gw = MyGridWorld()

render(gw, (s=[6,5],))
