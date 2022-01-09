Shader "Glass"
{
    Properties
    {
		_ycoor ("XTex", Range (-20, 20)) = 20
		_xcoor ("YTex", Range (-20, 20)) = 10
        _Color ("Main Color", Color) = (1,1,1,1)
        _MainTex ("Base (RGB) Trans. (Alpha)", 2D) = "white" { }
    }

    Category
    {
        ZWrite Off
		Blend SrcAlpha One
        Cull Off
        Lighting Off
        SubShader
        {
			Tags {"Queue" = "Transparent" }
            Pass
            {
                
				Program "" {
// Vertex combos: 1, instructions: 16 to 16
SubProgram "opengl " {
Keywords { }
Bind "vertex", ATTR0
Bind "color", ATTR1
Bind "texcoord", ATTR2
Local 1, ([_ycoor],0,0,0)
Local 2, ([_xcoor],0,0,0)
"!!ARBvp1.0
# 16 instructions
PARAM c[7] = { program.local[0..2],
		state.matrix.mvp };
TEMP R0;
TEMP R1;
DP4 R1.x, vertex.attrib[0], c[4];
DP4 R0.x, vertex.attrib[0], c[3];
DP4 R0.w, vertex.attrib[0], c[6];
DP4 R0.z, vertex.attrib[0], c[5];
MOV R0.y, R1.x;
MOV result.position, R0;
RCP R0.y, c[2].x;
MUL R0.z, R0.x, R0.y;
MUL R0.w, vertex.attrib[0].y, R0.y;
MUL R0.z, R1.x, R0;
MAD R0.x, R0, R0.y, R0.w;
MUL R0.z, R0, R0.y;
RCP R0.y, c[1].x;
MOV result.color, vertex.attrib[1];
MAD result.texcoord[0].x, R0.y, R0, vertex.attrib[2];
MAD result.texcoord[0].y, R0.z, R0, vertex.attrib[2];
END
# 16 instructions, 2 R-regs
"
}

SubProgram "d3d9 " {
Keywords { }
Bind "vertex", Vertex
Bind "color", Color
Bind "texcoord", TexCoord0
Local 4, ([_ycoor],0,0,0)
Local 5, ([_xcoor],0,0,0)
Matrix 0, [glstate_matrix_mvp]
"vs_1_1
dcl_position v0
dcl_color v1
dcl_texcoord0 v2
dp4 r1.x, v0, c1
dp4 r0.x, v0, c0
dp4 r0.w, v0, c3
dp4 r0.z, v0, c2
mov r0.y, r1.x
mov oPos, r0
rcp r0.y, c5.x
mul r0.z, r0.x, r0.y
mul r0.w, v0.y, r0.y
mul r0.z, r1.x, r0
mad r0.x, r0, r0.y, r0.w
mul r0.z, r0, r0.y
rcp r0.y, c4.x
mov oD0, v1
mad oT0.x, r0.y, r0, v2
mad oT0.y, r0.z, r0, v2
"
}

}
#LINE 54

                SetTexture [_MainTex]
                {
                    constantColor [_Color]
                    Combine texture * constant, texture * constant 
                } 

            }
        } 
    }
}