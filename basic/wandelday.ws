canvas_left_bottom_corner = (32.6, -1032.9, 612.3)
canvas_right_bottom_corner = (-10.4, -685.6, 612.3)
canvas_middle_top_position = (-29.3, -896.6, 849.8)
pose_canvas_to_robot = estimate_plane(canvas_left_bottom_corner, canvas_right_bottom_corner, canvas_middle_top_position)
# pose_canvas_to_robot = (32.6, -1032.9, 612.3, 1.018, 1.152, 1.389)

pose_pentip_to_point = (0, 0, -12, 0, 0, 0) :: (0, 0, 0, 0, 0.6, 0) :: (0, 0, 0, 2.22, 2.22, 0)

home = read(robot, "pentip")
move via p2p() to home
font_height = 30
font_width = 20

movedef line_in_air(start >--> end):
    offset = (0, 0, -10, 0, 0, 0)
    move via line() to start :: offset
    move via line() to end :: offset
    move via line() to end


with velocity(100):
    move via line() to pose_canvas_to_robot :: (0, 0, 0, 0, 0, 0) ::  pose_pentip_to_point
    move via line() to pose_canvas_to_robot :: (0, 400, 0, 0, 0, 0) ::  pose_pentip_to_point
    move via line() to pose_canvas_to_robot :: (400, 400, 0, 0, 0, 0) ::  pose_pentip_to_point
    move via line() to pose_canvas_to_robot :: (400, 400, 0, 0, 0, 0) :: pose_pentip_to_point
    move via line() to pose_canvas_to_robot :: (400, 0, 0, 0, 0, 0) ::  pose_pentip_to_point


    pose_letter_to_canvas = (100, 100, 0, 0, 0, 0)
    pose_letter_to_robot = pose_canvas_to_robot :: pose_letter_to_canvas


    # letter D
    move via line() to pose_letter_to_robot :: (0, 0, 0, 0, 0, 0) ::  pose_pentip_to_point
    move via line() to pose_letter_to_robot :: (0, font_height, 0, 0, 0, 0) ::  pose_pentip_to_point
    middle = to_position(pose_letter_to_robot :: (font_width, font_height/2, 0, 0, 0, 0) ::  pose_pentip_to_point)
    move via arc(middle) to pose_letter_to_robot :: (0, 0, 0, 0, 0, 0) ::  pose_pentip_to_point
    move via line() to pose_letter_to_robot :: (0, 0, 0, 0, 0, 0) ::  pose_pentip_to_point



    pose_letter_to_canvas = (1.5 * font_width, 0, 0, 0, 0, 0) :: pose_letter_to_canvas
    pose_letter_to_robot = pose_canvas_to_robot :: pose_letter_to_canvas

    sync
    a = read(robot, "flange_renamed")

    # letter V
    move via line_in_air() to pose_letter_to_robot :: (0, font_height, 0, 0, 0, 0) :: pose_pentip_to_point
    move via line() to pose_letter_to_robot :: (font_width/2, 0, 0, 0, 0, 0) ::  pose_pentip_to_point
    move via line() to pose_letter_to_robot :: (font_width, font_height, 0, 0, 0, 0) ::  pose_pentip_to_point

    move via p2p() to home