# ================================================================================
#  Variables - Kuka Main
# ================================================================================
km_toolrot = (0,0,0,pi,0,0) ::(0,0,0,0,pi/2,0)
km_pickup_pose_adjust = (0,0,0,0,0,0)

km_home = (-1196.459, 1120.134, 39.639, 0.000, 0.000, -1.571) :: km_toolrot
km_home_approach = (-300.631, 1553.848, 713.290, 0.314, 0.149, -2.240) :: km_toolrot
km_end = (1124.216, -270.612, 1287.374, 0.000, 0.000, 0.000) :: km_toolrot

km_pickup = (-1690.493, 595.949, 1402.813, -1.657, 0.000, 2.669) :: km_toolrot :: km_pickup_pose_adjust
km_pickup_approach_01 = (-1170, 596.021, 1660.652, -1.618, 0.051, 2.581) :: km_toolrot
km_pickup_approach_02 = km_pickup :: (-200,0,0,0,0,0)

km_assembly_01 = (35.734, 1312.842, 1848.345, 0.464, -0.541, 2.484) :: km_toolrot
km_assembly_02 = (1467.229, -724.335, 1451.327, 0.098, -0.113, 1.424) :: km_toolrot
km_assembly_03 = (1934.054, -255.538, 1220.853, 0.000, 0.000, 1.571) :: km_toolrot
km_assembly_04 = (1934.054, 135.126, 1853.223, -0.373, 0.373, 1.538) :: km_toolrot
km_assembly_05 = (1934.054, 1264.324, 1228.771, -0.373, 0.373, 1.538) :: km_toolrot
km_assembly_06 = (1934.054, 1666.440, 1053.255, -0.128, 0.128, 1.567) :: km_toolrot

km_assembly_07 = (1934.054, 1648.191, 1074, 0.000, 0.000, 1.571) :: km_toolrot :: (-10,0,0,0,0,0)
km_assembly_dachhimmel = km_assembly_07 :: (10,0,0,0,0,0)

# ================================================================================
#  Variables - Kuka Side2
# ================================================================================
ks1_TCProt = (0,0,0,0,0,pi)
ks1_modifier_01 = (0,0,-3,0,0,-0.03)
ks1_modifier_02 = (0,0,-0.5,0,0,0.02)

ks1_home = (-162.759, 761.844, 1022.213, -2.221, 0.000, 2.221) :: ks1_TCProt
ks1_wait_pose_01 = (1275.687, -641.851, 1150.906, -2.221, -0.000, -2.221) :: ks1_TCProt
ks1_entry_pose_01 = (2020.808, -663.201, 1248.459, 0.836, 0.000, 3.028) :: ks1_TCProt
ks1_assembly_pose_01 = (2464.615, -743.862, 1300, 0.004, -0.091, 3.137) :: ks1_TCProt :: ks1_modifier_01

ks1_wait_pose_02 = (1324.971, 302.697, 1113.379, -2.221, -0.000, -2.221) :: ks1_TCProt
ks1_entry_pose_02 = (1995.329, 213.900, 1224.313, -0.793, 0.264, -2.972) :: ks1_TCProt
ks1_assembly_pose_02 = (2468.995, -21.849, 1295, 0.021, -0.210, -3.128) :: ks1_TCProt :: ks1_modifier_02

ks1_approach_assembly_01 = ks1_assembly_pose_01 :: (0,0,-150,0,0,0)
ks1_approach_assembly_02 = ks1_assembly_pose_02 :: (0,0,-150,0,0,0)

# ================================================================================
#  Variables - Kuka Side2
# ================================================================================

ks2_TCProt = (0,0,0,0,0,pi)
ks2_modifier_01 = (0,0,-3,0,0,1)
ks2_modifier_02 = (0,0,-3,0,0,-1)

ks2_home = (-162.759, 761.844, 1022.213, -2.221, 0.000, 2.221) :: ks2_TCProt
ks2_wait_pose_01 = (1082.062, 641.850, 1150.906, -2.221, -0.000, -2.221) :: ks2_TCProt
ks2_entry_pose_01 = (1827.183, 663.200, 1148.459, -0.836, 0.000, -3.028) :: ks2_TCProt
ks2_assembly_pose_01 = (2257.000, 712, 1301.5, -0.0, -0.085, -3.3) :: ks2_TCProt :: ks2_modifier_01

ks2_wait_pose_02 = (1131.346, -302.700, 1113.379, -2.221, -0.000, -2.221) :: ks2_TCProt
ks2_entry_pose_02 = (1801.704, -213.900, 1124.313, 0.800, 0.258, 2.990) :: ks2_TCProt
ks2_assembly_pose_02 = (2240.000, -16.190, 1297, 0.023, -0.168, 3.076) :: ks2_TCProt :: ks2_modifier_02

ks2_approach_assembly_01 = ks2_assembly_pose_01 :: (0,0,-100,0,0,0)
ks2_approach_assembly_02 = ks2_assembly_pose_02 :: (0,0,-100,0,0,0)

# ================================================================================
# Functions
# ================================================================================
def wake_up():
    km_pose = read(kuka_main_0, 'pose')
    ks1_pose = read(kuka_side1_0, 'pose')
    ks2_pose = read(kuka_side2_0, 'pose')
    do with kuka_main_0:
        move via p2p() to km_pose
    and do with kuka_side1_0:
        move via p2p() to ks1_pose
    and do with kuka_side2_0:
        move via p2p() to ks2_pose
    sync

# ================================================================================
# Main Program
# ================================================================================
wake_up()

do with kuka_main_0:
    move via p2p() to km_home

wait(100)

do with kuka_side1_0:
    move via p2p() to ks1_home
and do with kuka_side2_0:
    move via p2p() to ks2_home

wait(1000)
write(kuka_main, False, "$OUT(1)") # support leg
write(kuka_main, False, "$OUT(7)") # Suction Assembly
write(kuka_main, False, "$OUT(8)") # robot trigger

#----------home to pickup-------#
do with kuka_main_0:
    move via p2p() to km_home
    move via line() to km_home_approach
    move via p2p() to km_pickup_approach_01
    move via p2p() to km_pickup_approach_02
    move via line() to km_pickup with velocity(80)

wait(500)
write(kuka_main, True, "$OUT(6)") # Suction Gripper
wait(1500)


#----------pickup to assembly-------#
do with kuka_main_0:
    move via p2p() to km_pickup
    move via line() to km_pickup_approach_01
and do with kuka_side1_0:
    move via p2p() to ks1_home
    move via p2p() to ks1_wait_pose_01
and do with kuka_side2_0:
    move via p2p() to ks2_home
    move via p2p() to ks2_wait_pose_01

wait(500)
do with kuka_main_0:
    move via p2p() to km_assembly_01
    move via p2p() to km_assembly_02
    move via line() to km_assembly_03
    move via line() to km_assembly_04 with velocity(300)
    move via line() to km_assembly_05 with velocity(300)
    move via line() to km_assembly_06 with velocity(300)
    move via line() to km_assembly_07 with velocity(300)
wait(500)
write(kuka_main, True, "$OUT(7)") # Essembly
write(kuka_main, True, "$OUT(1)") # open leg


# ---------- Side Robots ---------- #
do with kuka_side1_0:
    move via p2p() to ks1_entry_pose_01
    move via line() to ks1_approach_assembly_01
and do with kuka_side2_0:
    move via p2p() to ks2_entry_pose_01
    move via line() to ks2_approach_assembly_01

# ---------- Put Ceiling into Chassis ---------- #

wait(300)
do with kuka_main_0:
    move via p2p() to km_assembly_07
    move via line() to km_assembly_dachhimmel with velocity(50)

wait(300)

# ---------- Side Robots ---------- #
# ---------- Back ---------- #
do with kuka_side1_0:
    move via p2p() to ks1_approach_assembly_01
    move via line() to ks1_assembly_pose_01 with velocity(50)
and do with kuka_side2_0:
    move via p2p() to ks2_approach_assembly_01
    move via line() to ks2_assembly_pose_01 with velocity(50)

wait(200)

do with kuka_side1_0:
    move via p2p() to ks1_approach_assembly_01 with velocity(300)
    move via line() to ks1_entry_pose_01
    move via line() to ks1_wait_pose_01 with blending(150)
and do with kuka_side2_0:
    move via p2p() to ks2_approach_assembly_01 with velocity(300)
    move via line() to ks2_entry_pose_01
    move via line() to ks2_wait_pose_01

# ---------- Front ---------- #

do with kuka_side1_0:
    move via line() to ks2_wait_pose_02
and do with kuka_side2_0:
    move via line() to ks2_wait_pose_02

do with kuka_side1_0:
    move via line() to ks2_entry_pose_02
    move via p2p() to ks1_approach_assembly_02
    move via line() to ks1_assembly_pose_02 with velocity(50)
and do with kuka_side2_0:
    move via line() to ks2_entry_pose_02
    move via p2p() to ks2_approach_assembly_02
    move via line() to ks2_assembly_pose_02 with velocity(50)

wait(200)

do with kuka_side1_0:
    move via p2p() to ks1_approach_assembly_02 with velocity(300)
    move via line() to ks1_entry_pose_02
    move via line() to ks1_wait_pose_02 with blending(150)
and do with kuka_side2_0:
    move via p2p() to ks2_approach_assembly_02 with velocity(300)
    move via line() to ks2_entry_pose_02
    move via line() to ks2_wait_pose_02

# ---------- Back to Home ---------- #

wait(200)
write(kuka_main, False, "$OUT(6)") # Suction Gripper
wait(200)

do with kuka_main_0:
    move via line() to km_assembly_06 with velocity(50)
    move via line() to km_assembly_05 with velocity(300)
    move via line() to km_assembly_04 with velocity(300)
    move via line() to km_assembly_03
    move via p2p() to km_assembly_02
    move via p2p() to km_end