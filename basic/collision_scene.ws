sphere_pose_default = get_collider_pose("sphere_default")

sphere_pose_set = assoc(sphere_pose_default, 2, 900)
set_collider_pose("sphere_default", sphere_pose_set)
sphere_pose_moved = get_collider_pose("sphere_default")

box_pose = (1000, 0, 0, 0, 0, 0)
add_static_box(10, 20, 30, box_pose, "added_box")
added_box_pose = get_collider_pose("added_box")

vertices = [
    (0, 0, 1),
    (1, 0, 1),
    (0, 1, 0),
    (0, 1, 1)
]
add_static_convex_hull(vertices, (0, 0, 1200, 0, 0, 0), "added_convex_hull")
added_convex_hull_pose = get_collider_pose("added_convex_hull")

add_static_collider_from_json('{"shape":{"type":"sphere", "radius":10}, "pose":{"position":[0, 1100, 0], "orientation":[0, 0, 0]}}', "added_sphere")
added_sphere_pose = get_collider_pose("added_sphere")

# hard to assert, but this also works:
# add_static_box(10, 20, 80, box_pose, "added_box_to_remove")
# remove_collider("added_box_to_remove")