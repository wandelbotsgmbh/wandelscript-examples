# ### -----------------------------------------------------------
# ### Includes                          -------------------------

def set_motor(state, is_active):
    if is_active:
        set_io_map(get_aov_motor_ios(state, aov))

def set_compliance(state, is_active):
    if is_active:
        set_io_map(get_aov_compliance_ios(state, aov))

def align_approach(pose, align_to_origin, flip_axis, use_x_axis):
    if align_to_origin:
        return rotate_z_origin_direction(pose, flip_axis, use_x_axis)
    return rotate_z(pose, flip_axis, use_x_axis)

def move_via_collision_free_p2p(tool, joints):
    convex_hulls = [  ]
    move tool via collision_free_p2p(convex_hulls) to joints

def move_to_home_safely(flange_tcp_name, workspace_tcp_name, home, workspace_robot_mounting):
    # ### -----------------------------------------------------------
    # ### Definitions                       -------------------------
    pullout_mm = 100
    lift_mm = 100
    moving_velocity_slow = 20
    moving_velocity = 50


    # ### -----------------------------------------------------------
    # ### Path                              -------------------------
    flange = frame(check_tcp_name(flange_tcp_name))
    workspace_tcp = frame(check_tcp_name(workspace_tcp_name))
    workspace_tcp_pose = get_tcp_pose(robot, check_tcp_name(workspace_tcp_name))

    velocity(moving_velocity)
    current = solve_point_forward(robot, read(robot, "joints"), check_tcp_name(workspace_tcp_name))

    up_direction_pose = ~workspace_robot_mounting
    home_global = workspace_robot_mounting :: solve_point_forward(robot, home, check_tcp_name(flange_tcp_name))
    current_global = workspace_robot_mounting :: current
    if home_global[2] - current_global[2] >= lift_mm:
        pullout = current :: (0, 0, -pullout_mm, 0, 0, 0)
        lift = up_direction_pose :: (0, 0, lift_mm, 0, 0, 0) :: ~up_direction_pose :: pullout

        velocity(moving_velocity_slow)
        move workspace_tcp via p2p() to current
        move workspace_tcp via line() to pullout

        velocity(moving_velocity)
        move workspace_tcp via line() to lift
    move_via_collision_free_p2p(workspace_tcp, home)

def sand_surface(path, pressure, moving_velocity, sanding_velocity, is_hot_sanding, up_direction_pose, start_joints, tcp_offset, approach_align_to_origin, approach_flip_axis, approach_use_x_axis, lift_above_surface):
    # ### -----------------------------------------------------------
    # ### Definitions                       -------------------------
    def align_pose(pose):
        return align_approach(pose, approach_align_to_origin, approach_flip_axis, approach_use_x_axis)

    ABOVE_HIGH = lift_above_surface
    ABOVE_CLOSE = 10


    # ### -----------------------------------------------------------
    # ### Path                              -------------------------
    set_compliance(pressure, is_hot_sanding)
    velocity(moving_velocity)
    highest_polygon_pose = get_highest_point(path, up_direction_pose)
    move_via_collision_free_p2p(sanding_tool, start_joints)
    move sanding_tool via p2p() to align_pose(highest_polygon_pose :: (0, 0, -ABOVE_HIGH, 0, 0, 0) :: ~tcp_offset)
    move sanding_tool via line() to align_pose(highest_polygon_pose :: (0, 0, -ABOVE_CLOSE, 0, 0, 0) :: ~tcp_offset)
    move sanding_tool via line() to align_pose(path[0] :: (0, 0, -ABOVE_CLOSE, 0, 0, 0) :: ~tcp_offset)

    velocity(sanding_velocity)
    for i = 0..<len(path):
        if i == 1:
            set_motor(True, is_hot_sanding)
        move sanding_tool via line() to align_pose(path(i) :: ~tcp_offset)


    velocity(moving_velocity)
    move sanding_tool via line() to align_pose(path[-1] :: (0, 0, -ABOVE_CLOSE, 0, 0, 0) :: ~tcp_offset)
    set_motor(False, is_hot_sanding)
    move sanding_tool via line() to align_pose(highest_polygon_pose :: (0, 0, -ABOVE_CLOSE, 0, 0, 0) :: ~tcp_offset)
    move sanding_tool via line() to align_pose(highest_polygon_pose :: (0, 0, -ABOVE_HIGH, 0, 0, 0) :: ~tcp_offset)
    move_via_collision_free_p2p(sanding_tool, start_joints)

def sand_edge(path, pressure, moving_velocity, sanding_velocity, is_hot_sanding, sanding_tool, start_joints, up_direction_pose, tcp_offset, approach_align_to_origin, approach_flip_axis, approach_use_x_axis, lift_above_edge):
    # ### -----------------------------------------------------------
    # ### Definitions                       -------------------------
    def align_pose(pose):
        return align_approach(pose, approach_align_to_origin, approach_flip_axis, approach_use_x_axis)

    ABOVE_HIGH = lift_above_edge
    ABOVE_CLOSE = 10


    # ### -----------------------------------------------------------
    # ### Path                              -------------------------
    edge_no_approach = slice_array(path, 2, -2)
    highest_pose = get_highest_point(edge_no_approach, up_direction_pose)

    set_compliance(pressure, is_hot_sanding)
    velocity(moving_velocity)

    move_via_collision_free_p2p(sanding_tool, start_joints)
    move sanding_tool via p2p() to align_pose(highest_pose :: (0, 0, -ABOVE_HIGH, 0, 0, 0))
    move sanding_tool via line() to align_pose(highest_pose :: (0, 0, -ABOVE_CLOSE+1, 0, 0, 0))
    move sanding_tool via line() to align_pose(edge_no_approach[0] :: (0, 0, -ABOVE_CLOSE, 0, 0, 0) :: ~tcp_offset)

    set_motor(True, is_hot_sanding)
    velocity(sanding_velocity)

    for i = 0..<len(edge_no_approach):
        move sanding_tool via line() to align_pose(edge_no_approach[i] :: ~tcp_offset)

    set_motor(False, is_hot_sanding)
    velocity(moving_velocity)

    move sanding_tool via line() to align_pose(edge_no_approach[-1] :: (0, 0, -ABOVE_CLOSE, 0, 0, 0) :: ~tcp_offset)
    move sanding_tool via line() to align_pose(highest_pose :: (0, 0, -ABOVE_CLOSE-1, 0, 0, 0)) # The -1 here is to prevent a wbr bug https://wandelbots.atlassian.net/browse/AA-1405
    move sanding_tool via line() to align_pose(highest_pose :: (0, 0, -ABOVE_HIGH, 0, 0, 0))
    move_via_collision_free_p2p(sanding_tool, start_joints)

def sand_straight_edge(edge, target_radius, lane_number_range, lane_density_weight, level_distance, pressure, moving_velocity, sanding_velocity, is_hot_sanding, sanding_tool, start_joints, up_direction_pose, tcp_offset, approach_align_to_origin, approach_flip_axis, approach_use_x_axis, lift_above_edge):
    # ### -----------------------------------------------------------
    # ### Path                              -------------------------
    meander = generate_edge_meander(edge[0], edge[1], target_radius, lane_number_range, lane_density_weight, level_distance)
    sand_edge(meander, pressure, moving_velocity, sanding_velocity, is_hot_sanding, sanding_tool, start_joints, up_direction_pose, tcp_offset, approach_align_to_origin, approach_flip_axis, approach_use_x_axis, lift_above_edge)

def sand_curved_edge(edge, target_radius, lane_number_range, lane_density_weight, level_distance, pressure, moving_velocity, sanding_velocity, is_hot_sanding, sanding_tool, start_joints, up_direction_pose, tcp_offset, approach_align_to_origin, approach_flip_axis, approach_use_x_axis, lift_above_edge):
    # ### -----------------------------------------------------------
    # ### Path                              -------------------------
    meander = generate_curved_edge_meander(edge[0], edge[1], target_radius, lane_number_range, lane_density_weight, level_distance)
    sand_edge(meander, pressure, moving_velocity, sanding_velocity, is_hot_sanding, sanding_tool, start_joints, up_direction_pose, tcp_offset, approach_align_to_origin, approach_flip_axis, approach_use_x_axis, lift_above_edge)

def sand_planar_surface(poly, distance, margin, pressure, moving_velocity, sanding_velocity, is_hot_sanding, up_direction_pose, start_joints, tcp_offset, approach_align_to_origin, approach_flip_axis, approach_use_x_axis, lift_above_surface):
    # ### -----------------------------------------------------------
    # ### Path                              -------------------------
    meander = generate_plane_meander(poly, distance, margin)
    sand_surface(meander, pressure, moving_velocity, sanding_velocity, is_hot_sanding, up_direction_pose, start_joints, tcp_offset, approach_align_to_origin, approach_flip_axis, approach_use_x_axis, lift_above_surface)

def sand_curved_surface(pcd, distance, margin, pressure, moving_velocity, sanding_velocity, is_hot_sanding, up_direction_pose, start_joints, tcp_offset, approach_align_to_origin, approach_flip_axis, approach_use_x_axis, lift_above_surface):
    # ### -----------------------------------------------------------
    # ### Path                              -------------------------
    meander = generate_curved_surface_meander(pcd, distance, margin)
    sand_surface(meander, pressure, moving_velocity, sanding_velocity, is_hot_sanding, up_direction_pose, start_joints, tcp_offset, approach_align_to_origin, approach_flip_axis, approach_use_x_axis, lift_above_surface)

# ### -----------------------------------------------------------
# ### Input parameters                  -------------------------

# General
polygons = read(arguments, "polygons")
edges = read(arguments, "edges")
curved_edges = read(arguments, "curved_edges")
curved_surfaces = read(arguments, "curved_surfaces")
hot_sanding_on = True
safety_offset_z = 0 # (mm) positive value goes away from the workpiece
moving_velocity = 1000
workspace_robot_mounting = (0,0,0,0,0,0)
workspace_tcp = "TOOL 5"
home = [-0.08263993263244629,0.17805440723896027,0.4916095733642578,0.014160103164613247,-2.345040798187256,1.635414719581604]
use_approach_optimization = False
approach_align_to_origin = False
approach_flip_axis = False
approach_use_x_axis = False

# ### -----------------------------------------------------------
# ### Definitions                       -------------------------
def align_pose(pose):
    return align_approach(pose, approach_align_to_origin, approach_flip_axis, approach_use_x_axis)

# Safety features
MOVING_OFFSET_HIGHEST = 150

# Path optimization features
use_start_joint_search = False

max_allowed_joint_deviations = [1, 1, 3, 3, 6, 6]
apply_operation_sync = use_start_joint_search

# ### -----------------------------------------------------------
# ### Configuration settings (developer can change) -------------
sanding_tool = frame(check_tcp_name(workspace_tcp))
tcp_pose = get_tcp_pose(robot, check_tcp_name(workspace_tcp))
tcp_correction_offset = (0, 0, 0, 0, 0, 0)  # Normally set to zero (This gets applied to the points before the actual robot TCP is used)

# Construct the via pose:
up_direction_pose = ~workspace_robot_mounting
highest_pose = get_highest_point(polygons + edges + curved_surfaces + curved_edges, up_direction_pose)
above_workpiece = (highest_pose[0], highest_pose[1], highest_pose[2], 0, 0, 0) :: up_direction_pose :: (0, 0, MOVING_OFFSET_HIGHEST, 0, 0, 0) :: (0, 0, 0, pi, 0, 0)
above_workpiece = align_pose(above_workpiece)

# ### -----------------------------------------------------------
# ### Preparation (don't change) --------------------------------
safety_offset = (0, 0, safety_offset_z, 0, 0, 0)

if hot_sanding_on:
    tcp_offset = tcp_correction_offset
else:
    # This variable is kind of a 'local/relative' tcp, in relation to the actual used TCP of the robot
    tcp_offset = tcp_correction_offset :: safety_offset

# ### -----------------------------------------------------------
# ### Skill starts              ---------------------------------
above_workpiece_joints = solve_point_inverse(robot, above_workpiece :: ~tcp_offset, check_tcp_name(workspace_tcp), home)

blending(10)
velocity(moving_velocity)
move_via_collision_free_p2p(sanding_tool, home)
move_via_collision_free_p2p(sanding_tool, above_workpiece_joints)


sand_straight_edge(edges[0], 4, [5,17], 0.2, 100, 0.5, moving_velocity, 100, hot_sanding_on, sanding_tool, above_workpiece_joints, up_direction_pose, tcp_offset, False, False, False, 100)
if apply_operation_sync:
    sync
sand_straight_edge(edges[1], 4, [5,17], 0.2, 100, 0.5, moving_velocity, 100, hot_sanding_on, sanding_tool, above_workpiece_joints, up_direction_pose, tcp_offset, False, False, False, 100)
if apply_operation_sync:
    sync


sand_planar_surface(polygons[0], 80, 0, 2, moving_velocity, 100, hot_sanding_on, up_direction_pose, above_workpiece_joints, tcp_offset, False, False, False, 100)
if apply_operation_sync:
    sync
sand_planar_surface(polygons[1], 80, 0, 2, moving_velocity, 100, hot_sanding_on, up_direction_pose, above_workpiece_joints, tcp_offset, False, False, False, 100)
if apply_operation_sync:
    sync

# ### -----------------------------------------------------------
move_via_collision_free_p2p(sanding_tool, home)

# Motions are not resolved at this point
motion = motion_trajectory_to_json_string(robot)
