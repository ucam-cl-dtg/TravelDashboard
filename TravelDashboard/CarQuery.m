//
//  CarQuery.m
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

#import "CarQuery.h"
#import "SegmentInfo.h"

@implementation CarQuery{
    int _index;
    int _numQueriesPending;
}

- (void) makeQueryWithIndex:(int)index {
    _index = index;
    NSLog(@"Car query");

    // Look up postcode locations
    _numQueriesPending = 2;
    PostcodeQuery *startQuery = [[PostcodeQuery alloc] init];
    [startQuery setDelegate:self];
    [startQuery setPostcode:self.journeySegment.startPoint];
    [startQuery makeQueryWithIndex:0];
    PostcodeQuery *endQuery = [[PostcodeQuery alloc] init];
    [endQuery setDelegate:self];
    [endQuery setPostcode:self.journeySegment.endPoint];
    [endQuery makeQueryWithIndex:1];

}

#pragma mark PostcodeQueryDelegate

-(void) postcodeQueryFailedWithIndex:(int)index {
    [self.delegate segmentQueryFailedWithIndex:index];
}

- (void) postcodeQueryWithIndex:(int)index returnedLat:(NSString *)lat lon:(NSString *)lon {
    if (index==0) {
        self.startLat = lat;
        self.startLon = lon;
    } else {
        self.endLat = lat;
        self.endLon = lon;
    }
    _numQueriesPending--;
    if (_numQueriesPending==0) {
        [self makeJourneyTimeQuery];
    }
}

- (void) makeJourneyTimeQuery {
    // Get the current date and time
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"yyyy-MM-ddTHH:mm:ss"];
    NSString *dateTimeString = [dateFormat stringFromDate:date];

    // Do the JUMPA query
    NSString *req = [NSString stringWithFormat:@"http://sandra.zion.bt.co.uk:8087/jtime?start_lat=%@&start_lon=%@&end_lat=%@&end_lon=%@&time=%@&delta=0&model=LoopModel", self.startLat, self.startLon, self.endLat, self.endLon, dateTimeString];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:req]];
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
    
    // Get the current date and time
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"HH:mm"];
    NSString *nowString = [dateFormat stringFromDate:date];
    
    NSString *response = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    NSRange range = [response rangeOfString:@"time=\""];
    NSInteger idx = range.location + range.length;
    NSString *substring = [response substringFromIndex:idx];
    range = [substring rangeOfString:@"\""];
    idx = range.location;
    NSString *timeString = [substring substringToIndex:idx];
    NSLog(@"%@", timeString);
    
    // Form the output
    int t0 = [self getIntFromTimeString:nowString];
    float dur = [timeString floatValue];
    int t1 = (int) (t0 + dur);
    
    int hours0 = (int) (t0/3600);
    int mins0 = (int) ((t0 - 3600*hours0)/60);
    int hours1 = (int) (t1/3600);
    int mins1 = (int) ((t1 - 3600*hours1)/60);
    NSString *depString = [NSString stringWithFormat:@"%02i:%02i", hours0, mins0];
    NSString *arrString = [NSString stringWithFormat:@"%02i:%02i", hours1, mins1];
    NSMutableArray *dep = [NSMutableArray arrayWithObject:depString];
    NSMutableArray *arr = [NSMutableArray arrayWithObject:arrString];
    SegmentInfo *info = [[SegmentInfo alloc] init];
    [info setScheduledStart:dep];
    [info setScheduledEnd:arr];
    [info setExpectedStart:dep];
    [info setExpectedEnd:arr];
    [self.delegate segmentQueryWithIndex:_index returnedInfo:info];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    [self.delegate segmentQueryFailedWithIndex:_index];
}

- (int) getIntFromTimeString:(NSString*)string {
    NSString *hoursString = [string substringToIndex:2];
    NSString *minsString = [string substringFromIndex:3];
    int hours = (int)[hoursString integerValue];
    int mins = (int)[minsString integerValue];
    return (hours*3600 + mins*60);
}

@end
