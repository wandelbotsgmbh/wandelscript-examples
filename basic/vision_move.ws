[flange | tool] = (0, 0, 1, 0, 0, 0)
[robot_ | object] = (1, 0, 0, 0, 0, 0)
move [object | tool] via p2p() to (10, 20, 30, 0, 0, 0)
b = [robot_ | flange]
move [robot_ | flange] via p2p() to (0, 0, 10, 0, 0, 0) :: [robot_ | flange]
c = [robot_ | flange]