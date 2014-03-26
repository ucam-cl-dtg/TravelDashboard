//
//  TextureShader.m
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

#import "TextureShader.h"

typedef struct
{
    GLfloat posL[2];
    GLfloat offsetN[3];
    GLfloat texCoord[2];
    GLfloat earliestStart;
    GLfloat latestStart;
    GLubyte color[4];
} Vertex;




@interface TextureShader () {
    GLint _u_tmLToC;
    GLint _u_tmNToC;
    GLint _u_startTime;
    GLint _s_texture;
    GLint _a_posL;
    GLint _a_offsetN;
    GLint _a_texCoord;
    GLint _a_earliestStart;
    GLint _a_latestStart;
    GLint _a_color;
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    GLuint _idxBuffer;
    Vertex *_vertices;
    GLushort *_idxs;
    int _numVertices;
    int _verticesCapacity;
    int _idxsCapacity;
    int _imageSize;
}
- (void) loadTexture;
@end

@implementation TextureShader

- (id)init{
    if (self = [super init]) {
        _verticesCapacity = 1024;
        _idxsCapacity = 1024;
        _vertices = malloc(_verticesCapacity*sizeof(Vertex));
        _idxs = malloc(_idxsCapacity*sizeof(GLushort));
        _numVertices = 0;
        _numIdxs = 0;
        _imageSize = 128;
    }
    return self;
}

- (void) addVertex:(Vertex)vertex{
    if (_numVertices == _verticesCapacity) {
        _verticesCapacity *= 2;
        _vertices = realloc(_vertices, _verticesCapacity*sizeof(Vertex));
    }
    _vertices[_numVertices] = vertex;
    _numVertices++;
}

- (void) addIdx:(GLushort)idx{
    if (_numIdxs == _idxsCapacity) {
        _idxsCapacity *= 2;
        _idxs = realloc(_idxs, _idxsCapacity*sizeof(GLushort));
    }
    _idxs[_numIdxs] = idx;
    _numIdxs++;
}

- (void) addTriangleStrip:(GLfloat *)posL
                   offset:(GLfloat *)offsetN
                texCoords:(GLfloat *)texCoord
            earliestStart:(float)earliestStart
              latestStart:(float)latestStart
                    color:(GLubyte*)color
              numVertices:(int)numVertices{
    
    // Work out how many triangles there are. If there aren't any, then return at this point.
    int numTriangles = numVertices-2;
    if (numTriangles<1) return;
    
    // Copy in the vertex data
    int firstIdx = _numVertices;
    for (int i=0; i<numVertices; i++) {
        Vertex vertex;
        memcpy(&vertex.posL[0], &posL[2*i], 2*sizeof(GLfloat));
        memcpy(&vertex.offsetN[0], &offsetN[3*i], 3*sizeof(GLfloat));
        memcpy(&vertex.texCoord[0], &texCoord[2*i], 2*sizeof(GLfloat));
        vertex.earliestStart = earliestStart;
        vertex.latestStart = latestStart;
        memcpy(vertex.color, color, 4*sizeof(GLubyte));
        [self addVertex:vertex];
    }
    
    // Generate indices for each triangle. Note winding order is reversed on every other triangle,
    // so that back face culling will work properly.
    for (int i=0; i<numTriangles; i++) {
        if (i%2 == 0) {
            [self addIdx:firstIdx + i];
            [self addIdx:firstIdx + i + 1];
            [self addIdx:firstIdx + i + 2];
        } else {
            [self addIdx:firstIdx + i + 1];
            [self addIdx:firstIdx + i];
            [self addIdx:firstIdx + i + 2];
        }
    }
    
}

- (void) dealloc{
    free(_vertices);
    free(_idxs);
}

- (void)setupGL{
        
    self.shaderName = @"TextureShader";
    [self loadShader];
    [self storeUniformLocations];
    [self storeAttributeLocations];
    [self loadTexture];
    
    glGenVertexArraysOES(1, &_vertexArray);
    glBindVertexArrayOES(_vertexArray);
    
    glGenBuffers(1, &_vertexBuffer);
    glBindBuffer(GL_ARRAY_BUFFER, _vertexBuffer);
    glBufferData(GL_ARRAY_BUFFER, sizeof(Vertex)*_numVertices, _vertices, GL_STATIC_DRAW);
    
    glGenBuffers(1, &_idxBuffer);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _idxBuffer);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, sizeof(GLushort)*_numIdxs, _idxs, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(_a_posL);
    glVertexAttribPointer(_a_posL, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, posL));
    glEnableVertexAttribArray(_a_offsetN);
    glVertexAttribPointer(_a_offsetN, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, offsetN));
    glEnableVertexAttribArray(_a_texCoord);
    glVertexAttribPointer(_a_texCoord, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, texCoord));
    glEnableVertexAttribArray(_a_earliestStart);
    glVertexAttribPointer(_a_earliestStart, 1, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, earliestStart));
    glEnableVertexAttribArray(_a_latestStart);
    glVertexAttribPointer(_a_latestStart, 1, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, latestStart));
    glEnableVertexAttribArray(_a_color);
    glVertexAttribPointer(_a_color, 4, GL_UNSIGNED_BYTE, GL_TRUE, sizeof(Vertex), (void*)offsetof(Vertex, color));
    
    glBindVertexArrayOES(0);
}

- (void)tearDownGL{
    glDeleteBuffers(1, &_vertexBuffer);
    glDeleteBuffers(1, &_idxBuffer);
    glDeleteVertexArraysOES(1, &_vertexArray);
    if (_program) {
        glDeleteProgram(_program);
        _program = 0;
    }
}

- (void)drawGLWithFirstIdx:(int)firstIdx
                   numIdxs:(int)numIdxs{
    glBindVertexArrayOES(_vertexArray);
    glUseProgram(_program);
    glUniformMatrix4fv(_u_tmLToC, 1, 0, _tmLToC);
    glUniformMatrix3fv(_u_tmNToC, 1, 0, _tmNToC);
    glUniform1fv(_u_startTime, 1, _startTime);
    glUniform1i(_s_texture, 0);
    glDrawElements(GL_TRIANGLES, numIdxs, GL_UNSIGNED_SHORT, (void*)(firstIdx*sizeof(GLushort)));
}

- (void)drawGL{
    [self drawGLWithFirstIdx:0 numIdxs:_numIdxs];
}

- (void)storeUniformLocations{
    _u_tmLToC = glGetUniformLocation(_program, "u_tmLToC");
    _u_tmNToC = glGetUniformLocation(_program, "u_tmNToC");
    _u_startTime = glGetUniformLocation(_program, "u_startTime");
    _s_texture = glGetUniformLocation(_program, "s_texture");
}

- (void)storeAttributeLocations{
    _a_posL = glGetAttribLocation(_program, "a_posL");
    _a_offsetN = glGetAttribLocation(_program, "a_offsetN");
    _a_texCoord = glGetAttribLocation(_program, "a_texCoord");
    _a_earliestStart = glGetAttribLocation(_program, "a_earliestStart");
    _a_latestStart = glGetAttribLocation(_program, "a_latestStart");
    _a_color = glGetAttribLocation(_program, "a_color");
}

- (void) loadTexture{
    NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@YES, GLKTextureLoaderOriginBottomLeft, nil];
    NSString *filename = [[NSBundle mainBundle] pathForResource:@"atlas_128x128" ofType:@"png"];
    GLKTextureInfo *texture = [GLKTextureLoader textureWithContentsOfFile:filename options:options error:&error];
    glActiveTexture(GL_TEXTURE0);
    glBindTexture(texture.target, texture.name);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);
}

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
                         color:(GLubyte*)color{
    
    GLfloat dx = MAX(fabsf(rx), fabsf(ry));
    GLfloat dy = MAX(fabsf(ux), fabsf(uy));
    GLfloat texCoords[] = {
        blx/_imageSize, bly/_imageSize,
        (blx + rx)/_imageSize, (bly + ry)/_imageSize,
        (blx + ux)/_imageSize, (bly + uy)/_imageSize,
        (blx + ux + rx)/_imageSize, (bly + uy + ry)/_imageSize};
    GLfloat posF[] = {x, y,
        x, y,
        x, y,
        x, y};
    GLfloat offsetN[] = {
                offsetX,         offsetY, offsetT,
         dx/2 + offsetX,         offsetY, offsetT,
                offsetX,  dy/2 + offsetY, offsetT,
         dx/2 + offsetX,  dy/2 + offsetY, offsetT};
    [self addTriangleStrip:posF offset:offsetN texCoords:texCoords earliestStart:earliestStart
               latestStart:latestStart color:color numVertices:4];
}

@end
