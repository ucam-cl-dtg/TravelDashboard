//
//  IconHandler.h
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
#import "TextureShader.h"

@interface IconHandler : NSObject
@property (strong, nonatomic) TextureShader *textureShader;
-(id) initWithTextureShader:(TextureShader *)textureShader;
-(void) addBusAtX:(float)x
                y:(float)y
          offsetX:(float)offsetX
          offsetY:(float)offsetY;
-(void) addTrainAtX:(float)x
                  y:(float)y
            offsetX:(float)offsetX
            offsetY:(float)offsetY;
-(void) addWalkAtX:(float)x
                 y:(float)y
           offsetX:(float)offsetX
           offsetY:(float)offsetY;
-(void) addCarAtX:(float)x
                y:(float)y
          offsetX:(float)offsetX
          offsetY:(float)offsetY;
@end
