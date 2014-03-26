//
//  TextHandler.m
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

#import "TextHandler.h"

#define TRACKING 0.5
#define SPACING 1.5

int numTableX0[] = {0,13,21,34,47,60,72,84,97,109,122};
int numTableX1[] = {13,21,34,47,60,72,84,97,109,122,127};
int numTableY0[] = {0,0,0,0,0,0,0,0,0,0,0};
int numTableY1[] = {20,20,20,20,20,20,20,20,20,20,20};

int letterTableX0[] = {
    0,18,33,50,66,79,92,108,123,
    0,11,27,40,59,74,91,106,
    0,15,30,45,60,75,98,
    0,16};
int letterTableX1[] = {
    18,33,50,66,79,92,108,123,127,
    11,27,40,59,74,91,106,124,
    15,30,45,60,75,98,114,
    16,31};
int letterTableY0[] = {
    20,20,20,20,20,20,20,20,20,
    40,40,40,40,40,40,40,40,
    60,60,60,60,60,60,60,
    80,80};
int letterTableY1[] = {
    40,40,40,40,40,40,40,40,40,
    60,60,60,60,60,60,60,60,
    80,80,80,80,80,80,80,
    100,100};



@interface TextHandler()
-(BOOL) getCoords:(int*)coords
     forCharacter:(char)character;
-(void) addText:(NSString *)text
            atX:(float)x
              y:(float)y
        offsetX:(float)offsetX
        offsetY:(float)offsetY
  earliestStart:(float)earliestStart
    latestStart:(float)latestStart
          color:(GLubyte*)color;
-(float) layoutText:(NSString *)text
                atX:(float)x
                  y:(float)y
            offsetX:(float)offsetX
            offsetY:(float)offsetY
      earliestStart:(float)earliestStart
        latestStart:(float)latestStart
              color:(GLubyte*)color
         enableDraw:(BOOL)enableDraw;
@end

@implementation TextHandler

-(id) initWithTextureShader:(TextureShader *)textureShader{
    if (self = [super init]) {
        self.textureShader = textureShader;
    }
    return self;
}

-(void) addText:(NSString *)text
            atX:(float)x
              y:(float)y
        offsetX:(float)offsetX
        offsetY:(float)offsetY
  earliestStart:(float)earliestStart
    latestStart:(float)latestStart
          color:(GLubyte *)color{
    [self layoutText:text
                 atX:x
                   y:y
             offsetX:offsetX
             offsetY:offsetY
     earliestStart:earliestStart
         latestStart:latestStart
               color:color
          enableDraw:YES];
    
}

-(float) layoutText:(NSString *)text
               atX:(float)x
                 y:(float)y
           offsetX:(float)offsetX
           offsetY:(float)offsetY
      earliestStart:(float)earliestStart
        latestStart:(float)latestStart
              color:(GLubyte*)color
        enableDraw:(BOOL)enableDraw{
    
    
    // Convert the string into chars
    int numChars = (int) text.length;
    const char *string = [text UTF8String];
    
    // For each letter
    GLfloat cumulativeOffset = 0;
    int coords[4];
    for (int i=0; i<numChars; i++) {
        
        // Add charcter
        if ([self getCoords:coords forCharacter:string[i]]){
            if (enableDraw) {
                [self.textureShader addIconWithBottomLeftX:coords[0]
                                               bottomLeftY:128.0 - coords[3]
                                                 rightVecX:coords[2] - coords[0]
                                                 rightVecY:0.0
                                                    upVecX:0.0
                                                    upVecY:coords[3] - coords[1]
                                                       atX:x
                                                         y:y
                                                   offsetX:cumulativeOffset + offsetX
                                                   offsetY:offsetY
                                                   offsetT:0.0
                                             earliestStart:earliestStart
                                               latestStart:latestStart
                                                     color:color];
            }
            cumulativeOffset += (coords[2] - coords[0])/2.0;
        }
        
        // Add spacing
        cumulativeOffset += TRACKING;
        if (string[i]==32) {
            cumulativeOffset += SPACING;
        }
    }
    
    // Remove the final spacing
    cumulativeOffset -=TRACKING;
    if (string[numChars-1]==32) {
        cumulativeOffset -= SPACING;
    }
    return cumulativeOffset;
}

-(void) addText:(NSString *)text withBottomLeftAtX:(float)x y:(float)y
  earliestStart:(float)earliestStart
    latestStart:(float)latestStart
          color:(GLubyte*)color{
    [self addText:text atX:x y:y offsetX:0 offsetY:0 earliestStart:earliestStart
      latestStart:latestStart color:color];
}

-(void) addText:(NSString *)text
     centredAtX:(float)x
              y:(float)y
        offsetX:(float)offsetX
        offsetY:(float)offsetY
  earliestStart:(float)earliestStart
    latestStart:(float)latestStart
          color:(GLubyte*)color{
    
    // Get the width of the string
    float width = [self layoutText:text atX:x y:y offsetX:0 offsetY:0 earliestStart:earliestStart
                       latestStart:latestStart color:color enableDraw:NO];
    width = 2*roundf(width/2.0);
    
    // Add the text
    [self layoutText:text atX:x y:y offsetX:-width/2.0+offsetX offsetY:-5.0+offsetY
       earliestStart:earliestStart
         latestStart:latestStart
               color:color enableDraw:YES];

}

-(BOOL)getCoords:(int*)coords
        forCharacter:(char)character {
    
    // Select the correct table
    int *tableX0;
    int *tableX1;
    int *tableY0;
    int *tableY1;
    int charIdx;
    if (48 <= character & character <=58) {
        tableX0 = numTableX0;
        tableX1 = numTableX1;
        tableY0 = numTableY0;
        tableY1 = numTableY1;
        charIdx = character - 48;
    } else if (65 <= character & character <=90) {
        tableX0 = letterTableX0;
        tableX1 = letterTableX1;
        tableY0 = letterTableY0;
        tableY1 = letterTableY1;
        charIdx = character - 65;
    } else {
        return NO;
    }
    coords[0] = tableX0[charIdx];
    coords[1] = tableY0[charIdx];
    coords[2] = tableX1[charIdx];
    coords[3] = tableY1[charIdx];
    return YES;
    
}

@end
