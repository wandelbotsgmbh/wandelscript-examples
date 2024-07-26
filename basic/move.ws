home = (-189, -600, 260, 0, -pi, 0)
move via p2p() to home
move frame("flange") to (50, 20, 30, 0, 0, 0.3) :: home
move via line() to (50, 20, 30, 0, 0, 0) :: home
a = planned_pose()
move via line() to a :: (0, 0, -100, 0, 0, 0)
