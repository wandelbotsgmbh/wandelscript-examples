# Mounting Options

C2_HOME_J = {1.5897, 3.27264, -0.76968, -3.7037, -0.0100, 0.5302}
C2_PICK_1_APPROACH_J = {1.4261, 3.7930, -1.9048, -2.0187, -0.1638, -0.8059}
C2_PICK_1_J = {1.2423, 3.7864, -1.8289, -2.0036, -0.3255, -0.6244}
C2_PICK_2_J = {1.2158, 3.3697, -1.6964, -1.7163, -0.3776, -0.6278}
C2_PICK_3_J = {1.3194, 3.1702, -1.0822, -2.1466, -0.2741, -0.6114}
C2_PICK_4_J = {1.3332, 3.5116, -1.2306, -2.3426, -0.2604, -0.6082}

C2_PICK_2 = [381.6, 413.8, -46.6, 0.7134, 1.4655, 0.6981]

# Platine 1
C2_SCANNER_APPROACH = [30.0, 488.8, 200.1, 1.9, 0.6, 1.9]
C2_SCANNER = [36.6, 467.8, 314.5, 1.9, 0.6, 1.9]
C2_SCANNER_LEAVE = [36.6, 330, 314.5, 1.9, 0.6, 1.9]

# Platine 2
C2_SCANNER_APPROACH_2 = [30.0, 488.8, 200.1,  0.7077, 1.4675, 0.7426]
C2_SCANNER_2 = [36.6, 467.8, 314.5,  0.7077, 1.4675, 0.7426]
C2_SCANNER_LEAVE_2 = [36.6, 330, 314.5,  0.7077, 1.4675, 0.7426]

C2_PLACE_1_APPROACH = [272.4, 31.2, 472.2, -1.7, 0.9, -1.7]
C2_PLACE_2_APPROACH = [341.1, 22.2, 620.6, -0.4896, 1.4767, -0.506]

C2_PLACE_1 = [352.3, -8.5, 446.2, -1.7, 0.9, -1.7]
C2_PLACE_2 = [381.1, 10.7, 623.8, -0.4896, 1.4767, -0.506]

def cell2_ur_open_gripper():
    write(cell2_ur, True, "tool_out[0]")
    write(cell2_ur, False, "tool_out[1]")

def cell2_ur_close_gripper():
    write(cell2_ur, False, "tool_out[0]")
    write(cell2_ur, True, "tool_out[1]")


# ---------------- programm ------------ '
velocity(300)

cell2_ur_open_gripper()
do with cell2_ur_0:
    move via joint_p2p() to C2_HOME_J
    move via p2p() to C2_PICK_2 :: [0, 0, -50, 0, 0, 0]
    move via p2p() to C2_PICK_2
    cell2_ur_close_gripper()

wait(1000)

do with cell2_ur_0:
    move via p2p() to C2_PICK_2 :: [0, 0, -50, 0, 0, 0]
    move via p2p() to C2_SCANNER_APPROACH
    move via line() to C2_SCANNER with velocity(50)

wait(2000)

do with cell2_ur_0:
    move via line() to C2_SCANNER_LEAVE_2 with velocity(50)
    move via p2p() to C2_PLACE_2 :: [0, 0, -50, 0, 0, 0]
    move via p2p() to C2_PLACE_2 :: [0, 0, -12, 0, 0, 0] with velocity(50)
    cell2_ur_open_gripper()

wait(1000)

velocity(300)
do with cell2_ur_0:
    move via p2p() to C2_PLACE_2 :: [0, 0, -50, 0, 0, 0]
    move via p2p() to C2_SCANNER_LEAVE_2
    move via joint_p2p() to C2_HOME_J


wait(2000)

do with cell2_ur_0:
    move via joint_p2p() to C2_HOME_J
    move via p2p() to C2_SCANNER_APPROACH_2
    move via p2p() to C2_SCANNER_LEAVE_2
    move via p2p() to C2_PLACE_2 :: [0, 0, -50, 0, 0, 0]
    move via p2p() to C2_PLACE_2 with velocity(50)
    cell2_ur_close_gripper()

wait(500)

do with cell2_ur_0:
    move via line() to C2_PLACE_2 :: [0, 0, -100, 0, 0, 0]
    move via p2p() to C2_SCANNER_LEAVE_2
    move via p2p() to C2_SCANNER_APPROACH_2
    move via p2p() to C2_PICK_2 :: [0, 0, -50, 0, 0, 0]
    move via p2p() to C2_PICK_2 :: [0, 0, -10, 0, 0, 0] with velocity(50)
    cell2_ur_open_gripper()

wait(500)

do with cell2_ur_0:
    move via p2p() to C2_PICK_2 :: [0, 0, -100, 0, 0, 0]
    move via joint_p2p() to C2_HOME_J
