//
//  TextureShader.h
//  RenderTest
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

#import "Shader.h"

@interface TextureShader : Shader

@property (assign, nonatomic) int numIdxs;
@property (assign, nonatomic) GLfloat *tmLToC;
@property (assign, nonatomic) GLfloat *tmNToC;
@property (assign, nonatomic) GLfloat *startTime;

- (void) addTriangleStrip:(GLfloat *)posL
                   offset:(GLfloat *)offsetN
                texCoords:(GLfloat *)texCoord
            earliestStart:(float)earliestStart
              latestStart:(float)latestStart
                    color:(GLubyte*)color
              numVertices:(int)numVertices;
- (void)setupGL;
- (void)tearDownGL;
- (void)drawGLWithFirstIdx:(int)firstIdx
                   numIdxs:(int)numIdxs;
- (void)drawGL;
-(void) addIconWithBottomLeftX:(GLfloat)blx
                   bottomLeftY:(GLfloat)bly
                     rightVecX:(GLfloat)rx
                     rightVecY:(GLfloat)ry
                        upVecX:(GLfloat)ux
                        upVecY:(GLfloat)uy
                           atX:(GLfloat)x
                             y:(GLfloat)y
                       offsetX:(GLfloat)offsetX
                       offsetY:(GLfloat)offsetY
                       offsetT:(GLfloat)offsetT
                 earliestStart:(float)earliestStart
                   latestStart:(float)latestStart
                         color:(GLubyte*)color;

@end
