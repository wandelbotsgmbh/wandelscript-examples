flange = frame("flange")
tool = frame("tool")
other_tool = frame(to_string(3.0))  # see WOS-463, fanuc related bug
another_tool = frame(to_string(4))  # see WOS-463, fanuc related bug
move via p2p() to (0, 0, 0, 0, 0, 0)
move flange to (1, 2, 0)
sync
a = read(robot, "flange")
move tool to (10, 2, 0)
move to (1, 24, 0)
move to (1, 2, 0)
sync
b = read(robot, "flange")
c = read(robot, "tool")
