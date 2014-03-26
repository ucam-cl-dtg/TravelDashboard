//
//  LineShader.m
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

#import "LineShader.h"

typedef struct
{
    GLfloat posL[2];
    GLfloat partnerPosL[2];
    GLfloat aaOffset;
    GLfloat aaSign;
    GLfloat offsetN[3];
    GLubyte color[4];
} Vertex;

@interface LineShader () {
    GLint _u_tmLToC;
    GLint _u_tmNToC;
    GLint _a_posL;
    GLint _a_partnerPosL;
    GLint _a_aaOffset;
    GLint _a_aaSign;
    GLint _a_offsetN;
    GLint _a_color;
    GLuint _vertexArray;
    GLuint _vertexBuffer;
    GLuint _idxBuffer;
    Vertex *_vertices;
    GLushort *_idxs;
    int _numVertices;
    int _verticesCapacity;
    int _idxsCapacity;
}
@end

@implementation LineShader

- (id)init {
    if (self = [super init]) {
        _verticesCapacity = 1024;
        _idxsCapacity = 1024;
        _vertices = malloc(_verticesCapacity*sizeof(Vertex));
        _idxs = malloc(_idxsCapacity*sizeof(GLushort));
        _numVertices = 0;
        _numIdxs = 0;
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

- (void) addLines:(float*)posL
          offsetN:(float*)offsetN
      numVertices:(int)numVertices
            color:(GLubyte*)color {
    
    // Work out how many lines there are. If there aren't any, then return at this point.
    int numLines = numVertices/2;
    if (numLines<1) return;
    
    // Define the meshing stratergy
    int   vertexIdxSequence[]  = { 0, 1, 0, 1};
    int   partnerIdxSequence[] = { 1, 0, 1, 0};
    float offsetSequence[]     = { 1,-1,-1, 1};
    float signSequence[]       = {-1,-1, 1, 1};
    int   idxSequence[]        = { 0, 1, 2, 3, 2, 1};
    
    // Generate the vertex data
    for (int i=0; i<numLines; i++) {
        
        // Add vertices
        int firstIdx = _numVertices;
        for (int j=0; j<4; j++) {
            Vertex vertex;
            memcpy(&vertex.posL[0], &posL[2*i + 2*vertexIdxSequence[j]], 2*sizeof(GLfloat));
            memcpy(&vertex.partnerPosL[0], &posL[2*i + 2*partnerIdxSequence[j]], 2*sizeof(GLfloat));
            vertex.aaOffset = offsetSequence[j];
            vertex.aaSign = signSequence[j];
            memcpy(&vertex.offsetN[0], &offsetN[3*i + 3*vertexIdxSequence[j]], 3*sizeof(GLfloat));
            memcpy(&vertex.color[0], color, 4*sizeof(GLubyte));
            [self addVertex:vertex];
        }
        
        // Add indexes
        for (int j=0; j<6; j++) {
            [self addIdx:firstIdx + idxSequence[j]];
        }
        
    }
    
}

- (void) dealloc{
    free(_vertices);
    free(_idxs);
}

- (void)setupGL{
    
    self.shaderName = @"LineShader";
    [self loadShader];
    [self storeUniformLocations];
    [self storeAttributeLocations];
    
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
    glEnableVertexAttribArray(_a_partnerPosL);
    glVertexAttribPointer(_a_partnerPosL, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, partnerPosL));
    glEnableVertexAttribArray(_a_aaOffset);
    glVertexAttribPointer(_a_aaOffset, 1, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, aaOffset));
    glEnableVertexAttribArray(_a_aaSign);
    glVertexAttribPointer(_a_aaSign, 1, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, aaSign));
    glEnableVertexAttribArray(_a_offsetN);
    glVertexAttribPointer(_a_offsetN, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, offsetN));
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
    glDrawElements(GL_TRIANGLES, numIdxs, GL_UNSIGNED_SHORT, (void*)(firstIdx*sizeof(GLushort)));
}

- (void)drawGL{
    [self drawGLWithFirstIdx:0 numIdxs:_numIdxs];
}

- (void)storeUniformLocations{
    _u_tmLToC = glGetUniformLocation(_program, "u_tmLToC");
    _u_tmNToC = glGetUniformLocation(_program, "u_tmNToC");
}

- (void)storeAttributeLocations{
    _a_posL = glGetAttribLocation(_program, "a_posL");
    _a_partnerPosL = glGetAttribLocation(_program, "a_partnerPosL");
    _a_aaOffset = glGetAttribLocation(_program, "a_aaOffset");
    _a_aaSign = glGetAttribLocation(_program, "a_aaSign");
    _a_offsetN = glGetAttribLocation(_program, "a_offsetN");
    _a_color = glGetAttribLocation(_program, "a_color");
}

@end
