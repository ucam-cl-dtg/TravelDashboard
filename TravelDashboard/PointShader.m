//
//  PointShader.m
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

#import "PointShader.h"

typedef struct
{
    GLfloat startL[2];
    GLfloat endL[2];
    GLfloat startOffsetN[3];
    GLfloat endOffsetN[3];
    GLfloat startPhase;
    GLfloat endPhase;
    GLfloat phaseOffset;
    GLfloat earliestStart;
    GLfloat latestStart;
    GLubyte color[4];
} Vertex;

@interface PointShader () {
    GLint _u_tmLToC;
    GLint _u_tmNToC;
    GLint _u_animationPhase;
    GLint _u_startTime;
    GLint _a_startL;
    GLint _a_endL;
    GLint _a_startOffsetN;
    GLint _a_endOffsetN;
    GLint _a_startPhase;
    GLint _a_endPhase;
    GLint _a_phaseOffset;
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
}
@end

@implementation PointShader

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

- (void) addPathWithStartL:(float*)startL
                      endL:(float*)endL
              startOffsetN:(float*)startOffsetN
                endOffsetN:(float*)endOffsetN
                startPhase:(float)startPhase
                  endPhase:(float)endPhase
               phaseOffset:(float)phaseOffset
             earliestStart:(float)earliestStart
               latestStart:(float)latestStart
                     color:(GLubyte*)color {
    
    // Add vertex
    Vertex vertex;
    memcpy(vertex.startL, startL, 2*sizeof(GLfloat));
    memcpy(vertex.endL, endL, 2*sizeof(GLfloat));
    memcpy(vertex.startOffsetN, startOffsetN, 3*sizeof(GLfloat));
    memcpy(vertex.endOffsetN, endOffsetN, 3*sizeof(GLfloat));
    vertex.startPhase = startPhase;
    vertex.endPhase = endPhase;
    vertex.phaseOffset = phaseOffset;
    vertex.earliestStart = earliestStart;
    vertex.latestStart = latestStart;
    memcpy(vertex.color, color, 4*sizeof(GLubyte));
    [self addVertex:vertex];
    
    // Add index
    [self addIdx:_numVertices-1];
    
}

- (void) dealloc{
    free(_vertices);
    free(_idxs);
}

- (void)setupGL{
    
    self.shaderName = @"PointShader";
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
    
    glEnableVertexAttribArray(_a_startL);
    glVertexAttribPointer(_a_startL, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, startL));
    glEnableVertexAttribArray(_a_endL);
    glVertexAttribPointer(_a_endL, 2, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, endL));
    glEnableVertexAttribArray(_a_startOffsetN);
    glVertexAttribPointer(_a_startOffsetN, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, startOffsetN));
    glEnableVertexAttribArray(_a_endOffsetN);
    glVertexAttribPointer(_a_endOffsetN, 3, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, endOffsetN));
    glEnableVertexAttribArray(_a_startPhase);
    glVertexAttribPointer(_a_startPhase, 1, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, startPhase));
    glEnableVertexAttribArray(_a_endPhase);
    glVertexAttribPointer(_a_endPhase, 1, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, endPhase));
    glEnableVertexAttribArray(_a_phaseOffset);
    glVertexAttribPointer(_a_phaseOffset, 1, GL_FLOAT, GL_FALSE, sizeof(Vertex), (void*)offsetof(Vertex, phaseOffset));
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
    glUniform1fv(_u_animationPhase, 1, _animationPhase);
    glUniform1fv(_u_startTime, 1, _startTime);
    glDrawElements(GL_POINTS, numIdxs, GL_UNSIGNED_SHORT, (void*)(firstIdx*sizeof(GLushort)));
}

- (void)drawGL{
    [self drawGLWithFirstIdx:0 numIdxs:_numIdxs];
}

- (void)storeUniformLocations{
    _u_tmLToC = glGetUniformLocation(_program, "u_tmLToC");
    _u_tmNToC = glGetUniformLocation(_program, "u_tmNToC");
    _u_animationPhase = glGetUniformLocation(_program, "u_animationPhase");
    _u_startTime = glGetUniformLocation(_program, "u_startTime");
}

- (void)storeAttributeLocations{
    _a_startL = glGetAttribLocation(_program, "a_startL");
    _a_endL = glGetAttribLocation(_program, "a_endL");
    _a_startOffsetN = glGetAttribLocation(_program, "a_startOffsetN");
    _a_endOffsetN = glGetAttribLocation(_program, "a_endOffsetN");
    _a_startPhase = glGetAttribLocation(_program, "a_startPhase");
    _a_endPhase = glGetAttribLocation(_program, "a_endPhase");
    _a_phaseOffset = glGetAttribLocation(_program, "a_phaseOffset");
    _a_earliestStart = glGetAttribLocation(_program, "a_earliestStart");
    _a_latestStart = glGetAttribLocation(_program, "a_latestStart");
    _a_color = glGetAttribLocation(_program, "a_color");
}

@end
