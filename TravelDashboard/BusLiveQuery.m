//
//  BusLiveQuery.m
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

#import "BusLiveQuery.h"

@implementation BusLiveQuery{
    int _index;
    int _numAttempts;
}

-(id) init{
    if (self = [super init]) {
        _numAttempts = 0;
    }
    return self;
}

-(void) makeQueryWithIndex:(int)index {
    _index = index;
    
    NSString *requestString = [NSString stringWithFormat:@"http://api.stride-project.com/transportapi/7c60e7f4-20ff-11e3-857c-fcfb53959281/bus/stop/%@/live", self.busStop];
    NSLog(@"%@", requestString);
    NSString *apiKey = @"c0aca0e4-9278-4b22-a22d-570c6f28937c";
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:requestString]];
    [req setValue:apiKey forHTTPHeaderField:@"x-api-key"];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
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
    NSDictionary* departuresAll = [json objectForKey:@"departures"];
    NSRange range = [self.service rangeOfString:@":"];
    NSString *serviceNumber = [self.service substringToIndex:range.location];
    NSArray* departures = [departuresAll objectForKey:serviceNumber];
    NSLog(@"Got %lu departures.", (unsigned long)departures.count);
    if (departures.count == 0)
    {
        if (_numAttempts == 5) {
            NSLog(@"Outright fail.");
            [self.delegate busLiveQueryFailedWithIndex:_index];
        } else {
            _numAttempts++;
            NSLog(@"Failed, attempt number %i", _numAttempts);
            [self makeQueryWithIndex:_index];
        }
    } else {
        NSMutableArray *aimed = [[NSMutableArray alloc] init];
        NSMutableArray *best = [[NSMutableArray alloc] init];
        for (int i=0; i<departures.count; i++) {
            [aimed addObject:[[departures objectAtIndex:i] objectForKey:@"aimed_departure_time"]];
            [best addObject:[[departures objectAtIndex:i] objectForKey:@"best_departure_estimate"]];
        }
        [self.delegate busLiveQueryWithIndex:_index returnedTimetableTimes:aimed liveTimes:best];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    [self.delegate busLiveQueryFailedWithIndex:_index];
}

@end
