[![Build Status](https://travis-ci.org/tizilogic/PyFastNoiseLite.svg?branch=master)](https://travis-ci.org/tizilogic/PyFastNoiseLite)

# Cython wrapper for the [FastNoise Lite](https://github.com/Auburn/FastNoise/) library

This wraps Auburns' great [FastNoise Lite](https://github.com/Auburn/FastNoise/)
library using Cython  for use in Python 3.6+

## Installation

This package is available on the [Python Package Index](https://pypi.org) both
as source and binary distribution for a variety of Python versions and
platforms using the following command:

```bash
pip install pyfastnoiselite  # On some systems, "pip" has to be replaced by "pip3"
```

> __Note__:
>
> This wrapper currently lacks the domain warping functionality and
> documentation. Both are planned to be added in the future.

## Usage

```py
from pyfastnoiselite.pyfastnoiselite import FastNoiseLite, NoiseType

# Initializing with seed
noise = FastNoiseLite(seed=1337)
# Set noise type (optional, defaults to OpenSimplex2)
noise.noise_type = NoiseType.NoiseType_OpenSimplex2S

# Get 2D noise
print(noise.get_noise(34, 22)) # 0.7130074501037598
print(noise.get_noise(100, 110)) # -0.614801287651062

# Get 3D noise
print(noise.get_noise(95, 100, 30)) # -0.45421651005744934


import numpy as np

Xs = [3, 57, 95]
Ys = [4, 13, 100]
Zs = [0, -4, 30]
coords = np.array([Xs, Ys, Zs], dtype=np.float32)
# Generate noise for each coordinate
print(noise.gen_from_coords(coords)) # [0.11303097 -0.5841235  -0.45224023]
```
