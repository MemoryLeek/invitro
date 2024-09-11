#!/usr/bin/env python3
import math

scale = 32
values = [f'${int(scale + math.sin((i / 256) * 2 * math.pi) * scale):02x}' for i in range(0, 256)]

print("sin_lut:", end="")
for start in range(0, len(values), 16):
    print("\n    .byte", " ,".join(values[start:start+16]), end=" ")
print()
