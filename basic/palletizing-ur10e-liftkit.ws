liftkit_position = "2:EwellixLiftkit0S/Position"
liftkit_status = "2:EwellixLiftkit0S/Status"
liftkit_move = "2:EwellixLiftkit0S/Move(newPosition)"
liftkit_connect = "2:EwellixLiftkit0S/Connect(host)"
liftkit_host = "192.168.1.100"

box_length = read(database, "box_length")
box_width = read(database, "box_width")
box_height = read(database, "box_height")
pallet_length = box_length * 3
pallet_width = box_width * 2
pallet_layers = 1
box_offset = read(database, "box_offset")

home = (-536, -399, 621, 2.88, -1.25507, 0)
pick_pose = (-925, 207, -243, 2.88, -1.2, -0.11) # read(database, "pickup_base")
pre_drop_pose = (404, -632, 587, 2.88, -1.25507, 0)
drop_pose = (320, -1074, -250, 2.88, -1.25507, 0)
# drop_pose = (966, -420, -256, 2.88, -1.25507, 0) #  read(database, "dropoff_base")
# other drop pose (-30, -701, -246, 2.88, -1.2, -0.11)

approach_vector = (0, 0, -300)
liftkit_pick_position = 0.0
cols = floor(pallet_width / box_width)
rows = floor(pallet_length / box_length)

def toggle_gripper(vacuum):
    if vacuum:
        write(io, "tool_out[0]", False)
        write(io, "tool_out[1]", False)
    else:
        write(io, "tool_out[0]", True)
        write(io, "tool_out[1]", True)
        #wait 1000
        #write(io, "tool_out[0]", False)
        #write(io, "tool_out[1]", True)

def gripper_off():
    write(io, "tool_out[0]", False)
    write(io, "tool_out[1]", True)

def get_axis_position():
    return read(opcua, liftkit_position)

def move_axis(position_in_mm):
    move via p2p() to home
    sync
    call(opcua, liftkit_move, position_in_mm + 0.01)
    wait 1500
    while read(opcua, liftkit_status) == "MOVING":
        wait 500

def calculate_drop_poses(initial_drop_pose):
    poses = []
    for c = 0..<cols:
        for r = 0..<rows:
            offset_x = r * box_offset
            offset_y = c * box_offset
            drop_pose = initial_drop_pose :: (0, 0, 0, 0, 0, 0 * pi / 4) :: (-c * box_width - offset_y, -r * box_length - offset_x, 0, 0, 0, 0) :: (0, 0, 0, 0, 0, 0 * pi / 4)
            poses = poses + [drop_pose]
    return poses

def pick_next_box():
    move via p2p() to pick_pose :: (0, 0, -300)
    move via line() to pick_pose
    sync
    toggle_gripper(True)
    move via line() to pick_pose :: (0, 0, -300)
    move via p2p() to home

def drop_box(drop_pose):
    move via p2p() to pre_drop_pose
    sync
    move via p2p() to drop_pose :: approach_vector
    move via line() to drop_pose
    sync
    wait 200
    # BUG: does not respect the wait without the movement
    toggle_gripper(False)
    move via p2p() to (0, 0, 1, 0, 0, 0) :: drop_pose
    sync
    wait 1000
    sync
    move via p2p() to (0, 0, 0, 0, 0, 0) :: drop_pose
    sync
    gripper_off()
    move via line() to drop_pose :: approach_vector
    move via p2p() to pre_drop_pose
    move via p2p() to home

poses = calculate_drop_poses(drop_pose)

gripper_off()
# call(opcua, liftkit_connect, liftkit_host)
velocity(1200)
move via p2p() to home
# move_axis(liftkit_pick_position)

for h = 0..<1:
    # height_offset = box_height * h
    for i = 0..len(poses) - 1:
        # move_axis(liftkit_pick_position)
        pick_next_box()
        #move_axis(height_offset)
        drop_box(poses[i])
    move via p2p() to home

move via p2p() to home
# move_axis(liftkit_pick_position)
gripper_off()
