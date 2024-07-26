def gripper(open):
  if open:
    write(controller, "digital_out[0]", True)
    write(controller, "digital_out[1]", False)
    write(controller, "digital_out[2]", True)
  else:
    write(controller, "digital_out[0]", True)
    write(controller, "digital_out[1]", True)
    write(controller, "digital_out[2]", False)

do with robot1:
    move via p2p() to (-189, -600, 260, 0, -pi, 0)
    gripper(True)
and do with robot2:
    move via p2p() to (500, 0, 500, -2, 0, -2)
    move via p2p() to (500, 0, 500, -2, 0, -2) :: (0, 0, 100)
    move via p2p() to (500, 0, 500, -2, 0, -2)
    gripper(False)