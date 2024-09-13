# Robot Agnostic 

C1_HOME_J = [1.3950, 0.6053, 0.3194, 0.0089, 0.6564, 1.3092]

C1_PICK_APPROACH_ROTATED = (-62.1, 421.9, 434.9, -2.223, -2.22, 0)
C1_PICK_1 = (-44.9, 412.9, 118.8, 0, -3.1, 0)
C1_PICK_2 = (-231, 383.2, 119.1, 0, -3.1001, 0.0002)
C1_PICK_3 = (-265.7, 567.5, 118.8, -0.0001, -3.1079, 0.0113)
C1_PICK_4 = (-81.1, 595.1, 118.8, -0.0003, -3.1019, 0.0062)


# Piece 1
C1_SCANNER_APPROACH = (237.3, 478.1, 457.8, -2.225, -2.222, 0)
C1_SCANNER = (352.9, 478.1, 457.8, -2.224, -2.221, 0)
C1_SCANNER_LEAVE = (353.6, 319.0, 457.7, -2.226, -2.223, 0)

# Piece 2
C1_SCANNER_APPROACH_2 = (237.3, 478.1, 457.8, 0, -3.1, 0)
C1_SCANNER_2 = (352.9, 478.1, 457.8, 0, -3.1, 0)
C1_SCANNER_LEAVE_2 = (353.6, 319.0, 457.7, 0, -3.1, 0)

C1_PLACE_APPROACH = (484.3, 15.3, 200.9, -3.148, 0, 0)
C1_PLACE_1 = (452.2, -12.1, 132, 3.1, 0.0, 0.0)
C1_PLACE_2 = (635, 5, 132, 3.1367, 0, -0.0054)

def cell1_abb_open_gripper():
    write(cell1_abb, True, "Local/SC_1/SC1CBCOK")
    write(cell1_abb, False, "Local/SC_1/SC1CBCPREWARN")


def cell2_abb_close_gripper():
    write(cell1_abb, False, "Local/SC_1/SC1CBCOK")
    write(cell1_abb, True, "Local/SC_1/SC1CBCPREWARN")

# ---------------- programm ------------ '
velocity(300)

cell1_abb_open_gripper()

do with cell1_abb_0:
    move via joint_p2p() to C1_HOME_J
    move via p2p() to C1_PICK_2 :: (0, 0, -50, 0, 0, 0)
    move via line() to C1_PICK_2
    cell2_abb_close_gripper()

wait(1000)

do with cell1_abb_0:
    move via line() to C1_PICK_2 :: (0, 0, -50, 0, 0, 0)
    move via line() to C1_SCANNER_APPROACH_2
    move via line() to C1_SCANNER_2 with velocity(50)

wait(2000)

do with cell1_abb_0:
    move via line() to C1_SCANNER_APPROACH_2 with velocity(50)
    move via line() to C1_PLACE_2 :: (0, 0, -50, 0, 0, 0)
    move via line() to C1_PLACE_2 with velocity(50)
    cell1_abb_open_gripper()

wait(1000)

velocity(300)
do with cell1_abb_0:
    move via line() to C1_PLACE_APPROACH
    move via joint_p2p() to C1_HOME_J

# Bringe back
wait(2000)
do with cell1_abb_0:
    move via p2p() to C1_PLACE_2 :: (0, 0, -50, 0, 0, 0)
    move via p2p() to C1_PLACE_2 :: (0, 0, 12.8, 0, 0, 0) with velocity(50)
    cell2_abb_close_gripper()

wait(500)

do with cell1_abb_0:
    move via p2p() to C1_PLACE_2 :: (0, 0, -50, 0, 0, 0)
    move via joint_p2p() to C1_HOME_J
    move via p2p() to C1_PICK_2 :: (0, 0, -50, 0, 0, 0)
    move via p2p() to C1_PICK_2 :: (0, 0, -5, 0, 0, 0)
    cell1_abb_open_gripper()

wait(500)

do with cell1_abb_0:
    move via joint_p2p() to C1_HOME_J
