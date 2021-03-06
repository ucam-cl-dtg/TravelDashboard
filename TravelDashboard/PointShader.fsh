//
//  PointShader.fsh
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

varying lowp vec4 v_color;

void main () {
    mediump vec2 rVec = (gl_PointCoord - vec2(0.5))*8.0;
    mediump float distFromEdge = max(length(rVec) - 3.0, 0.0);
    gl_FragColor    = v_color;
    gl_FragColor.a *= exp2(-2.0*distFromEdge*distFromEdge);
}