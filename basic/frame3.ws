move [tcp1 | robot1] via p2p() to (-200, -600, 250, 0, -pi, 0)
move [tcp2 | robot2] via p2p() to (-200, -500, 250, 0, -pi, 0)

a = read(robot1, tcp1)
b = read(robot2, tcp2)