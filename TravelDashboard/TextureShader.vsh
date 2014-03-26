//
//  TextureShader.vsh
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
uniform highp float u_startTime;
attribute vec4 a_posL;
attribute vec3 a_offsetN;
attribute vec2 a_texCoord;
attribute highp float a_earliestStart;
attribute highp float a_latestStart;
attribute lowp vec4 a_color;
varying vec2 v_texCoord;
varying lowp vec4 v_color;

void main()
{
    if ((a_earliestStart <= u_startTime) && (u_startTime < a_latestStart)) {
        gl_Position = u_tmLToC*a_posL;
        vec3 offsetC = u_tmNToC*a_offsetN;
        gl_Position.xy += offsetC.xy*gl_Position.w;
    } else {
        gl_Position = vec4(-2.0, 0.0, 0.0, 1.0);
    }
    v_texCoord = a_texCoord;
    v_color = a_color;
}


