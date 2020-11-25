# Autonomous Exploration in Subterranean Environments

Harrison Delecki and Joshua Ott

AA228/CS238, Stanford University

## Introduction

The DARPA Subterranean Challenge is a competition to develop robust systems that can
operate in extreme environments. The problem is that current technologies fail to provide
persistent situational awareness of unique subterranean environments such as caves, tunnels,
and urban underground networks. The competition aims to drive novel approaches and 
technologies that would result in breakthroughs for first responders to rapidly map,
navigate, and search dynamic underground environments. These advancements would also
benefit space exploration seeing that GPS is not a feasible navigation strategy for robotic
exploration systems on terrestrial bodies.

<img src="figures/cavecircuit.png" width="500" />
Figure 1: Example of a subterranean environment


The unique subterranean environments are an ideal way to apply the principles of deci-
sion making under uncertainty [1]. Tunnels can often extend for several miles with narrow
passageways and few entrance/exit points. Urban underground environments contain more
structure as a result of being developed by humans, but often have complicated layouts
ranging multiple stories. Lastly, cave networks have irregular topologies with unpredictable
geological structures.


Our focus for this project was primarily on the concept of planning routes through these
unknown environments. The majority of the literature [2, 3, 4] proposes exploration path
planning algorithms that focus on iterative solutions drawn from a subset of the reachable
space at any given time. This can be extremely computationally intensive, especially in
the subterranean environments where tunnels and cave networks can stretch for several
miles. More recently, the focus has shifted to the local/global planning architecture [5].
The local planner focuses its computational effort on the area immediately surrounding the
robot. The local planner will then sample the discretized graph and identify the path that
would lead to the maximum exploration gain. The global planner saves computation effort
by incrementally building a graph as the robot moves through the environment to aid in
guiding the robot to the frontier when a dead-end is reached as well as allowing the robot
to return to base. Storing this graph saves the robot from recomputing a new local path
each time it hits a dead-end or has to return to base.

## Algorithm Description
For simplicity, our project will focus only on the local planner. This problem can be framed
as a Markov Decision Process (MDP) using the 2-D representation of gridworld. We will
assume that our local planner receives complete information about the surrounding (local)
environment and knows its state precisely. Based on this information, it is then able to
perform value iteration until convergence in order to determine which policy to take in each
state.

<img src="figures/cavehall.png?raw=true" width="500" />
Figure 2: Map of the GridWorld Cave Environment


In the grid world problem we have a 10×10 grid. Each cell in the grid represents a
state in an MDP. The available actions are up, down, left, and right. The effects of these
actions are stochastic. We move one step in the specified direction with probability 0.7,
and we move one step in one of the three other directions, each with probability 0.1. If
we bump against the outer border of the grid or a wall, then we do not move at all. We
have additionally added in more wall cells in order to modify the map to be like a cave
environment with one long looping passageway that leads to the goal.
In order to solve this problem, we applied value iteration to find the optimal value
functions and policies defined by:

<img src="https://render.githubusercontent.com/render/math?math=U^*_k(s) = \max_a\left[R(s, a) + \gamma \sum_{s'} T(s' \mid s, a)U^*_{k-1}(s')\right]">

<img src="https://render.githubusercontent.com/render/math?math=\pi^*(s) = \arg\max_a\left[R(s, a) + \gamma \sum_{s'} T(s' \mid s, a)U^*(s')\right]">

## Results
It is important to note that the coordinate system used in the gridworld places the [x,y]
origin at the bottom left corner. We additionally defined a binary matrix namedvalidmap
which contains a 1 corresponding to open cells and a 0 corresponding to cells that the agent
would not be able to occupy. A minor detail is that this matrix is indexed from the top
left corner while the gridworld is indexed from the bottom left corner. The goal cell with
reward of +10 is an absorbing state where no additional reward is ever received from that
point onward.

<img src="figures/cave1.png?raw=true" width="500" />
Figure 3: Map of the GridWorld Cave Environment with equal traversability

Additionally, a second matrix namedtraversabilitymapwas defined representing the
traversability of each cell. Free cells were initialized to a traversability of -0.1 as shown
below. Since all states are equally traversable it is clear to see that the agent will take the
shortest possible path to the goal as shown in figure 3. To understand the traversability
of a cell it helps to think of it in terms of the physical cave environment. In a real cave,
some terrain might be rockier than others. Likewise there may be mud, puddles, or other
unique terrrain that slow the robot down. As a result, it would be wise to avoid this terrain
if there is a significant negative reward associated with it. To represent this, we recreate
the map shown in figure 3, but now we have incorporated cells with differing amounts of
traversability. The blue area in figure 4 represents the presence of a lake. It would be unwise
for our robot to try to traverse these cells so the traversability is set to -100 and likewise
the associated reward is as well. As seen from figure 4, the robot now avoids traversing
these cells and results to taking a longer overall path in order to avoid the difficult terrain.

<img src="figures/cave2.png?raw=true" width="500" />
Figure 4: Map of the GridWorld Cave Environment with differing traversability

## Conclusion & Future Work
In this work we showed that framing the cave exploration problem as an MDP allowed
allowed us to use solution methods that can account for some of the difficult features in
subterranean environments. In future work, we will use an extension of this framework to
be more realistic in that the robot will only be able to observe the cave in a sliding window.
The goal will be to explore as much of the environment as quickly as possible. This version
of the problem can be formulated as a POMDP and be solved using similar techniques to
what we explored here.

## References

[1] Mykel J Kochenderfer. Decision making under uncertainty: theory and application.
MIT press, 2015.

[2] Andreas Bircher et al. “Receding horizon” next-best-view” planner for 3d exploration”.
In:2016 IEEE international conference on robotics and automation (ICRA). IEEE.
2016, pp. 1462–1468.

[3] Brian Yamauchi. “A frontier-based approach for autonomous exploration”. In:Proceed-
ings 1997 IEEE International Symposium on Computational Intelligence in Robotics
and Automation CIRA’97.’Towards New Computational Principles for Robotics and
Automation’. IEEE. 1997, pp. 146–151.

[4] Luke Yoder and Sebastian Scherer. “Autonomous exploration for infrastructure model-
ing with a micro aerial vehicle”. In:Field and service robotics. Springer. 2016, pp. 427–
440.

[5] Mihir Dharmadhikari et al. “Motion Primitives-based Agile Exploration Path Plan-
ning for Aerial Robotics”. In:2020 IEEE International Conference on Robotics and
Automation (ICRA). IEEE. 2020.