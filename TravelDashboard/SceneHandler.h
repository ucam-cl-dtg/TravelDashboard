//
//  SceneHandler.h
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

#import <Foundation/Foundation.h>
#import "TriangleShader.h"
#import "LineShader.h"
#import "PointShader.h"
#import "IconHandler.h"
#import "TextHandler.h"
@interface SceneHandler : NSObject
@property (assign, nonatomic) GLfloat *tmTToC;
@property (assign, nonatomic) GLfloat *tmFToC;
@property (assign, nonatomic) GLfloat *tmNToC;
@property (assign, nonatomic) GLfloat *animationPhase;
@property (assign, nonatomic) GLfloat *startTime;
@property (nonatomic, strong) NSArray *journeySpec;
@property (nonatomic, strong) NSArray *journeyInfo;
@property (nonatomic, assign) BOOL mcEnabled;

-(id)initWithTriangleShader:(TriangleShader*)triangleShader
                 lineShader:(LineShader*)lineShader
                pointShader:(PointShader*)pointShader
                iconHandler:(IconHandler*)iconHandler
                textHandler:(TextHandler*)textHandler;
-(void)makeSceneWithWidth:(float)width;
-(void)draw;
@end
