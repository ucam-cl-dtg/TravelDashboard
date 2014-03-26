//
//  ViewController.m
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

#import "DashboardViewController.h"
#import "TriangleShader.h"
#import "TextureShader.h"
#import "LineShader.h"
#import "IconHandler.h"
#import "TextHandler.h"
#import "SceneHandler.h"
#import "Axis.h"

@interface DashboardViewController (){
    GLfloat _tmTToC[16];
    GLfloat _tmFToC[16];
    GLfloat _tmNToC[9];
    GLfloat _animationPhase;
    GLfloat _startTime;
    UITouch *_firstTouch;
    UITouch *_secondTouch;
}

@property (strong, nonatomic) EAGLContext *context;
@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) TriangleShader *triangleShader;
@property (strong, nonatomic) TextureShader *textureShader;
@property (strong, nonatomic) LineShader *lineShader;
@property (strong, nonatomic) PointShader *pointShader;
@property (strong, nonatomic) IconHandler *iconHandler;
@property (strong, nonatomic) TextHandler *textHandler;
@property (strong, nonatomic) SceneHandler *sceneHandler;
@property (strong, nonatomic) Axis *xAxis;
@property (strong, nonatomic) Axis *yAxis;

- (void)setupGL;
- (void)tearDownGL;

@end

@implementation DashboardViewController

- (id) initWithJourneySpec:(NSArray*) journeySpec
               journeyInfo:(NSArray*) journeyInfo{
    if (self = [super init]){
        self.journeySpec = journeySpec;
        self.journeyInfo = journeyInfo;
        self.mcEnabled = NO;
    }
    return self;
}

- (id) initWithJourneySpec:(NSArray *)journeySpec
               journeyInfo:(NSArray *)journeyInfo
                 mcEnabled:(BOOL)mcEnabled {
    self = [self initWithJourneySpec:journeySpec journeyInfo:journeyInfo];
    self.mcEnabled = mcEnabled;
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    // Set up OpenGL
    self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!self.context) {
        NSLog(@"Failed to create ES context");
    }
    self.preferredFramesPerSecond = 60;
    GLKView *view = (GLKView *)self.view;
    view.context = self.context;
    view.drawableDepthFormat = GLKViewDrawableDepthFormatNone;
    view.multipleTouchEnabled = YES;
    [self setupGL];
    
    // Set up touch tracking
    _firstTouch = nil;
    _secondTouch = nil;
    
    // Set up the x axis
    self.xAxis = [[Axis alloc] init];
    self.xAxis.minBound = 0;
    self.xAxis.maxBound = 1;
    self.xAxis.minRangeBound = 1;
    self.xAxis.minValue = 0;
    self.xAxis.maxValue = 1;
    self.xAxis.axisLocked = YES;

    // Set up the y axis
    self.yAxis = [[Axis alloc] init];
    self.yAxis.minBound = 5;
    self.yAxis.maxBound = 23;
    self.yAxis.minRangeBound = 0.5;
    NSDate *now = [NSDate date];
    float t = [self hoursSinceMidnight:now];
    self.yAxis.minValue = t - 0.9;
    self.yAxis.maxValue = t + 2.1;
    self.yAxis.axisLocked = NO;
    
    // Set up animation
    _startTime = 12.0;
    _animationPhase = 0.0;
    
}

- (void)dealloc
{
    [self tearDownGL];
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

    // Dispose of any resources that can be recreated.
}

- (void)setupGL
{
    // Set context
    [EAGLContext setCurrentContext:self.context];
    
    // Setup shaders
    self.triangleShader = [[TriangleShader alloc] init];
    self.textureShader = [[TextureShader alloc] init];
    self.lineShader = [[LineShader alloc] init];
    self.pointShader = [[PointShader alloc] init];

    // Set up icon and text handlers
    self.iconHandler = [[IconHandler alloc] initWithTextureShader:self.textureShader];
    self.textHandler = [[TextHandler alloc] initWithTextureShader:self.textureShader];
    
    
    // Set up scene handler and generate the scene
    self.sceneHandler = [[SceneHandler alloc] initWithTriangleShader:self.triangleShader
                                                          lineShader:self.lineShader
                                                         pointShader:self.pointShader
                                                         iconHandler:self.iconHandler
                                                         textHandler:self.textHandler];
    self.sceneHandler.tmTToC = _tmTToC;
    self.sceneHandler.tmFToC = _tmFToC;
    self.sceneHandler.tmNToC = _tmNToC;
    self.sceneHandler.animationPhase = &_animationPhase;
    self.sceneHandler.startTime = &_startTime;
    self.sceneHandler.journeySpec = self.journeySpec;
    self.sceneHandler.journeyInfo = self.journeyInfo;
    self.sceneHandler.mcEnabled = self.mcEnabled;
    float width = self.view.bounds.size.width;
    
    [self.sceneHandler makeSceneWithWidth:width];
    
    // Make one-off opengl calls
    glEnable(GL_BLEND);
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
  
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
    [self.triangleShader tearDownGL];
    [self.textureShader tearDownGL];
}

#pragma mark - GLKView and GLKViewController delegate methods

- (void)update
{
    [self.xAxis updateWithTimestep:self.timeSinceLastUpdate];
    [self.yAxis updateWithTimestep:self.timeSinceLastUpdate];
    _animationPhase += 0.05*self.timeSinceLastUpdate;
    if (_animationPhase >= 1.0) {
        _animationPhase -= 1.0;
    }
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    // Get current size of the view. This will depend on the device, and can
    // change dynamicly due to in-call status bar and rotation.
    float height = self.view.bounds.size.height;
    float width = self.view.bounds.size.width;
    
    // Get current axes state
    float xMid = (self.xAxis.maxValue+self.xAxis.minValue)/2.0;
    float xRange = (self.xAxis.maxValue-self.xAxis.minValue);
    float yMid = (self.yAxis.maxValue+self.yAxis.minValue)/2.0;
    float yRange = (self.yAxis.maxValue-self.yAxis.minValue);
    
    // Update the model view matrix for time (T) coordinates
    for (int i=0; i<16; i++) _tmTToC[i]=0;
    _tmTToC[0] = 2.0/xRange;
    _tmTToC[5] = -2.0/yRange;
    _tmTToC[12] = -2.0*xMid/xRange;
    _tmTToC[13] = 2.0*yMid/yRange;
    _tmTToC[15] = 1.0;
    
    // Update the model view matrix for fixed (F) coordinates
    for (int i=0; i<16; i++) _tmFToC[i]=0;
    _tmFToC[0] = 2.0/xRange;
    _tmFToC[5] = -2.0;
    _tmFToC[12] = -2.0*xMid/xRange;
    _tmFToC[13] = 1.0;
    _tmFToC[15] = 1.0;
    
    // Update the offset transform matrix
    for (int i=0; i<9; i++) _tmNToC[i]=0;
    _tmNToC[0] = 2.0/width;
    _tmNToC[4] = 2.0/height;
    _tmNToC[7] = -2.0/(yRange);
    
    // Update phases
    _startTime = self.yAxis.minValue + yRange*0.3;
    
    glClear(GL_COLOR_BUFFER_BIT);
    [self.sceneHandler draw];
   
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // Get curent view dimensions
    float height = self.view.bounds.size.height;
    float width = self.view.bounds.size.width;
    
    // For each touch
    for (UITouch *touch in touches) {
        
        // Get the normalised coordinates
        CGPoint pos = [touch locationInView:self.view];
        float x = pos.x / width;
        float y = pos.y / height;
        
        // Lock axes if needed
/*        if (_firstTouch != nil & _secondTouch == nil) {
            float xOffset = [_firstTouch locationInView:self.view].x - pos.x;
            if (fabsf(xOffset) < 50.0){
                self.xAxis.axisLocked = YES;
            } else {
                self.xAxis.axisLocked = NO;
            }
            float yOffset = [_firstTouch locationInView:self.view].y - pos.y;
            if (fabsf(yOffset) < 50.0){
                self.yAxis.axisLocked = YES;
            } else {
                self.yAxis.axisLocked = NO;
            }
        } else if (_secondTouch != nil & _firstTouch == nil) {
            float xOffset = [_secondTouch locationInView:self.view].x - pos.x;
            if (fabsf(xOffset) < 50.0){
                self.xAxis.axisLocked = YES;
            } else {
                self.xAxis.axisLocked = NO;
            }
            float yOffset = [_secondTouch locationInView:self.view].y - pos.y;
            if (fabsf(yOffset) < 50.0){
                self.yAxis.axisLocked = YES;
            } else {
                self.yAxis.axisLocked = NO;
            }
        }*/
        
        // Tell axes
        if (!_firstTouch){
            _firstTouch = touch;
            [self.xAxis firstTouchBeganAtPos:x timestamp:touch.timestamp];
            [self.yAxis firstTouchBeganAtPos:y timestamp:touch.timestamp];
        } else if (!_secondTouch) {
            _secondTouch = touch;
            [self.xAxis secondTouchBeganAtPos:x timestamp:touch.timestamp];
            [self.yAxis secondTouchBeganAtPos:y timestamp:touch.timestamp];
        }
        
        
    }
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // Get curent view dimensions
    float height = self.view.bounds.size.height;
    float width = self.view.bounds.size.width;
    
    // For each touch
    for (UITouch *touch in touches) {

        // Get the normalised coordinates
        CGPoint pos = [touch locationInView:self.view];
        float x = pos.x / width;
        float y = pos.y / height;
        
        // Tell axes
        if (touch == _firstTouch){
            [self.xAxis firstTouchMovedToPos:x timestamp:touch.timestamp];
            [self.yAxis firstTouchMovedToPos:y timestamp:touch.timestamp];
        } else if (touch == _secondTouch) {
            [self.xAxis secondTouchMovedToPos:x timestamp:touch.timestamp];
            [self.yAxis secondTouchMovedToPos:y timestamp:touch.timestamp];
        }
        
    }

}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    // For each touch
    for (UITouch *touch in touches) {
        
        if (touch == _firstTouch) {
            _firstTouch = nil;
            [self.xAxis firstTouchEndedTimestamp:touch.timestamp];
            [self.yAxis firstTouchEndedTimestamp:touch.timestamp];
        }
        
        if (touch == _secondTouch) {
            _secondTouch = nil;
            [self.xAxis secondTouchEndedTimestamp:touch.timestamp];
            [self.yAxis secondTouchEndedTimestamp:touch.timestamp];
        }

    }
    
}

- (void) applicationWillResignActive{
    
    // Stop tracking touches
    _firstTouch = nil;
    _secondTouch = nil;
    [self.xAxis allTouchesEnded];
    [self.yAxis allTouchesEnded];
    
}

- (void) applicationDidBecomeActive{

}
/*
-(void) viewWillAppear:(BOOL)animated{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
  //  [navigationBar setAlpha:0.01];
   [navigationBar setBackgroundImage:[UIImage new]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
}

-(void) viewDidDisappear:(BOOL)animated{
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [navigationBar setAlpha:1.0];
   [navigationBar setBackgroundImage:nil
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar removeB]
    
    [navigationBar setShadowImage:nil];
}
*/

- (float)hoursSinceMidnight:(NSDate *)date
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned unitFlags =  NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSDateComponents *components = [gregorian components:unitFlags fromDate:date];
    
    return [components hour] + [components minute]/60.0;
}

@end
