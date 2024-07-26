# TODO: needs to be fixed with https://wandelbots.atlassian.net/browse/WOS-1136
tcp1 = frame("tool100")
tcp2 = frame("TOOL 0")
do with robot1:
    move tcp1 via p2p() to (-200, -600, 250, 0, -pi, 0)
and do with robot2:
    move tcp2 via p2p() to (-200, -600, 200, 0, -pi, 0)
a = read(robot1, tcp1)
b = read(robot2, tcp2)
