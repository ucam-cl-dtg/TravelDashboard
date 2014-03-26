//
//  ViewController.h
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

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface DashboardViewController : GLKViewController
@property (nonatomic, strong) NSArray *journeySpec;
@property (nonatomic, strong) NSArray *journeyInfo;
@property (nonatomic, assign) BOOL mcEnabled;

- (void) applicationWillResignActive;
- (void) applicationDidBecomeActive;
- (id) initWithJourneySpec:(NSArray*) journeySpec
               journeyInfo:(NSArray*) journeyInfo;
- (id) initWithJourneySpec:(NSArray*) journeySpec
               journeyInfo:(NSArray*) journeyInfo
                 mcEnabled:(BOOL) mcEnabled;

@end
