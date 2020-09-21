#pragma once

#include "Cpp/FastNoiseLite.h"

class FastNoiseLitePy : public FastNoiseLite {
public:
    FastNoiseLitePy() : FastNoiseLite() {}
    void SetNoiseTypePy(int t) { SetNoiseType(static_cast<NoiseType>(t)); }
    void SetRotationType3DPy(int t) { SetRotationType3D(static_cast<RotationType3D>(t)); }
    void SetFractalTypePy(int t) { SetFractalType(static_cast<FractalType>(t)); }
    void SetCellularDistanceFunctionPy(int t) { SetCellularDistanceFunction(static_cast<CellularDistanceFunction>(t)); }
    void SetCellularReturnTypePy(int t) { SetCellularReturnType(static_cast<CellularReturnType>(t)); }
    void SetDomainWarpTypePy(int t) { SetDomainWarpType(static_cast<DomainWarpType>(t)); }

};
