# defines the pick position of the box
# 0 - 8 --> back to 0
TCP_Sucker = frame("WOS_Sucker")
TCP_HookedHook = frame("WOS_HookedHook")
TCP_ABB = frame("BASE/tool0")
LEFT_SENSOR_IO = "digital_in[1]"
RIGHT_SENSOR_IO = "digital_in[0]"
RED_BUTTON_IO = "digital_in[2]"
GREEN_BUTTON_IO = "digital_in[3]"
prod = False
debug = False
run_no = 0
abb_home = (475.7, -94.4, 553.8, -0.027, -0.024, 1.176)
ur_home = (191.6, -717.3, 433.2, 0, pi, 0)
ur_pick_pose = (184, -1038, 150, 0, pi, 0)
ur_drop_pose = (460, -832, 346, 0, pi, 0)
abb_pick_pose = (484.1, 151.4, 446.6, 0.019, 0.006, 1.335)
abb_drop_pose = (484.3, -388.3, 303, 0.017, 0.004, 1.335)

def wait_for(key, value):
  while (read(controller, key) != value):
    pass

def wait_for_left_sensor_touched():
  wait_for(LEFT_SENSOR_IO, True)

def wait_for_right_sensor_touched():
  wait_for(RIGHT_SENSOR_IO, True)

def move_conveyor_belt_to_the_left():
  already_left = read(controller, LEFT_SENSOR_IO)
  if (already_left == False):
    wait_for(RIGHT_SENSOR_IO, True)
    write(controller, "digital_out[4]", True)
    write(controller, "digital_out[5]", True)
    write(controller, "digital_out[6]", False)
    sync

def move_conveyor_belt_to_the_right():
  already_right = read(controller, RIGHT_SENSOR_IO)
  if (already_right == False):
    wait_for(LEFT_SENSOR_IO, True)
    write(controller, "digital_out[4]", True)
    write(controller, "digital_out[5]", False)
    write(controller,  "digital_out[6]", True)
    sync

def abb_gripper(open):
  if open:
    write(controller, "digital_out[0]", True)
    write(controller, "digital_out[1]", False)
    write(controller, "digital_out[2]", True)
  else:
    write(controller, "digital_out[0]", True)
    write(controller, "digital_out[1]", True)
    write(controller, "digital_out[2]", False)

def ur_gripper(on):
  if on:
    write(controller, "tool_out[1]", True)
  else:
    write(controller, "tool_out[1]", False)

def is_red_button_pressed():
  return read(controller, "digital_in[2]") == False

def is_green_button_pressed():
  return read(controller, "digital_in[3]") == False

def is_any_sensor_touched():
  return (is_left_sensor_touched() + is_right_sensor_touched()) == 1

# def is_object_in_drop_position():
#   return read(controller, "digital_in[4]") == 1

def get_grid_pose(corner_pose, idx):
  grid_step = 63
  grid_n = 3
  dir_1 = (grid_step * modulo(idx, grid_n), 0, 0, 0, 0, 0)
  dir_2 = (0, grid_step * intdiv(idx, grid_n), 0, 0, 0, 0)
  pose_for_idx = corner_pose :: dir_1 :: dir_2
  return pose_for_idx

def move_ur_to_suck_object(idx):
  pick_pose = get_grid_pose(ur_pick_pose, idx)
  move TCP_Sucker via p2p() to pick_pose :: (0, 0, -100)
  ur_gripper(True)
  move TCP_Sucker via p2p() to pick_pose
  move TCP_Sucker via p2p() to pick_pose :: (0, 0, -100)

def move_ur_to_unsuck_object():
  move TCP_Sucker via p2p() to ur_drop_pose :: (0, 0, -150)
  ur_gripper(False)
  move TCP_Sucker via p2p() to ur_drop_pose
  wait(2000)
  move TCP_Sucker via p2p() to ur_drop_pose :: (0, 0, -150)
  move TCP_Sucker via p2p() to ur_home

def move_ur_to_hook_object():
  pick_pose = [211.3, -1036.5, 211.0, 0, pi, 0] # TODO: find pick position
  move TCP_HookedHook via p2p() to pick_pose :: (0, 0, -100)
  move TCP_HookedHook via p2p() to pick_pose
  move TCP_HookedHook via p2p() to pick_pose :: (0, 0, -100)

def move_ur_to_unhook_object():
  pick_pose = (0, 0, 100, 0, pi, 0) # TODO: find pick position
  move TCP_HookedHook via p2p() to pick_pose :: (0, 0, -100)
  move TCP_HookedHook via p2p() to pick_pose
  move TCP_HookedHook via p2p() to pick_pose :: (0, 0, -100)

def move_ur_to_suck_hook():
  hook_pick_pose = (451, -543.7, 107.6, 0, pi, 0)
  move TCP_Sucker via p2p() to hook_pick_pose :: (0, 0, -100)
  move TCP_Sucker via p2p() to hook_pick_pose
  ur_gripper(True)
  move TCP_Sucker via p2p() to hook_pick_pose :: (0, 0, -100)

def move_ur_to_unsuck_hook():
  hook_drop_pose = [451, -543.7, 107.6, 0, pi, 0]
  move TCP_Sucker via p2p() to hook_drop_pose :: (0, 0, -100)
  move TCP_Sucker via p2p() to hook_drop_pose
  ur_gripper(False)
  move TCP_Sucker via p2p() to hook_drop_pose :: (0, 0, -100)

def move_abb_to_pick_object():
  with velocity(300):
    do with robot_abb1200:
        move TCP_ABB via p2p() to abb_pick_pose :: (0, 0, 100, 0, 0, 0)
        move TCP_ABB via p2p() to abb_pick_pose
    abb_gripper(False)
    wait(1000)
    do with robot_abb1200:
        move TCP_ABB via p2p() to abb_pick_pose :: (0, 0, 100)

def move_abb_to_drop_object():
  with velocity(300):
    do with robot_abb1200:
        move TCP_ABB via p2p() to abb_drop_pose :: (0, 0, 100)
        move TCP_ABB via p2p() to abb_drop_pose :: (0, 0, 0, 0, 0, 0)
        move TCP_ABB via p2p() to abb_drop_pose :: (-200, 200, 0, 0, 0, 0)
    abb_gripper(True)
    wait(500)
    do with robot_abb1200:
        move TCP_ABB via p2p() to abb_drop_pose :: (-200, 200, 100)

def reset_cell():
  ur_gripper(False)
  abb_gripper(False)
  do with robot_ur10e:
    move TCP_Sucker via p2p() to ur_home
  #and do with robot_abb1200:
  #  move via p2p() to abb_home
  # move_conveyor_belt_to_the_right()

def skill_suck(idx):
  # skill_a picks the object with a vacuum gripper
  move_ur_to_suck_object(idx)
  move_conveyor_belt_to_the_right()
  move_ur_to_unsuck_object()
  move_conveyor_belt_to_the_left()
  # ABB movement
  wait_for_left_sensor_touched()
  move_abb_to_pick_object()
  sync
  #abb_gripper(False)
  move_abb_to_drop_object()
  sync
  #abb_gripper(True)

def skill_hook():
  # skill_b picks the object with the hook
  #move_ur_to_suck_hook()
  #move_ur_to_hook_object()
  #wait_for_io(controller, RIGHT_SENSOR_IO)
  #move_ur_to_unhook_object()
  #move_conveyor_belt_to_the_left()
  #move_ur_to_unsuck_hook()
  #wait_for_io(controller, LEFT_SENSOR_IO)
  #move_abb_to_pick_object()
  #move_abb_to_drop_object()
  print("hook")

# -----------------------------------------
# TESTING
# -----------------------------------------

velocity(300)
# move to home
do with robot:
  move TCP_Sucker via p2p() to ur_home
  move TCP_Sucker via p2p() to ur_home :: (0, 0, -136)
and do with robot_abb1200:
  move TCP_ABB via p2p() to abb_home
  move TCP_ABB via p2p() to abb_home :: (0, 0, 100)

# abb_pose = read(robot_abb1200, "pose")
# print(abb_pose)

# -----------------------------------------
# MAIN
# -----------------------------------------

#abb_pose = read(robot_abb1200, "BASE/tool0")
#print(abb_pose)
#do with robot_abb1200:
#  move TCP_ABB via p2p() to abb_home
#  move TCP_ABB via p2p() to abb_home :: [0, 0, 100]
#  move TCP_ABB via p2p() to abb_home

i = 0
while True:
  print(i)
  button_red_not_pressed = True
  button_green_not_pressed = True

  while True:
    button_red_not_pressed = read(controller, RED_BUTTON_IO)
    button_green_not_pressed = read(controller, GREEN_BUTTON_IO)
    if button_red_not_pressed == False:
      break
    if button_green_not_pressed == False:
      break

  # reset_cell()
  if button_red_not_pressed == False:
    i = 0
    skill_suck(i)
  if button_green_not_pressed == False:
    skill_suck(i)

  i = i + 1
  if i == 9:
    i = 0