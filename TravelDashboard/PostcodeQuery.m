//
//  PostcodeQuery.m
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

#import "PostcodeQuery.h"

@implementation PostcodeQuery {
    int _index;
}

- (void) makeQueryWithIndex:(int)index {
    _index = index;
    NSLog(@"Postcode query");
    
    // Format the postcode
    NSString *formattedPostcode = [self.postcode stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", formattedPostcode];
    NSLog(@"%@", req);
    NSData *response = [NSData dataWithContentsOfURL:[NSURL URLWithString:req]];
    
    
    NSLog(@"%lu", (unsigned long)response.length);
    NSError *error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:response
                          options:kNilOptions
                          error:&error];
    NSArray *results = [json objectForKey:@"results"];
    if (results.count ==0 ) {
         [self.delegate postcodeQueryFailedWithIndex:_index];
    } else {
        NSDictionary *firstResult = [results objectAtIndex:0];
        NSString *lat = [[[firstResult objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
        NSString *lon = [[[firstResult objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
        NSLog(@"%@, %@", lat, lon);
        [self.delegate postcodeQueryWithIndex:_index returnedLat:lat lon:lon];
    }
}

@end
