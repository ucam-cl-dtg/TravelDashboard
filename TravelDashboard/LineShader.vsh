//
//  LineShader.vsh
//
//  Copyright 2014 Ian Sheret
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

uniform mat4 u_tmLToC;
uniform mat3 u_tmNToC;

attribute vec4 a_posL;
attribute vec4 a_partnerPosL;
attribute float a_aaOffset;
attribute float a_aaSign;
attribute vec3 a_offsetN;
attribute lowp vec4 a_color;

varying lowp vec4 v_color;
varying mediump float v_posWrtLine;

void main()
{
    // Get the line endpoints in clip coordinates
    vec4 aC = u_tmLToC*a_posL;
    vec4 bC = u_tmLToC*a_partnerPosL;

    // Apply offsets
    vec3 offsetC = u_tmNToC*a_offsetN;
    aC.xy += offsetC.xy*aC.w;
    bC.xy += offsetC.xy*bC.w;
    
    // Store the basic vertex position before perturbation
    gl_Position = aC;
    
    // Get the expansion unit vectors, in points.
    vec2 pN = bC.xy - aC.xy;
    pN.x /= u_tmNToC[0][0];
    pN.y /= u_tmNToC[1][1];
    pN = normalize(pN);
    vec2 qN; qN.x = -pN.y; qN.y = pN.x;
    
    // Get the total offset vector, in points
    vec3 offsetN;
    offsetN.xy = - 0.15*pN + 0.9*qN*a_aaOffset;
    offsetN.z = 0.0;
    vec3 offsetC2 = u_tmNToC*offsetN;
    gl_Position.xy += offsetC2.xy*gl_Position.w;
    
    // Get the distance from the line
    v_posWrtLine = 1.8*a_aaSign;
    
    // Get the color
    v_color = a_color;
    
}