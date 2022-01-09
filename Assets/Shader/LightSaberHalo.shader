Shader "LightsaberHalo"
{
    Properties
    {
		_Thickness ("Thickness", Range (-1, 1)) = 0.05
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex ("Base (RGB) Trans. (Alpha)", 2D) = "white" { }
    }

    Category
    {
        ZWrite Off
        //Offset -1, -1
		Blend SrcAlpha One
		//Blend SrcAlpha OneMinusDstColor
        //Blend SrcAlpha OneMinusSrcAlpha
        Cull Off
        Lighting Off
        SubShader
        {
			Tags {"Queue" = "Transparent" }
            Pass
            {
                
				Program "" {
// Vertex combos: 1, instructions: 10 to 10
SubProgram "opengl " {
Keywords { }
Bind "vertex", ATTR0
Bind "color", ATTR1
Bind "normal", ATTR2
Local 1, ([_Thickness],0,0,0)
"!!ARBvp1.0
# 10 instructions
PARAM c[6] = { program.local[0..1],
		state.matrix.mvp };
TEMP R0;
MUL R0.xyz, vertex.attrib[2], c[1].x;
ADD R0.xyz, R0, vertex.attrib[0];
MAD R0.xyz, vertex.attrib[2], c[1].x, R0;
MOV R0.w, vertex.attrib[0];
MAD R0.xyz, vertex.attrib[2], c[1].x, R0;
DP4 result.position.w, R0, c[5];
DP4 result.position.z, R0, c[4];
DP4 result.position.y, R0, c[3];
DP4 result.position.x, R0, c[2];
MOV result.color, vertex.attrib[1];
END
# 10 instructions, 1 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex", Vertex
Bind "color", Color
Bind "normal", Normal
Local 4, ([_Thickness],0,0,0)
Matrix 0, [glstate_matrix_mvp]
"vs_1_1
dcl_position v0
dcl_color v1
dcl_normal v2
mul r0.xyz, v2, c4.x
add r0.xyz, r0, v0
mad r0.xyz, v2, c4.x, r0
mov r0.w, v0
mad r0.xyz, v2, c4.x, r0
dp4 oPos.w, r0, c3
dp4 oPos.z, r0, c2
dp4 oPos.y, r0, c1
dp4 oPos.x, r0, c0
mov oD0, v1
"
}

}
#LINE 52

                SetTexture [_MainTex]
                {
                    constantColor [_Color]
                    Combine texture * constant, texture * constant 
                } 
            }
        } 
    }
}