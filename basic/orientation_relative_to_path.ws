set_default_orientation('relative')
set_blending(0.1)
move via p2p() to [0, 0, 0, - pi *5 / 4, 0, 0]
move via line() to ([1, 0, 0])
move via arc([2, 1, 0]) to ([1, 2, 0])
move via line() to ([0, 2, 0])
move via arc([-1, 1, 0]) to  ([0, 0, 0])
a = planned_pose()