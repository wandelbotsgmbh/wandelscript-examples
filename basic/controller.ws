write(controller, "digital_out[2]", True)
a_1 = read(controller, "digital_out[2]")
write(controller, "digital_out[2]", False)
a_2 = read(controller, "digital_out[2]")

write(controller_b, "10017#0008", True)
b_1 = read(controller_b, "10017#0008")
write(controller_b, "10017#0008", False)
b_2 = read(controller_b, "10017#0008")
