//
//  TrainQuery.m
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

#import "TrainQuery.h"
#import "SegmentInfo.h"
#import "TrainDurationQuery.h"

@interface TrainQuery()
@property (nonatomic, strong) SegmentInfo *segmentInfo;
@end

@implementation TrainQuery{
    int _index;
    int _numQueriesPending;
}

-(void) makeQueryWithIndex:(int)index {
    _index = index;
    
    // Get train timetable data.
    NSString *apiKey = @"43a5bd686e36485e256138a13aee684a";
    NSString *appId = @"56f07822";
    NSString *requestString = [NSString stringWithFormat:@"https://transportapi.com/v3/uk/train/station/%@/timetable.json?limit=10&api_key=%@&app_id=%@&calling_at=%@",
                               self.journeySegment.startPoint, apiKey, appId, self.journeySegment.endPoint];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
#pragma unused(conn)
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    NSLog(@"Got data, length %lu bytes.", (unsigned long)self.responseData.length);
    
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:self.responseData
                          options:kNilOptions
                          error:&error];
    NSString *date = [json objectForKey:@"date"];
    NSArray* departures = [[json objectForKey:@"departures"] objectForKey:@"all"];
    NSLog(@"Got %lu departures.", (unsigned long)departures.count);
    
    if (departures.count == 0){
        
        [self.delegate segmentQueryFailedWithIndex:_index];
    
    } else {
    
        NSMutableArray *service = [[NSMutableArray alloc] init];
        NSMutableArray *dep = [[NSMutableArray alloc] init];
        NSMutableArray *arr = [[NSMutableArray alloc] init];
        for (int i=0; i<departures.count; i++) {
            NSLog(@"%@", [[departures objectAtIndex:i] objectForKey:@"aimed_departure_time"]);
            [service addObject:[[departures objectAtIndex:i] objectForKey:@"service"]];
            [dep addObject:[[departures objectAtIndex:i] objectForKey:@"aimed_departure_time"]];
            [arr addObject:[NSString stringWithFormat:@""]];
        }
        self.segmentInfo = [[SegmentInfo alloc] init];
        [self.segmentInfo setScheduledStart:dep];
        [self.segmentInfo setScheduledEnd:arr];
        [self.segmentInfo setExpectedStart:dep];
        [self.segmentInfo setExpectedEnd:arr];
        
        self.durationQueries = [[NSMutableArray alloc] init];
        _numQueriesPending = (int) departures.count;
        for (int i=0; i<departures.count; i++) {
            TrainDurationQuery *durationQuery = [[TrainDurationQuery alloc] init];
            [self.durationQueries addObject:durationQuery];
            [durationQuery setDelegate:self];
            [durationQuery setDate:date];
            [durationQuery setTime:[dep objectAtIndex:i]];
            [durationQuery setService:[service objectAtIndex:i]];
            [durationQuery setStartStation:self.journeySegment.startPoint];
            [durationQuery setEndStation:self.journeySegment.endPoint];
            [durationQuery makeQueryWithIndex:i];
        }
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    [self.delegate segmentQueryFailedWithIndex:_index];
}

#pragma mark - TrainDurationQueryDelegate

- (void) trainDurationQueryWithIndex:(int)index returnedArrivalTime:(NSString *)arrivalTime {
    [self.segmentInfo.scheduledEnd replaceObjectAtIndex:index withObject:arrivalTime];
    [self.segmentInfo.expectedEnd replaceObjectAtIndex:index withObject:arrivalTime];
    _numQueriesPending--;
    
    if (_numQueriesPending == 0) {
        [self.delegate segmentQueryWithIndex:_index returnedInfo:self.segmentInfo];
    }
}

- (void) trainDurationQueryFailedWithIndex:(int)index {
    [self.delegate segmentQueryFailedWithIndex:index];
}

@end
