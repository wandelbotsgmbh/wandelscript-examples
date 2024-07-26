# robot poses
UR_HOME = [508.1, 140.1, 569.2, pi, 0, 0]

UR_PICK_01 = [-13.8, -374.2, 337.0, pi, 0, 0]
UR_PICK_APPROACH_OFFSET = -100

UR_PLACE = [404.0, 535.4, 448.5, pi, 0, 0]
UR_PLACE_APPROACH_OFFSET = -80

ABB_HOME = [524.6, -250.3, 578.4, 0, 0, 2.9]
ABB_PICK_APPROACH = [398, -450.6, 460, 0, -0.3, 2.9]
ABB_PICK = [398, -450.6, 420, 0, -0.3, 2.9]
ABB_DROP = [25.5, 673.5, 424.8, 0, 0, 2.9]

# Conveyor:
# Run the conveyor to the right (velocity > 0)
CONVEYOR_TRIGGER = "digital_out[4]"
CONVEYOR_LEFT = "digital_out[5]"
CONVEYOR_RIGHT = "digital_out[6]"

SENSOR_CONVEYOR_RIGHT = "digital_in[0]"
SENSOR_CONVEYOR_LEFT = "digital_in[1]"

DI_04_BUTTON_IO = "digital_in[4]"
DI_05_BUTTON_IO = "digital_in[5]"

LIGHT_TABLE = "digital_out[7]"

UR_TCP = frame("TCP")

# Set this to true when you run the skill only on virtual robot
IS_ONLY_VIRTUAL = False 

def start_conveyor_right():
    write(ur, True, "digital_out[4]")
    write(ur, False, "digital_out[5]")
    write(ur, True, "digital_out[6]")

def stop_conveyor():
    write(ur, True, "digital_out[4]")
    write(ur, False, "digital_out[5]")
    write(ur, False, "digital_out[6]")

def start_conveyor_left():
    write(ur, True, "digital_out[4]")
    write(ur, True, "digital_out[5]")
    write(ur, False, "digital_out[6]")

# UR suction gripper
def open_ur_gripper():
    write(ur, True, "tool_out[0]")
    write(ur, False, "tool_out[1]")
    
def close_ur_gripper():
    write(ur, False, "tool_out[0]")
    write(ur, True, "tool_out[1]")

# ABB parallel gripper
def open_abb_gripper():
    write(ur, True, "digital_out[0]")
    write(ur, False, "digital_out[1]")
    write(ur, True, "digital_out[2]")

def close_abb_gripper():
    write(ur, True, "digital_out[0]")
    write(ur, True, "digital_out[1]")
    write(ur, False, "digital_out[2]")

SL_RED = 22
SL_YELLOW = 21
SL_GREEN = 20

def stack_light(light, on):    
    if IS_ONLY_VIRTUAL == True:
        print("OPCUA is not yet supported.")
    #else:
    #    write(opcua, on, "4:Numeric:" + to_string(light))

def light_table(on):
    write(ur, on, LIGHT_TABLE)

def startup():
    open_ur_gripper()
    open_abb_gripper()
    stop_conveyor()
    start_conveyor_left()

def get_grid_pose(corner_pose, idx):
    grid_step = 87
    grid_n = 3
    dir_1 = [grid_step * modulo(idx, grid_n), 0, 0, 0, 0, 0]
    dir_2 = [0, grid_step * intdiv(idx, grid_n), 0, 0, 0, 0]
    pose_for_idx = corner_pose :: dir_1 :: dir_2
    return pose_for_idx

def single_box(box_num):
    velocity(200)
    acceleration(200)
    ur_pick = get_grid_pose(UR_PICK_01, box_num)
    ur_pick_approach = ur_pick :: [0, 0, UR_PICK_APPROACH_OFFSET, 0, 0, 0]

    do with ur_0:
        move UR_TCP via p2p() to UR_HOME
        move UR_TCP via p2p() to ur_pick_approach with velocity(800)
        move UR_TCP via line() to ur_pick with velocity(50)
        close_ur_gripper()
    wait(1000)

    ur_place_approach = UR_PLACE :: [0, 0, UR_PLACE_APPROACH_OFFSET, 0, 0, 0]
    do with ur_0:
        move UR_TCP via line() to ur_pick_approach
        start_conveyor_left()
        with blending(50), velocity(800):
            move UR_TCP via p2p() to UR_HOME
            move UR_TCP via line() to ur_place_approach
        move UR_TCP via line() to UR_PLACE with velocity(100)
        open_ur_gripper()
    wait(1000)

    do with ur_0:
        start_conveyor_right()
        move UR_TCP via line() to ur_place_approach
        move UR_TCP via p2p() to UR_HOME
    and do with abb_0:
        move via p2p() to ABB_HOME
        move via line() to ABB_PICK_APPROACH
    
    if IS_ONLY_VIRTUAL == False:
        wait_for_bool_io(ur, SENSOR_CONVEYOR_RIGHT, True)
    else:
        wait(1000)

    do with abb_0:
        move via line() to ABB_PICK with velocity(50)
        stop_conveyor()

        close_abb_gripper()
    wait(500)

    do with abb_0:
        move via line() to ABB_PICK_APPROACH with velocity(50)
        with blending(50), velocity(200):
            move via p2p() to ABB_HOME 
            move via p2p() to ABB_DROP

        open_abb_gripper()
        move via line() to ABB_DROP :: [0, 0, 10] with velocity(200)

    wait(1000)

    do with abb_0:
        move via line() to ABB_HOME with velocity(200)

    stop_conveyor()

def main(start_box, end_box):
    stack_light(SL_RED, True)
    for box_num = (start_box-1)..(end_box-1):
        print(box_num)
        button_di_04_pressed = False
        button_di_05_pressed = False

        while True:
            button_di_05_not_pressed = read(ur, DI_05_BUTTON_IO)
            if read(ur, DI_04_BUTTON_IO) == True:
                button_di_04_pressed = True
                break
            if read(ur, DI_05_BUTTON_IO) == True:
                button_di_05_pressed = True
                break

        # reset_cell()
        if button_di_04_pressed:
            print("NEXT")
            light_table(True)
            single_box(box_num)
            button_di_04_pressed = False
            light_table(False)
        if button_di_05_pressed:
            print("RESET")
            box_num = 0
            light_table(True)
            single_box(box_num)
            button_di_05_pressed = False
            light_table(False)

    stack_light(SL_RED, False)


startup()
main(1, 9)