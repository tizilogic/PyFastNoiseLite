
# distutils: language = c++
"""
Provides Cython header for "ext/FastNoise/Cpp/FastNoiseLite.h".
"""

__author__ = 'Tiziano Bettio'
__license__ = 'MIT'
__version__ = '0.0.4'
__copyright__ = """Copyright (c) 2021 Tiziano Bettio
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


cdef extern from 'Cpp/FastNoiseLite.h':
    cdef enum NoiseType "FastNoiseLite::NoiseType":
        NoiseType_OpenSimplex2,
        NoiseType_OpenSimplex2S,
        NoiseType_Cellular,
        NoiseType_Perlin,
        NoiseType_ValueCubic,
        NoiseType_Value

    cdef enum RotationType3D "FastNoiseLite::RotationType3D":
        RotationType3D_None,
        RotationType3D_ImproveXYPlanes,
        RotationType3D_ImproveXZPlanes

    cdef enum FractalType "FastNoiseLite::FractalType":
        FractalType_None,
        FractalType_FBm,
        FractalType_Ridged,
        FractalType_PingPong,
        FractalType_DomainWarpProgressive,
        FractalType_DomainWarpIndependent

    cdef enum CellularDistanceFunction "FastNoiseLite::CellularDistanceFunction":
        CellularDistanceFunction_Euclidean,
        CellularDistanceFunction_EuclideanSq,
        CellularDistanceFunction_Manhattan,
        CellularDistanceFunction_Hybrid

    cdef enum CellularReturnType "FastNoiseLite::CellularReturnType":
        CellularReturnType_CellValue,
        CellularReturnType_Distance,
        CellularReturnType_Distance2,
        CellularReturnType_Distance2Add,
        CellularReturnType_Distance2Sub,
        CellularReturnType_Distance2Mul,
        CellularReturnType_Distance2Div

    cdef enum DomainWarpType "FastNoiseLite::DomainWarpType":
        DomainWarpType_OpenSimplex2,
        DomainWarpType_OpenSimplex2Reduced,
        DomainWarpType_BasicGrid

    cdef cppclass FastNoiseLite:
        FastNoiseLite() except +
        void SetSeed(int)
        void SetFrequency(float)
        void SetNoiseType(NoiseType)
        void SetRotationType3D(RotationType3D)
        void SetFractalType(FractalType)
        void SetFractalOctaves(int)
        void SetFractalLacunarity(float)
        void SetFractalGain(float)
        void SetFractalWeightedStrength(float)
        void SetFractalPingPongStrength(float)
        void SetCellularDistanceFunction(CellularDistanceFunction)
        void SetCellularReturnType(CellularReturnType)
        void SetCellularJitter(float)
        void SetDomainWarpType(DomainWarpType)
        void SetDomainWarpAmp(float)
        float GetNoise(float, float)
        float GetNoise(float, float, float)
        void DomainWarp(float, float)
        void DomainWarp(float, float, float)


cdef extern from 'FastNoiseLitePy.h':
    cdef cppclass FastNoiseLitePy:        
        FastNoiseLitePy() except +
        void SetSeed(int)
        void SetFrequency(float)
        void SetNoiseTypePy(int)
        void SetRotationType3DPy(int)
        void SetFractalTypePy(int)
        void SetFractalOctaves(int)
        void SetFractalLacunarity(float)
        void SetFractalGain(float)
        void SetFractalWeightedStrength(float)
        void SetFractalPingPongStrength(float)
        void SetCellularDistanceFunctionPy(int)
        void SetCellularReturnTypePy(int)
        void SetCellularJitter(float)
        void SetDomainWarpTypePy(int)
        void SetDomainWarpAmp(float)
        float GetNoise(float, float)
        float GetNoise(float, float, float)
        void DomainWarp(float, float)
        void DomainWarp(float, float, float)
