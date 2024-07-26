home = (-189, -600, 260, 0, -pi, 0)

for i = 0..5:
    move via p2p() to home
    move via line() to (50, 20, 30, 0, 0, 0.3) :: home
    move via line() to (150, 20, 30, 0, 0, 0.3) :: home
    move via line() to (50, 20, 30, 0, 0, 0.3) :: home
    move via p2p() to home
