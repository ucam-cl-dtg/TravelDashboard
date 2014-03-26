//
//  TriangleShader.vsh
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
attribute vec3 a_offsetN;
attribute lowp vec4 a_color;
varying lowp vec4 v_color;

void main()
{
    gl_Position = u_tmLToC*a_posL;
    vec3 offsetC = u_tmNToC*a_offsetN;
    gl_Position.xy += offsetC.xy*gl_Position.w;
    v_color = a_color;
}
