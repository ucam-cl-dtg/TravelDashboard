//
//  PointShader.vsh
//  Measure
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
uniform mediump float u_animationPhase;
uniform highp float u_startTime;
attribute vec4 a_startL;
attribute vec4 a_endL;
attribute vec3 a_startOffsetN;
attribute vec3 a_endOffsetN;
attribute mediump float a_startPhase;
attribute mediump float a_endPhase;
attribute mediump float a_phaseOffset;
attribute highp float a_earliestStart;
attribute highp float a_latestStart;
attribute lowp vec4 a_color;
varying lowp vec4 v_color;

void main() {
    gl_PointSize = 8.0;
    
    mediump float animationPhase = mod(u_animationPhase + a_phaseOffset , 1.0);
    if ((a_startPhase <= animationPhase) && (animationPhase < a_endPhase) && (a_earliestStart <= u_startTime) && (u_startTime < a_latestStart)) {
        highp vec4 p1 = u_tmLToC*a_startL;
        highp vec4 p2 = u_tmLToC*a_endL;
        vec3 startOffsetC = u_tmNToC*a_startOffsetN;
        vec3 endOffsetC = u_tmNToC*a_endOffsetN;
        p1.xy += startOffsetC.xy*p1.w;
        p2.xy += endOffsetC.xy*p2.w;
        gl_Position = (p1*(a_endPhase - animationPhase) + p2*(animationPhase - a_startPhase)) / (a_endPhase - a_startPhase);
    } else {
        gl_Position = vec4(-2.0, 0.0, 0.0, 1.0);
    }
    v_color = a_color;

}