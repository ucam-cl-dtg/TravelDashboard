//
//  SegmentInfo.m
//  TravelDashboard
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

#import "SegmentInfo.h"

@implementation SegmentInfo

-(id) initWithScheduledStart:(NSMutableArray*)scheduledStart
                scheduledEnd:(NSMutableArray*)scheduledEnd
               expectedStart:(NSMutableArray*)expectedStart
                 expectedEnd:(NSMutableArray*)expectedEnd{
    if (self = [super init]) {
        self.scheduledStart = scheduledStart;
        self.scheduledEnd = scheduledEnd;
        self.expectedStart = expectedStart;
        self.expectedEnd = expectedEnd;
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_scheduledStart forKey:@"scheduledStart"];
    [encoder encodeObject:_scheduledEnd forKey:@"scheduledEnd"];
    [encoder encodeObject:_expectedStart forKey:@"expectedStart"];
    [encoder encodeObject:_expectedEnd forKey:@"expectedEnd"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    NSMutableArray *scheduledStart = [decoder decodeObjectForKey:@"scheduledStart"];
    NSMutableArray *scheduledEnd = [decoder decodeObjectForKey:@"scheduledEnd"];
    NSMutableArray *expectedStart = [decoder decodeObjectForKey:@"expectedStart"];
    NSMutableArray *expectedEnd = [decoder decodeObjectForKey:@"expectedEnd"];
    
    return [self initWithScheduledStart:scheduledStart
                           scheduledEnd:scheduledEnd
                          expectedStart:expectedStart
                            expectedEnd:expectedEnd];
}

@end
