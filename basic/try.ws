do:
    move via p2p() to (-200, -600, 260, 0, pi, 0)
    move via p2p() to (-200, -600, 300, 0, pi, 0)
    raise "some artificial error"
    move via p2p() to (-200, -600, 250, 0, pi, 0)
sync:
    print("Hello World")
except:
    stopped_pose = read(robot, 'pose')
    move via p2p() to (-200, -600, 350, 0, pi, 0)
    final_pose = read(robot, 'pose')
