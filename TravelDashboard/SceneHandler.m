//
//  SceneHandler.m
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

#import "SceneHandler.h"
#import "JourneySegment.h"
#import "SegmentInfo.h"

int wgb[] = {428,447,467,488,507,527,550,573,602,627,636,671,672,697,713,732,752,775,792,811,837,852,872,893,912,932,0,971,992,1011,1031,1072,1087,0,0,1131,1152,1172,427,447,467,488,507,0,549,0,0,0,0,652,671,691,718,732,752,777,792,815,837,852,873,893,912,934,951,970,992,1017,1043,1051,1071,1093,1114,1132,1155,0,428,447,467,487,507,528,553,573,600,614,632,663,680,692,717,0,753,771,801,811,836,859,977,895,912,932,952,0,991,1011,1032,1053,1072,1091,1116,1132,1151,1173,0,448,467,488,0,528,565,583,593,629,640,656,694,696,712,738,753,773,793,819,833,858,872,891,915,931,952,972,991,1011,1031,1056,1070,1091,1119,1131,1152,1172,427,448,469,487,508,527,557,571,597,621,633,654,677,695,725,735,753,775,793,813,0,854,873,0,917,935,0,0,997,1016,1041,0,1081,1095,1114,0,1151,1171,428,449,467,487,507,528,547,571,594,615,633,652,673,691,711,731,751,771,795,816,831,853,873,892,912,935,952,975,992,0,1044,1076,0,0,0,1133,1163,1171,429,447,467,490,507,527,547,572,594,615,633,652,675,696,711,734,759,772,794,822,832,852,875,891,915,935,951,975,0,1011,0,0,0,1092,0,0,0,0,428,447,467,488,509,527,551,573,594,614,636,653,674,693,712,733,751,775,798,813,840,855,872,893,913,931,951,972,991,1010,1031,1055,1071,1093,0,1131,1151,1172,427,447,467,487,507,528,556,573,594,625,633,651,685,692,712,0,752,772,796,819,832,857,875,891,911,931,952,972,991,1014,1040,1054,1071,1092,1115,1132,1152,1171,428,448,0,488,507,528,0,572,599,0,632,653,0,696,717,0,754,774,806,822,833,870,0,890,0,931,952,971,992,1011,1047,0,0,1095,1114,0,1160,1172,428,447,467,487,507,531,557,578,598,624,633,656,0,691,712,733,753,775,793,821,836,853,880,891,914,935,951,975,990,1013,0,1060,1071,1093,1122,1130,1150,1173,427,447,467,487,513,546,550,572,0,613,632,650,680,695,712,732,751,775,796,811,842,855,871,902,912,932,952,973,991,1013,1037,1053,1071,1096,1117,1132,1151,1171,427,447,479,494,0,527,561,570,604,0,631,658,671,692,712,731,751,771,792,813,833,851,872,892,911,937,952,975,992,1013,1031,1053,1071,1093,1115,1132,1152,1171,429,447,467,487,508,527,553,574,592,618,633,651,682,692,711,738,751,771,801,815,831,855,871,891,912,940,951,977,992,0,1032,1066,0,1110,1148,1144,0,1190,428,448,467,487,507,528,548,571,592,611,631,652,671,692,713,732,751,771,791,811,832,852,871,892,911,931,951,971,992,1013,1032,0,0,0,0,1136,1157,1171};
int bro[] = {448,468,489,513,532,553,570,598,629,637,653,701,689,711,731,746,771,791,809,831,853,868,889,910,928,952,0,998,1015,1035,1053,1097,1114,0,0,1151,1171,1189,447,468,487,520,538,0,570,0,0,0,0,674,689,711,736,749,769,795,810,834,852,868,888,912,933,952,970,992,1017,1036,1067,1072,1090,1113,1131,1150,1173,0,446,467,492,517,535,554,572,594,620,630,651,679,696,706,735,0,766,791,822,826,854,876,999,912,930,951,971,0,1011,1026,1054,1074,1092,1111,1133,1150,1166,1190,0,468,496,516,0,554,587,601,610,649,656,673,702,711,728,751,767,790,811,833,849,874,886,906,932,948,970,992,1010,1028,1052,1077,1090,1109,1133,1146,1170,1189,447,466,496,515,541,552,580,591,618,638,650,671,696,713,743,752,772,812,811,832,0,871,886,0,936,951,0,0,1020,1036,1063,0,1108,1111,1130,0,1168,1186,447,466,487,511,532,553,566,587,612,635,650,670,689,708,731,749,769,788,813,835,847,869,889,909,931,960,968,1000,1020,0,1074,1110,0,0,0,1153,1182,1189,447,467,492,516,532,554,569,592,613,631,646,672,691,713,727,749,776,786,813,838,847,869,890,908,933,950,966,992,0,1029,0,0,0,1108,0,0,0,0,447,467,492,516,535,551,571,595,612,629,653,669,694,708,737,749,767,793,818,829,854,872,891,911,928,952,967,989,1007,1027,1049,1076,1089,1111,0,1148,1168,1191,446,466,492,509,528,555,575,589,612,642,650,669,706,708,732,0,772,789,815,838,850,874,893,907,931,948,977,993,1010,1032,1060,1075,1088,1110,1133,1147,1167,1186,448,468,0,511,535,553,0,588,615,0,649,677,0,718,737,0,777,796,826,844,851,894,0,910,0,950,975,1006,1020,1031,1075,0,0,1121,1133,0,1177,1186,447,468,491,517,534,557,577,596,618,641,649,675,0,708,733,748,770,795,812,840,853,870,899,909,932,951,971,1000,1010,1034,0,1082,1090,1111,1136,1146,1169,1186,446,467,491,516,542,568,567,587,0,630,650,670,697,714,730,750,770,795,811,827,860,870,888,921,932,951,975,1001,1009,1032,1060,1071,1086,1115,1135,1148,1170,1187,447,467,497,512,0,556,578,591,623,0,652,674,689,709,729,750,767,789,811,828,849,868,887,908,928,957,970,999,1010,1036,1053,1073,1088,1111,1135,1147,1168,1186,446,467,488,511,537,551,571,591,609,635,650,669,700,706,729,756,769,788,817,833,848,875,889,907,931,970,977,1001,1023,0,1061,1093,0,1136,1163,1162,0,1206,447,466,488,511,543,556,570,589,610,626,648,669,687,706,729,747,766,789,810,828,849,869,887,911,930,953,973,1000,1014,1032,1059,0,0,0,0,1154,1176,1187};
int scd[] = {427,447,467,487,507,527,547,570,590,610,630,650,670,690,710,730,750,770,790,810,830,850,870,890,910,930,950,970,990,1010,1030,1050,1070,1090,1110,1130,1150,1170};
int numDays = 15;

// Define vertical band types and colors
typedef enum {
    timelineBand,
    walkBand,
    carBand,
    busBand,
    trainBand
} BandTypes;
typedef GLubyte Color[4];
Color BandColors[] = {
    255, 255, 255, 255,
    249, 249, 252, 255,
    249, 249, 252, 255,
    255, 255, 255, 255,
    255, 255, 255, 255};

// Define line colors
Color boundaryLine  = {178, 178, 178, 255};
Color scheduleLine  = {255, 59, 48, 255};
Color walkLine      = {0, 0, 0, 64};
Color timeLineColor = {0, 0, 0, 20};
Color startLineColor = {0, 0, 0, 180};
Color timeTextColor  = {0, 0, 0, 255};
Color headerTextColor  = {0, 0, 0, 255};
Color lateTextColor  = {255, 59, 48, 255};
Color dotColor      = {255, 59, 48, 32};

// Define header band parameters
Color headerBand = {64,64,127, 12};

float headerBandStartPt = 64;
float headerBandHeightPt = 74;
float headerIconLocationPt = 30;
float headerTextLocationPt = 10;
float minBandWidthPts = 30.0;
float walkSectionFlexibleSpace = 0.1;
float carSectionFlexibleSpace = 0.1;
float transSectionFlexibleSpace = 0.5;
float timelineFlexibleSpace = 0.1;

GLfloat startT = 0.0;
GLfloat endT = 24.0;

@interface SceneHandler(){
    int _numTFrameIdxsTriangle;
    int _numTFrameIdxsTexture;
    int _numTFrameIdxsLine;
    int _numFFrameIdxsTriangle;
    int _numFFrameIdxsTexture;
    int _numFFrameIdxsLine;
}
@property (strong, nonatomic) TriangleShader *triangleShader;
@property (strong, nonatomic) LineShader *lineShader;
@property (strong, nonatomic) PointShader *pointShader;
@property (strong, nonatomic) IconHandler *iconHandler;
@property (strong, nonatomic) TextHandler *textHandler;

-(void) addBoxWithX0L:(float)x0L x0N:(float)x0N x1L:(float)x1L x1N:(float)x1N
                  y0L:(float)y0L y0N:(float)y0N y1L:(float)y1L y1N:(float)y1N
                color:(Color)color;
-(void) addLineWithX0L:(float)x0L x0N:(float)x0N x1L:(float)x1L x1N:(float)x1N
                   y0L:(float)y0L y0N:(float)y0N y1L:(float)y1L y1N:(float)y1N
                 color:(Color)color;
- (float) getTimeFromTimeString:(NSString*)string;
- (int) getFirstServiceExpectedAfter:(float)t forSegment:(int)j;
@end

@implementation SceneHandler

-(id)initWithTriangleShader:(TriangleShader*)triangleShader
                 lineShader:(LineShader *)lineShader
                pointShader:(PointShader *)pointShader
                iconHandler:(IconHandler*)iconHandler
                textHandler:(TextHandler *)textHandler{
    if (self = [super init]) {
        self.triangleShader = triangleShader;
        self.lineShader = lineShader;
        self.pointShader = pointShader;
        self.iconHandler = iconHandler;
        self.textHandler = textHandler;
    }
    return self;
}

-(void)makeSceneWithWidth:(float)width{
    
    // Work out which bands there should be
    int numBands = (int)self.journeySpec.count + 1;
    NSMutableArray *bandType = [[NSMutableArray alloc] initWithObjects:[NSNumber numberWithInt:timelineBand], nil];
    for (JourneySegment *segment in self.journeySpec) {
        if (segment.journeyMode == JourneyModeWalk) {
            [bandType addObject:[NSNumber numberWithInt:walkBand]];
        }
        if (segment.journeyMode == JourneyModeCar) {
            [bandType addObject:[NSNumber numberWithInt:carBand]];
        }
        if (segment.journeyMode == JourneyModeBus) {
            [bandType addObject:[NSNumber numberWithInt:busBand]];
        }
        if (segment.journeyMode == JourneyModeTrain) {
            [bandType addObject:[NSNumber numberWithInt:trainBand]];
        }
    }
    
    // Populate duration info in any car bands
    for (int i=0; i<self.journeySpec.count; i++) {
        JourneySegment *segmentSpec = [self.journeySpec objectAtIndex:i];
        SegmentInfo *segmentInfo = [self.journeyInfo objectAtIndex:i];
        if (segmentSpec.journeyMode == JourneyModeCar) {
            NSString *t0 = [segmentInfo.scheduledStart objectAtIndex:0];
            NSString *t1 = [segmentInfo.scheduledEnd objectAtIndex:0];
            float dt = [self getTimeFromTimeString:t1] - [self getTimeFromTimeString:t0];
            segmentSpec.durationMin = roundf(60.0*dt);
        }
    }
    
    // Get the total amount of flexible and fixed space
    float totalFixed = numBands*minBandWidthPts;
    float totalFlex = 0.0;
    for (int i=0; i<numBands; i++) {
        if ([[bandType objectAtIndex:i] integerValue] == timelineBand) {
            totalFlex += timelineFlexibleSpace;
        } else if ([[bandType objectAtIndex:i] integerValue] == walkBand){
            totalFlex += walkSectionFlexibleSpace;
        } else if ([[bandType objectAtIndex:i] integerValue] == carBand){
            totalFlex += carSectionFlexibleSpace;
        } else {
            totalFlex += transSectionFlexibleSpace;
        }
    }
    float s = totalFlex*width/(width-totalFixed);
    
    // Work out the horizontal locations of the bands
    GLfloat bandStartFx[numBands];
    GLfloat bandStartNx[numBands];
    GLfloat bandMidFx[numBands];
    GLfloat bandMidNx[numBands];
    GLfloat bandEndFx[numBands];
    GLfloat bandEndNx[numBands];
    float cumF = 0.0;
    float cumN = 0.0;
    float xF, xN;
    for (int i=0; i<numBands; i++) {
        xN = minBandWidthPts;
        if ([[bandType objectAtIndex:i] integerValue] == timelineBand) {
            xF = timelineFlexibleSpace;
        } else if ([[bandType objectAtIndex:i] integerValue] == walkBand){
            xF = walkSectionFlexibleSpace;
        } else if ([[bandType objectAtIndex:i] integerValue] == carBand){
            xF = carSectionFlexibleSpace;
        } else {
            xF = transSectionFlexibleSpace;
        }
        bandStartFx[i] = cumF;
        bandStartNx[i] = cumN;
        bandMidFx[i]   = cumF + xF*0.5/s;
        bandMidNx[i]   = cumN + xN*0.5;
        bandEndFx[i]   = cumF + xF/s;
        bandEndNx[i]   = cumN + xN;
        cumF += xF/s;
        cumN += xN;
    }
    
    // Make everything in the T frame
    // Vertical bands
    for (int i=0; i<numBands; i++) {
        GLubyte *color = BandColors[[[bandType objectAtIndex:i] integerValue]];
        [self addBoxWithX0L:bandStartFx[i] x0N:bandStartNx[i] x1L:bandEndFx[i] x1N:bandEndNx[i] y0L:startT y0N:0 y1L:endT y1N:0 color:color];
    }
    
    // Services
    int numSegments = (int) self.journeySpec.count;
    for (int i=0; i<numSegments; i++) {
        JourneySegment *segmentSpec = [self.journeySpec objectAtIndex:i];
        SegmentInfo *segmentInfo = [self.journeyInfo objectAtIndex:i];
        JourneyMode journeyMode = segmentSpec.journeyMode;
        int bandIdx = i+1;
        if (journeyMode == JourneyModeBus | journeyMode == JourneyModeTrain) {
            
            int numServices = (int) segmentInfo.scheduledStart.count;
            for (int j=0; j<numServices; j++) {
                float tStart = [self getTimeFromTimeString:[segmentInfo.scheduledStart objectAtIndex:j]];
                float tEnd = [self getTimeFromTimeString:[segmentInfo.scheduledEnd objectAtIndex:j]];
                [self addLineWithX0L:bandStartFx[bandIdx] x0N:bandStartNx[bandIdx]
                                 x1L:bandEndFx[bandIdx]   x1N:bandEndNx[bandIdx]
                                 y0L:tStart y0N:0 y1L:tEnd y1N:0 color:walkLine];
                
            }
        }
    }
    
    // Schedule-based paths
    // Identify the first scheduled segment, if there is one
    int firstScheduledSegment = -1;
    int numScheduledSegments = 0;
    for (int i=0; i<numSegments; i++) {
        if ([[self.journeySpec objectAtIndex:i] journeyMode] == JourneyModeBus |
            [[self.journeySpec objectAtIndex:i] journeyMode] == JourneyModeTrain) {
            if (firstScheduledSegment == -1) firstScheduledSegment = i;
            numScheduledSegments++;
        }
    }
    BOOL scheduledServicesExist = (firstScheduledSegment != -1);
    
    int numServices;
    if (scheduledServicesExist) {
        numServices = (int) [[self.journeyInfo objectAtIndex:firstScheduledSegment] scheduledStart].count;
    } else {
        numServices=1;
    }
  
    
    JourneySegment *firstSceduledSpec = [self.journeySpec objectAtIndex:firstScheduledSegment];
    if (firstSceduledSpec.journeyMode == JourneyModeBus) {
        
        if (([firstSceduledSpec.startPoint compare:@"0500CCITY424"] == NSOrderedSame ) &
            ([firstSceduledSpec.endPoint compare:@"0500CCITY471"] == NSOrderedSame )) {
            self.mcEnabled = YES;
        }
    }
    
    float earliestStart[50];
    float latestStart[50];
    if (scheduledServicesExist) {
        
        // Loop over MC trials
        for (int mcIdx=0; mcIdx<numDays; mcIdx++) {
        
            // Do perturbation of the expected times
            NSMutableArray *mcJourneyInfo = [NSKeyedUnarchiver unarchiveObjectWithData:
                                             [NSKeyedArchiver archivedDataWithRootObject:self.journeyInfo]];
            
            int numActualServices;
            if (self.mcEnabled) {
                SegmentInfo *busInfo = [mcJourneyInfo objectAtIndex:firstScheduledSegment];
                numActualServices = 0;
                NSMutableArray *expectedStart = [[NSMutableArray alloc] init];
                NSMutableArray *expectedEnd = [[NSMutableArray alloc] init];
                for (int i=0; i<38; i++) {
                    SegmentInfo *liveData = [self.journeyInfo objectAtIndex: firstScheduledSegment];
                    NSString *liveStartSch = [liveData.scheduledStart objectAtIndex:i];
                    NSString *liveStartExp = [liveData.expectedStart objectAtIndex:i];
                    NSString *liveEndExp = [liveData.expectedEnd objectAtIndex:i];
                    if ([liveStartExp compare:liveStartSch] != NSOrderedSame) {
                        numActualServices++;
                        [expectedStart addObject:liveStartExp];
                        if (wgb[i+38*mcIdx] > 0) {
                            int dur = bro[i+38*mcIdx] - wgb[i+38*mcIdx];
                            int baseTime = [self getTimeFromTimeString:liveStartExp]*60.0;
                            int fusedTime = baseTime + dur;
                            [expectedEnd addObject:[NSString stringWithFormat:@"%02i:%02i", fusedTime/60, fusedTime%60]];
                        } else {
                            [expectedEnd addObject:liveEndExp];
                        }
                    } else {
                        if (wgb[i+38*mcIdx] > 0) {
                            numActualServices++;
                            [expectedStart addObject:[NSString stringWithFormat:@"%02i:%02i", wgb[i+38*mcIdx]/60, wgb[i+38*mcIdx]%60]];
                            [expectedEnd addObject:[NSString stringWithFormat:@"%02i:%02i", bro[i+38*mcIdx]/60, bro[i+38*mcIdx]%60]];
                        }
                    }
                }
                busInfo.expectedStart = expectedStart;
                busInfo.expectedEnd = expectedEnd;
                busInfo.scheduledStart = expectedStart;
                busInfo.scheduledEnd = expectedEnd;
            } else {
                numActualServices = numServices;
            }
            
            // Work out their earliest and latest start times
            earliestStart[0] = 0.0;
            float walkTime = 0.0;
            if (firstScheduledSegment==1) {
                JourneySegment *initialWalkSegment = [self.journeySpec objectAtIndex:0];
                walkTime = initialWalkSegment.durationMin / 60.0;
            }
            for (int i=0; i<numActualServices; i++) {
                SegmentInfo *segmentInfo = [mcJourneyInfo objectAtIndex:firstScheduledSegment];
                NSString *startTime = [segmentInfo.expectedStart objectAtIndex:i];
                latestStart[i] = [self getTimeFromTimeString:startTime] - walkTime;
            }
            for (int i=1; i<numActualServices; i++) {
                earliestStart[i] = latestStart[i-1];
            }
            
            // For each initial service
            for (int i=0; i<numActualServices; i++) {
                
                // Work out the routing
                BOOL routingValid = YES;
                int serviceIdx[numSegments];
                serviceIdx[firstScheduledSegment] = i;
                SegmentInfo *firstScheduledSegmentInfo = [mcJourneyInfo objectAtIndex:firstScheduledSegment];
                float t = [self getTimeFromTimeString:[[firstScheduledSegmentInfo expectedEnd] objectAtIndex:i]];
                for (int j=firstScheduledSegment+1; j<numSegments; j++) {
                    JourneySegment *segmentSpec = [self.journeySpec objectAtIndex:j];
                    JourneyMode journeyMode = segmentSpec.journeyMode;
                    
                    if ((journeyMode == JourneyModeWalk) | (journeyMode == JourneyModeCar)) {
                        t += segmentSpec.durationMin / 60.0;
                    } else {
                        serviceIdx[j] = [self getFirstServiceExpectedAfter:t forSegment:j];
                        if (serviceIdx[j] < 0) {
                            routingValid = NO;
                        } else {
                            t = [self getTimeFromTimeString:[[[mcJourneyInfo objectAtIndex:j] expectedEnd] objectAtIndex:serviceIdx[j]]];
                        }
                    }
                }
                if (!routingValid) {
                    break;
                }
                
                // Work out how many lines are in this path
                int numWaits = numScheduledSegments;
                int numLines = numWaits + numSegments;
                int numVertices = numLines + 1;
                
                // Generate the lines
                float pathTy[numVertices];
                float pathFx[numVertices];
                float pathNx[numVertices];
                
                int vertexIdx = 0;
                for (int j=0; j<numSegments; j++) {
                    JourneySegment *segmentSpec = [self.journeySpec objectAtIndex:j];
                    JourneyMode journeyMode = segmentSpec.journeyMode;
                    int bandIdx = j+1;
                    
                    // Initial walk
                    if (((journeyMode == JourneyModeWalk) | (journeyMode == JourneyModeCar)) & (j==0)) {
                        SegmentInfo *nextSegmentInfo = [mcJourneyInfo objectAtIndex:j+1];
                        pathTy[vertexIdx] = [self getTimeFromTimeString:[nextSegmentInfo.scheduledStart objectAtIndex:i]] - segmentSpec.durationMin/60.0;
                        pathFx[vertexIdx] = bandStartFx[bandIdx];
                        pathNx[vertexIdx] = bandStartNx[bandIdx];
                        vertexIdx++;
                        pathTy[vertexIdx] = [self getTimeFromTimeString:[nextSegmentInfo.scheduledStart objectAtIndex:i]];
                        pathFx[vertexIdx] = bandEndFx[bandIdx];
                        pathNx[vertexIdx] = bandEndNx[bandIdx];
                        vertexIdx++;
                    }
                    
                    // Non-initial walk
                    if (((journeyMode == JourneyModeWalk) | (journeyMode == JourneyModeCar)) & (j!=0)) {
                        SegmentInfo *previousSegmentInfo = [mcJourneyInfo objectAtIndex:j-1];
                        NSString *previousSegmentEnd = [previousSegmentInfo.expectedEnd objectAtIndex:serviceIdx[j-1]];
                        pathTy[vertexIdx] = [self getTimeFromTimeString:previousSegmentEnd] + segmentSpec.durationMin/60.0;
                        pathFx[vertexIdx] = bandEndFx[bandIdx];
                        pathNx[vertexIdx] = bandEndNx[bandIdx];
                        vertexIdx++;
                    }
                    
                    // Service
                    if ((journeyMode == JourneyModeTrain) | (journeyMode == JourneyModeBus)) {
                        SegmentInfo *segmentInfo = [mcJourneyInfo objectAtIndex:j];
                        pathTy[vertexIdx] = [self getTimeFromTimeString:[segmentInfo.expectedStart objectAtIndex:serviceIdx[j]]];
                        pathFx[vertexIdx] = bandStartFx[bandIdx];
                        pathNx[vertexIdx] = bandStartNx[bandIdx];
                        vertexIdx++;
                        pathTy[vertexIdx] = [self getTimeFromTimeString:[segmentInfo.expectedEnd objectAtIndex:serviceIdx[j]]];
                        pathFx[vertexIdx] = bandEndFx[bandIdx];
                        pathNx[vertexIdx] = bandEndNx[bandIdx];
                        vertexIdx++;
                    }
                    
                }
                numLines = vertexIdx-1;
                
                // Generate paths
                for (int j=0; j<numLines; j++){
                    for (int k=0; k<50; k++) {
                        GLfloat startT[] = {pathFx[j], pathTy[j]};
                        GLfloat endT[] = {pathFx[j+1], pathTy[j+1]};
                        GLfloat startOffsetN[] = {pathNx[j], 0, 0};
                        GLfloat endOffsetN[] = {pathNx[j+1], 0, 0};
                        GLfloat startPhase = ((float) j) / numLines;
                        GLfloat endPhase = ((float)(j+1)) / numLines;
                        [self.pointShader addPathWithStartL:startT
                                                       endL:endT
                                               startOffsetN:startOffsetN
                                                 endOffsetN:endOffsetN
                                                 startPhase:startPhase
                                                   endPhase:endPhase
                                                phaseOffset:k/50.0
                                              earliestStart:earliestStart[i]
                                                latestStart:latestStart[i]
                                                      color:dotColor];
                    }
                }
            }
        }
    }
    
    // Time lines
    for (int i=0; i<24; i++) {
        NSString *label = [NSString stringWithFormat:@"%i:00", i];
        [self.textHandler addText:label centredAtX:bandMidFx[0] y:i offsetX:bandMidNx[0] offsetY:0.0
                    earliestStart:0.0 latestStart:24.0 color:timeTextColor];
        [self addLineWithX0L:bandStartFx[1] x0N:bandStartNx[1]-4.0
                         x1L:bandEndFx[numSegments]   x1N:bandEndNx[numSegments]
                         y0L:i y0N:0 y1L:i y1N:0 color:timeLineColor];}
    
    
    
    // Store the current number of indices
    _numTFrameIdxsTriangle = self.triangleShader.numIdxs;
    _numTFrameIdxsTexture = self.iconHandler.textureShader.numIdxs;
    _numTFrameIdxsLine = self.lineShader.numIdxs;
    
    // Make everything in the F frame
    // Header band
    [self addBoxWithX0L:bandStartFx[0] x0N:bandStartNx[0]
                    x1L:bandEndFx[numSegments] x1N:bandEndNx[numSegments]
                    y0L:0 y0N:-headerBandStartPt y1L:0 y1N:-headerBandStartPt-headerBandHeightPt color:headerBand];
    
    // Icons
    for (int i=1; i<numSegments+1; i++) {
        if ([[bandType objectAtIndex:i] integerValue] == walkBand){
            [self.iconHandler addWalkAtX:bandMidFx[i]
                                       y:0.0
                                 offsetX:bandMidNx[i]
                                 offsetY:-headerBandStartPt-headerIconLocationPt];
        }
        if ([[bandType objectAtIndex:i] integerValue] == carBand){
            [self.iconHandler addCarAtX:bandMidFx[i]
                                      y:0.0
                                offsetX:bandMidNx[i]
                                offsetY:-headerBandStartPt-headerIconLocationPt];
        }
        if ([[bandType objectAtIndex:i] integerValue]==busBand){
            [self.iconHandler addBusAtX:bandMidFx[i]
                                      y:0.0
                                offsetX:bandMidNx[i]
                                offsetY:-headerBandStartPt-headerIconLocationPt];
        }
        if ([[bandType objectAtIndex:i] integerValue]==trainBand){
            [self.iconHandler addTrainAtX:bandMidFx[i]
                                        y:0.0
                                  offsetX:bandMidNx[i]
                                  offsetY:-headerBandStartPt-headerIconLocationPt];
        }
    }
    
    // Header text
    NSMutableArray *bandText = [[NSMutableArray alloc] init];
    for (JourneySegment *segment in self.journeySpec) {
        NSString *text;
        if (segment.journeyMode == JourneyModeWalk) {
            text = [NSString stringWithFormat:@"%i", (int)roundf(segment.durationMin)];
        }
        if (segment.journeyMode == JourneyModeCar) {
            text = [NSString stringWithFormat:@"%i", (int)roundf(segment.durationMin)];
        }
        if (segment.journeyMode == JourneyModeBus) {
            NSRange range = [segment.service rangeOfString:@":"];
            text = [segment.service substringToIndex:range.location];
        }
        if (segment.journeyMode == JourneyModeTrain) {
            text = [NSString stringWithFormat:@"%@ %@", segment.startPoint, segment.endPoint];
        }
        [bandText addObject:text];
    }
    for (int i=1; i<(numSegments+1); i++) {
        [self.textHandler addText:[bandText objectAtIndex:i-1] centredAtX:bandMidFx[i] y:0.0 offsetX:bandMidNx[i] offsetY:-headerBandStartPt-headerTextLocationPt earliestStart:0.0 latestStart:24.0 color:timeTextColor];
    }
    
    // Time text
    if (scheduledServicesExist) {

        // For each initial service
        for (int i=0; i<numServices; i++) {
            
            // Work out the routing
            BOOL routingValid = YES;
            int serviceIdx[numSegments];
            serviceIdx[firstScheduledSegment] = i;
            SegmentInfo *firstScheduledSegmentInfo = [self.journeyInfo objectAtIndex:firstScheduledSegment];
            float t = [self getTimeFromTimeString:[[firstScheduledSegmentInfo expectedEnd] objectAtIndex:i]];
            for (int j=firstScheduledSegment+1; j<numSegments; j++) {
                JourneySegment *segmentSpec = [self.journeySpec objectAtIndex:j];
                JourneyMode journeyMode = segmentSpec.journeyMode;
                
                if (journeyMode == JourneyModeWalk) {
                    t += segmentSpec.durationMin / 60.0;
                } else {
                    serviceIdx[j] = [self getFirstServiceExpectedAfter:t forSegment:j];
                    if (serviceIdx[j] < 0) {
                        routingValid = NO;
                    } else {
                        t = [self getTimeFromTimeString:[[[self.journeyInfo objectAtIndex:j] expectedEnd] objectAtIndex:serviceIdx[j]]];
                    }
                }
            }
            if (!routingValid) {
                break;
            }
            
            for (int j=0; j<numSegments; j++) {
                JourneySegment *segmentSpec = [self.journeySpec objectAtIndex:j];
                JourneyMode journeyMode = segmentSpec.journeyMode;
                
                 // Service
                if ((journeyMode == JourneyModeBus) | (journeyMode == JourneyModeTrain)) {
                    SegmentInfo *segmentInfo = [self.journeyInfo objectAtIndex:j];
                    NSString *scheduledStart = [segmentInfo.scheduledStart objectAtIndex:serviceIdx[j]];
                    NSString *expectedStart = [segmentInfo.expectedStart objectAtIndex:serviceIdx[j]];
                    [self.textHandler addText:scheduledStart
                                   centredAtX:bandMidFx[j+1]
                                            y:0.0 offsetX:bandMidNx[j+1]
                                      offsetY:-headerBandStartPt-50.0
                                earliestStart:earliestStart[i]
                                  latestStart:latestStart[i]
                                        color:headerTextColor];
                    if (![scheduledStart isEqualToString:expectedStart]){
                        [self.textHandler addText:expectedStart
                                       centredAtX:bandMidFx[j+1]
                                                y:0.0 offsetX:bandMidNx[j+1]
                                          offsetY:-headerBandStartPt-63.0
                                    earliestStart:earliestStart[i]
                                      latestStart:latestStart[i]
                                            color:lateTextColor];
                    }
                    
                }
            }
        }
    }

    // Start-time line
    [self addLineWithX0L:bandStartFx[0] x0N:bandStartNx[0]+10.0
                     x1L:bandEndFx[numBands-1] x1N:bandEndNx[numBands-1]
                     y0L:0.3 y0N:0.0 y1L:0.3 y1N:0.0 color:startLineColor];
    {
        GLfloat posL[] = {
            0.0, 0.3,
            0.0, 0.3,
            0.0, 0.3};
        GLfloat posN[] = {
            0.0, -5.0, 0.0,
            0.0,  5.0, 0.0,
            8.0,  0.0, 0.0};
        [self.triangleShader addTriangleStrip:posL offset:posN numVertices:3 color:scheduleLine];
    }
    
    // Store the current number of indices
    _numFFrameIdxsTriangle = self.triangleShader.numIdxs - _numTFrameIdxsTriangle;
    _numFFrameIdxsTexture  = self.iconHandler.textureShader.numIdxs - _numTFrameIdxsTexture;
    _numFFrameIdxsLine  = self.lineShader.numIdxs - _numTFrameIdxsLine;
    
    // Populate buffers
    [self.triangleShader setupGL];
    [self.iconHandler.textureShader setupGL];
    [self.lineShader setupGL];
    [self.pointShader setupGL];

}

-(void)draw{
    
    // Draw the T frame objects
    self.triangleShader.tmLToC = self.tmTToC;
    self.triangleShader.tmNToC = self.tmNToC;
    [self.triangleShader drawGLWithFirstIdx:0 numIdxs:_numTFrameIdxsTriangle];
    self.lineShader.tmLToC = self.tmTToC;
    self.lineShader.tmNToC = self.tmNToC;
    [self.lineShader drawGLWithFirstIdx:0 numIdxs:_numTFrameIdxsLine];
    self.pointShader.tmLToC = self.tmTToC;
    self.pointShader.tmNToC = self.tmNToC;
    self.pointShader.animationPhase = _animationPhase;
    self.pointShader.startTime = _startTime;
    [self.pointShader drawGL];
    self.iconHandler.textureShader.tmLToC = self.tmTToC;
    self.iconHandler.textureShader.tmNToC = self.tmNToC;
    self.iconHandler.textureShader.startTime = _startTime;
    [self.iconHandler.textureShader drawGLWithFirstIdx:0 numIdxs:_numTFrameIdxsTexture];

    // Draw the F frame objects
    self.triangleShader.tmLToC = self.tmFToC;
    self.triangleShader.tmNToC = self.tmNToC;
    [self.triangleShader drawGLWithFirstIdx:_numTFrameIdxsTriangle numIdxs:_numFFrameIdxsTriangle];
    self.lineShader.tmLToC = self.tmFToC;
    self.lineShader.tmNToC = self.tmNToC;
    [self.lineShader drawGLWithFirstIdx:_numTFrameIdxsLine numIdxs:_numFFrameIdxsLine];
    self.iconHandler.textureShader.tmLToC = self.tmFToC;
    self.iconHandler.textureShader.tmNToC = self.tmNToC;
    [self.iconHandler.textureShader drawGLWithFirstIdx:_numTFrameIdxsTexture numIdxs:_numFFrameIdxsTexture];
        
}

-(void) addBoxWithX0L:(float)x0L
                  x0N:(float)x0N
                  x1L:(float)x1L
                  x1N:(float)x1N
                  y0L:(float)y0L
                  y0N:(float)y0N
                  y1L:(float)y1L
                  y1N:(float)y1N
                color:(Color)color{
    
    GLfloat posL[] = {
        x0L, y0L,
        x0L, y1L,
        x1L, y0L,
        x1L, y1L,
    };
    GLfloat offsetN[] = {
        x0N, y0N, 0,
        x0N, y1N, 0,
        x1N, y0N, 0,
        x1N, y1N, 0
    };
    [self.triangleShader addTriangleStrip:posL offset:offsetN numVertices:4 color:color];
}

-(void) addLineWithX0L:(float)x0L
                   x0N:(float)x0N
                   x1L:(float)x1L
                   x1N:(float)x1N
                   y0L:(float)y0L
                   y0N:(float)y0N
                   y1L:(float)y1L
                   y1N:(float)y1N
                 color:(Color)color{
    GLfloat posL[] = {
        x0L, y0L,
        x1L, y1L
    };
    GLfloat offsetN[] = {
        x0N, y0N, 0.0,
        x1N, y1N, 0.0
    };
    [self.lineShader addLines:posL offsetN:offsetN numVertices:2 color:color];

}

- (float) getTimeFromTimeString:(NSString*)string {
    NSString *hoursString = [string substringToIndex:2];
    NSString *minsString = [string substringFromIndex:3];
    int hours = (int) [hoursString integerValue];
    int mins = (int) [minsString integerValue];
    return (hours + mins/60.0);
}

- (int) getFirstServiceExpectedAfter:(float)t forSegment:(int)j{
    SegmentInfo *segmentInfo = [self.journeyInfo objectAtIndex:j];
    NSArray *expectedStart = segmentInfo.expectedStart;
    NSArray *expectedEnd = segmentInfo.expectedEnd;
    
    
    for (int i=0; i<expectedStart.count; i++) {
        if ([self getTimeFromTimeString:[expectedStart objectAtIndex:i]] >= t) {
            
            // Check this service isn't overtaken
            BOOL isOvertaken = NO;
            for (int j=i+1; j<expectedStart.count; j++) {
                if ([self getTimeFromTimeString:[expectedEnd objectAtIndex:j]] < [self getTimeFromTimeString:[expectedEnd objectAtIndex:i]]) {
                    isOvertaken = YES;
                }
            }
            if (!isOvertaken) {
                return i;
            }
        }
    }
    return -1;
}

@end




















