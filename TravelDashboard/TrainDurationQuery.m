//
//  TrainDurationQuery.m
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

#import "TrainDurationQuery.h"

@implementation TrainDurationQuery{
    int _index;
}

-(void) makeQueryWithIndex:(int)index {
    _index = index;
    
    // Get train timetable data.
    NSString *apiKey = @"43a5bd686e36485e256138a13aee684a";
    NSString *appId = @"56f07822";
    NSString *requestString = [NSString stringWithFormat:@"http://transportapi.com/v3/uk/train/service/%@/%@/%@/%@/timetable.json?api_key=%@&app_id=%@&stationcode=%@",
                               self.service, self.startStation, self.date, self.time, apiKey, appId, self.startStation];
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
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:self.responseData
                          options:kNilOptions
                          error:&error];
    NSArray* stops = [json objectForKey:@"stops"];
    NSLog(@"Got %lu stops", (unsigned long) stops.count);
    if (stops.count == 0) {
        [self.delegate trainDurationQueryFailedWithIndex:_index];
    } else {
        NSString *arrivalTime = nil;
        for (int i=0; i<stops.count; i++) {
            NSString *stopName = [[stops objectAtIndex:i] objectForKey:@"station_code"];
            if (stopName && [self.endStation caseInsensitiveCompare:stopName] == NSOrderedSame) {
                arrivalTime = [[stops objectAtIndex:i] objectForKey:@"aimed_arrival_time"];
                NSLog(@"Matched station %i.", i);
            }
        }
        [self.delegate trainDurationQueryWithIndex:_index returnedArrivalTime:arrivalTime];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    [self.delegate trainDurationQueryFailedWithIndex:_index];
}


@end
