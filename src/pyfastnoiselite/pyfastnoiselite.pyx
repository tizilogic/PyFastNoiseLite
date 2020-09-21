# distutils: language = c++

"""
Provides the wrapped FastNoiseLite C++ class for use in Python.
"""

from enum import Enum

import numpy as np

from cython.operator cimport dereference as deref
from libcpp.memory cimport unique_ptr

from .cppfastnoiselite cimport FastNoiseLitePy as _FNL
# from .cppfastnoiselite cimport NoiseType as _NoiseType
# from .cppfastnoiselite cimport RotationType3D as _RotationType3D
# from .cppfastnoiselite cimport FractalType as _FractalType
# from .cppfastnoiselite cimport CellularDistanceFunction as _CellularDistanceFunction
# from .cppfastnoiselite cimport CellularReturnType as _CellularReturnType
# from .cppfastnoiselite cimport DomainWarpType as _DomainWarpType

__author__ = 'Tiziano Bettio'
__license__ = 'MIT'
__version__ = '0.0.1'
__copyright__ = """Copyright (c) 2020 Tiziano Bettio
Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE."""


class NoiseType(Enum):
    """NoiseType enum"""
    NoiseType_OpenSimplex2 = 0
    NoiseType_OpenSimplex2S = 1
    NoiseType_Cellular = 2
    NoiseType_Perlin = 3
    NoiseType_ValueCubic = 4
    NoiseType_Value = 5


class RotationType3D(Enum):
    """RotationType3D enum"""
    RotationType3D_None = 0
    RotationType3D_ImproveXYPlanes = 1
    RotationType3D_ImproveXZPlanes = 2


class FractalType(Enum):
    """FractalType enum"""
    FractalType_None = 0
    FractalType_FBm = 1
    FractalType_Ridged = 2
    FractalType_PingPong = 3
    FractalType_DomainWarpProgressive  = 4
    FractalType_DomainWarpIndependent = 5


class CellularDistanceFunction(Enum):
    """CellularDistanceFunction enum"""
    CellularDistanceFunction_Euclidean = 0
    CellularDistanceFunction_EuclideanSq = 1
    CellularDistanceFunction_Manhattan = 2
    CellularDistanceFunction_Hybrid = 3


class CellularReturnType(Enum):
    """CellularReturnType enum"""
    CellularReturnType_CellValue = 0
    CellularReturnType_Distance = 1
    CellularReturnType_Distance2 = 2
    CellularReturnType_Distance2Add = 3
    CellularReturnType_Distance2Sub = 4
    CellularReturnType_Distance2Mul = 5
    CellularReturnType_Distance2Div = 6


class DomainWarpType(Enum):
    """DomainWarpType enum"""
    DomainWarpType_OpenSimplex2 = 0
    DomainWarpType_OpenSimplex2Reduced = 1
    DomainWarpType_BasicGrid = 2


cdef class FastNoiseLite:
    cdef unique_ptr[_FNL] thisptr
    cdef int _seed
    cdef int _fractal_octaves
    cdef float _frequency
    cdef float _fractal_lacunarity
    cdef float _fractal_gain
    cdef float _fractal_weighted_strength
    cdef float _fractal_ping_pong_strength
    cdef float _domain_warp_amp
    cdef int _noise_type
    cdef int _rotation_type_3d
    cdef int _fractal_type
    cdef int _cellular_distance_function
    cdef int _cellular_return_type
    cdef float _cellular_jitter_modifier
    cdef int _domain_warp_type

    def __cinit__(self, seed=1337):
        self.thisptr.reset(new _FNL())
        self._set_seed(seed)

        # Init default values as present in FastNoiseLite.h
        self._frequency = 0.01
        self._noise_type = NoiseType.NoiseType_OpenSimplex2.value
        self._rotation_type_3d = RotationType3D.RotationType3D_None.value
        self._fractal_type = FractalType.FractalType_None.value
        self._fractal_octaves = 3
        self._fractal_lacunarity = 2.0
        self._fractal_gain = 0.5
        self._fractal_weighted_strength = 0.0
        self._fractal_ping_pong_strength = 2.0
        self._cellular_distance_function = CellularDistanceFunction.CellularDistanceFunction_EuclideanSq.value
        self._cellular_return_type = CellularReturnType.CellularReturnType_Distance.value
        self._cellular_jitter_modifier = 1.0
        self._domain_warp_type = DomainWarpType.DomainWarpType_OpenSimplex2.value
        self._domain_warp_amp = 1.0

    @property
    def seed(self):
        return self._seed

    @seed.setter
    def seed(self, seed):
        self._set_seed(seed)

    cdef void _set_seed(self, int seed):
        self._seed = seed
        deref(self.thisptr).SetSeed(seed)

    @property
    def frequency(self):
        return self._frequency

    @frequency.setter
    def frequency(self, frequency):
        self._set_freq(frequency)

    cdef void _set_freq(self, float f):
        self._frequency = f
        deref(self.thisptr).SetFrequency(f)

    @property
    def noise_type(self):
        return NoiseType(self._noise_type)

    @noise_type.setter
    def noise_type(self, noise_type):
        self._set_noise_type(noise_type.value)

    cdef void _set_noise_type(self, int noise_type):
        self._noise_type = noise_type
        deref(self.thisptr).SetNoiseTypePy(noise_type)

    @property
    def rotation_type_3d(self):
        return RotationType3D(self._rotation_type_3d)

    @rotation_type_3d.setter
    def rotation_type_3d(self, rotation_type_3d):
        self._set_rotation_type_3d(rotation_type_3d.value)

    cdef void _set_rotation_type_3d(self, int rotation_type_3d):
        self._rotation_type_3d = rotation_type_3d
        deref(self.thisptr).SetRotationType3DPy(rotation_type_3d)

    @property
    def fractal_type(self):
        return FractalType(self._fractal_type)

    @fractal_type.setter
    def fractal_type(self, fractal_type):
        self._set_fractal_type(fractal_type.value)

    cdef void _set_fractal_type(self, int fractal_type):
        self._fractal_type = fractal_type
        deref(self.thisptr).SetFractalTypePy(fractal_type)

    @property
    def fractal_octaves(self):
        return self._fractal_octaves

    @fractal_octaves.setter
    def fractal_octaves(self, fractal_octaves):
        self._set_fractal_octaves(fractal_octaves)

    cdef void _set_fractal_octaves(self, int octaves):
        self._fractal_octaves = octaves
        deref(self.thisptr).SetFractalOctaves(octaves)

    @property
    def fractal_lacunarity(self):
        return self._fractal_lacunarity

    @fractal_lacunarity.setter
    def fractal_lacunarity(self, lacunarity):
        self._set_fractal_lacunarity(lacunarity)

    cdef void _set_fractal_lacunarity(self, float lacunarity):
        self._fractal_lacunarity = lacunarity
        deref(self.thisptr).SetFractalLacunarity(lacunarity)

    @property
    def fractal_gain(self):
        return self._fractal_gain

    @fractal_gain.setter
    def fractal_gain(self, gain):
        self._set_fractal_gain(gain)

    cdef void _set_fractal_gain(self, float gain):
        self._fractal_gain = gain
        deref(self.thisptr).SetFractalGain(gain)

    @property
    def fractal_weighted_strength(self):
        return self._fractal_weighted_strength

    @fractal_weighted_strength.setter
    def fractal_weighted_strength(self, strength):
        self._set_fractal_weighted_strength(strength)

    cdef void _set_fractal_weighted_strength(self, float strength):
        self._fractal_weighted_strength = strength
        deref(self.thisptr).SetFractalWeightedStrength(strength)

    @property
    def fractal_ping_pong_strength(self):
        return self._fractal_ping_pong_strength

    @fractal_ping_pong_strength.setter
    def fractal_ping_pong_strength(self, strength):
        self._set_fractal_ping_pong_strength(strength)

    cdef void _set_fractal_ping_pong_strength(self, float strength):
        self._fractal_ping_pong_strength = strength
        deref(self.thisptr).SetFractalPingPongStrength(strength)

    @property
    def cellular_distance_function(self):
        return CellularDistanceFunction(self._cellular_distance_function)
    
    @cellular_distance_function.setter
    def cellular_distance_function(self, func):
        self._set_cellular_distance_function(func.value)

    cdef void _set_cellular_distance_function(self, int func):
        self._cellular_distance_function = func
        deref(self.thisptr).SetCellularDistanceFunctionPy(func)

    @property 
    def cellular_return_type(self):
        return CellularReturnType(self._cellular_return_type)

    @cellular_return_type.setter
    def cellular_return_type(self, return_type):
        self._set_cellular_return_type(return_type.value)

    cdef void _set_cellular_return_type(self, int return_type):
        self._cellular_return_type = return_type
        deref(self.thisptr).SetCellularReturnTypePy(return_type)

    @property
    def cellular_jitter(self):
        return self._cellular_jitter_modifier

    @cellular_jitter.setter
    def cellular_jitter(self, jitter):
        self._set_cellular_jitter(jitter)

    cdef void _set_cellular_jitter(self, float jitter):
        self._cellular_jitter_modifier = jitter
        deref(self.thisptr).SetCellularJitter(jitter)

    @property
    def domain_warp_type(self):
        return DomainWarpType(self._domain_warp_type)

    @domain_warp_type.setter
    def domain_warp_type(self, warp_type):
        self._set_domain_warp_type(warp_type.value)

    cdef void _set_domain_warp_type(self, int warp_type):
        self._domain_warp_type = warp_type
        deref(self.thisptr).SetDomainWarpTypePy(warp_type)

    @property
    def domain_warp_amp(self):
        return self._domain_warp_amp

    @domain_warp_amp.setter
    def domain_warp_amp(self, amp):
        self._set_domain_warp_amp(amp)

    cdef void _set_domain_warp_amp(self, float amp):
        self._domain_warp_amp = amp
        deref(self.thisptr).SetDomainWarpAmp(amp)

    def get_noise(self, x, y, z=None):
        if z is None:
            return self._get_noise_2d(x, y)
        return self._get_noise_3d(x, y, z)

    cdef float _get_noise_2d(self, float x, float y):
        return deref(self.thisptr).GetNoise(x, y)

    cdef float _get_noise_3d(self, float x, float y, float z):
        return deref(self.thisptr).GetNoise(x, y, z)

    # TODO: Find a way to implement DomainWarp functions
    #    void DomainWarp(float, float)
    #    void DomainWarp(float, float, float)

    def gen_from_coords(self, float[:, :] coords):
        return self._gen_from_coords(coords)

    cdef _gen_from_coords(self, float[:, :] coords):
        cdef Py_ssize_t num_components = coords.shape[0]
        cdef Py_ssize_t num_coords = coords.shape[1]

        assert num_components in (2, 3)

        result = np.zeros((num_coords, ), dtype=np.float32)
        cdef float[:] result_view = result

        cdef Py_ssize_t c
        if num_components == 2:
            for c in range(num_coords):
                result_view[c] = deref(self.thisptr).GetNoise(coords[0, c], coords[1, c])
        else:
            for c in range(num_coords):
                result_view[c] = deref(self.thisptr).GetNoise(coords[0, c], coords[1, c], coords[2, c])
        return result
