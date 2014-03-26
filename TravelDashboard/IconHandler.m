//
//  IconHandler.m
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

#import "IconHandler.h"

GLubyte black[] = {0, 0, 0, 255};

@implementation IconHandler

-(id) initWithTextureShader:(TextureShader *)textureShader{
    if (self = [super init]) {
        self.textureShader = textureShader;
    }
    return self;
}

-(void) addBusAtX:(float)x
                y:(float)y
          offsetX:(float)offsetX
          offsetY:(float)offsetY{
    [self.textureShader addIconWithBottomLeftX:98.0
                                   bottomLeftY:0.0
                                     rightVecX:30.0
                                     rightVecY:0.0
                                        upVecX:0.0
                                        upVecY:38.0
                                           atX:x
                                             y:y
                                       offsetX:-7.5 + offsetX
                                       offsetY:-9.5 + offsetY
                                       offsetT:0.0
                                 earliestStart:0.0
                                   latestStart:24.0
                                         color:black];

}

-(void) addTrainAtX:(float)x
                  y:(float)y
            offsetX:(float)offsetX
            offsetY:(float)offsetY{

    
    [self.textureShader addIconWithBottomLeftX:0.0
                                   bottomLeftY:24.0
                                     rightVecX:0.0
                                     rightVecY:-24.0
                                        upVecX:38.0
                                        upVecY:0.0
                                           atX:x
                                             y:y
                                       offsetX:-6.0 + offsetX
                                       offsetY:-9.5 + offsetY
                                       offsetT:0.0
                                 earliestStart:0.0
                                   latestStart:24.0
                                         color:black];
    


}

-(void) addCarAtX:(float)x
                y:(float)y
          offsetX:(float)offsetX
          offsetY:(float)offsetY{
    
    
    [self.textureShader addIconWithBottomLeftX:39.0
                                   bottomLeftY:0.0
                                     rightVecX:30.0
                                     rightVecY:0.0
                                        upVecX:0.0
                                        upVecY:28.0
                                           atX:x
                                             y:y
                                       offsetX:-7.5 + offsetX
                                       offsetY:-8.0 + offsetY
                                       offsetT:0.0
                                 earliestStart:0.0
                                   latestStart:24.0
                                         color:black];

    
    
    
}

-(void) addWalkAtX:(float)x
                 y:(float)y
           offsetX:(float)offsetX
           offsetY:(float)offsetY{

    [self.textureShader addIconWithBottomLeftX:70.0
                                   bottomLeftY:0.0
                                     rightVecX:20.0
                                     rightVecY:0.0
                                        upVecX:0.0
                                        upVecY:38.0
                                           atX:x
                                             y:y
                                       offsetX:-5.5 + offsetX
                                       offsetY:-9.5 + offsetY
                                       offsetT:0.0
                                 earliestStart:0.0
                                   latestStart:24.0
                                         color:black];
    
}

@end
