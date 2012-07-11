#include "core.h"

#define MRT @shPropertyBool(mrt_output)

#ifdef SH_VERTEX_SHADER

    SH_BEGIN_PROGRAM
        shUniform(float4x4 wvp) @shAutoConstant(wvp, worldviewproj_matrix)
        shInput(float2, uv0)
        shOutput(float2, UV)
        shColourInput(float4)
        shOutput(float4, colourPassthrough)

    SH_START_PROGRAM
    {
        
	    shOutputPosition = shMatrixMult(wvp, shInputPosition);
	    UV = uv0;
    }

#else

    SH_BEGIN_PROGRAM
		shSampler2D(diffuseMap)
		shInput(float2, UV)
#if MRT
        shDeclareMrtOutput(1)
#endif
        shUniform(float4 materialDiffuse)                    @shAutoConstant(materialDiffuse, surface_diffuse_colour)
        shUniform(float4 materialEmissive)                   @shAutoConstant(materialEmissive, surface_emissive_colour)

    SH_START_PROGRAM
    {
        shOutputColour(0) = float4(1,1,1,materialDiffuse.a) * float4(materialEmissive.xyz, 1) * shSample(diffuseMap, UV);

#if MRT
        shOutputColour(1) = float4(1,1,1,1);
#endif
    }

#endif
