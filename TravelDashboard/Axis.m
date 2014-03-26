//
//  Axis.m
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

#import "Axis.h"

@interface Axis () {
    float _firstTouchValue;
    float _secondTouchValue;
    NSTimeInterval _firstTouchTimestamp;
    NSTimeInterval _secondTouchTimestamp;
    float _firstTouchPos;
    float _secondTouchPos;
    float _firstTouchDpdt;
    float _secondTouchDpdt;
    float _dvdt;
    BOOL _firstTouch;
    BOOL _secondTouch;
}
- (float) getValueForPos: (float) pos;
@end

@implementation Axis

- (id) init {
    if ([super init]) {
        _dvdt = 0.0;
        _firstTouch = NO;
        _secondTouch = NO;
        _axisLocked = NO;
    }
    return self;
}

- (void) firstTouchBeganAtPos:(float)pos timestamp:(NSTimeInterval)timestamp{
    _firstTouchValue = [self getValueForPos:pos];
    _firstTouchPos = pos;
    _firstTouchTimestamp = timestamp;
    _firstTouch = YES;
}

- (void) secondTouchBeganAtPos:(float)pos timestamp:(NSTimeInterval)timestamp{
    _secondTouchValue = [self getValueForPos:pos];
    _secondTouchPos = pos;
    _secondTouchTimestamp = timestamp;
    _secondTouch = YES;
}

- (void) firstTouchMovedToPos:(float)pos timestamp:(NSTimeInterval)timestamp{
    float dp = pos - _firstTouchPos;
    float dt = timestamp - _firstTouchTimestamp;
    _firstTouchDpdt = dp/dt;
    _firstTouchPos = pos;
}

- (void) secondTouchMovedToPos:(float)pos timestamp:(NSTimeInterval)timestamp{
    float dp = pos - _secondTouchPos;
    float dt = timestamp - _secondTouchTimestamp;
    _secondTouchDpdt = dp/dt;
    _secondTouchPos = pos;
}

- (void) firstTouchEndedTimestamp:(NSTimeInterval)timestamp{
    float dt = timestamp - _firstTouchTimestamp;
    if (dt > 0.3) {
        _firstTouchDpdt = 0.0;
    }
    _firstTouch = NO;
    if (!_secondTouch) {
        _dvdt = _firstTouchDpdt*(_maxValue - _minValue);
    }
}

- (void) secondTouchEndedTimestamp:(NSTimeInterval)timestamp{
    float dt = timestamp - _secondTouchTimestamp;
    if (dt > 0.3) {
        _secondTouchDpdt = 0.0;
    }
    _secondTouch = NO;
    if (!_firstTouch) {
        _dvdt = _secondTouchDpdt*(_maxValue - _minValue);
    }
}

- (void) allTouchesEnded{
    _firstTouch = NO;
    _secondTouch = NO;
}

- (void) updateWithTimestep:(float)dt{

    // Check if the axis is locked
    if (_axisLocked) {
        return;
    }
    
    // Handle two-touch controls.
    float valueRange = _maxValue - _minValue;
    if (_firstTouch & _secondTouch) {
        if (fabsf(_secondTouchPos - _firstTouchPos) > 0.001) {
            valueRange = (_secondTouchValue - _firstTouchValue) / (_secondTouchPos - _firstTouchPos);
        } else {
            valueRange = fabsf((_secondTouchValue - _firstTouchValue) / 0.001);
        }
        if (valueRange < 0) {
            valueRange = fabsf((_secondTouchValue - _firstTouchValue) / 0.001);
        }
        float anchorValue = (_firstTouchValue + _secondTouchValue) / 2;
        float anchorPos = (_firstTouchPos + _secondTouchPos) / 2;
        _minValue = anchorValue - anchorPos*valueRange;
        _maxValue = _minValue + valueRange;
    }
    
    // Handle one-touch controls.
    if (_firstTouch & !_secondTouch) {
        _minValue = _firstTouchValue - _firstTouchPos*valueRange;
        _maxValue = _minValue + valueRange;
    }
    if (_secondTouch & !_firstTouch) {
        _minValue = _secondTouchValue - _secondTouchPos*valueRange;
        _maxValue = _minValue + valueRange;
    }
    
    // Handle zero-touch dynamics
    if (!_firstTouch & !_secondTouch) {
        
        // Inertia
        float deltaValue = -_dvdt*dt;
        _minValue += deltaValue;
        _maxValue += deltaValue;
        
        // Damping
        _dvdt *= expf(-10.0*dt);
        
    }
    
    // Max zoom bounds
    if (valueRange < _minRangeBound) {
        float p = (valueRange/_minRangeBound) - 1.0;
        float q = p / (1 + fabsf(2*p));
        valueRange = (q + 1)*_minRangeBound;
        _minValue = 0.5*(_minValue+_maxValue) - 0.5*valueRange;
        _maxValue = _minValue + valueRange;
    }
    
    // Endstop bounds
    if (valueRange > (_maxBound - _minBound)) {
        if (_minValue < _minBound) {
            float p = (_minBound - _minValue)/(_maxBound - _minBound);
            float q = (p / (1 + 2*p))*0.95;
            _minValue = _minBound - q*(_maxBound - _minBound);
        }
        if (_maxValue > _maxBound) {
            float p = (_maxValue - _maxBound)/(_maxBound - _minBound);
            float q = (p / (1 + 2*p))*0.95;
            _maxValue = q*(_maxBound - _minBound) + _maxBound;
        }
    } else {
        if (_minValue < _minBound) {
            float p = (_minBound - _minValue)/valueRange;
            float q = (p / (1 + 2*p))*0.95;
            _minValue = _minBound - q*valueRange;
            _maxValue = _minValue + valueRange;
        }
        if (_maxValue > _maxBound) {
            float p = (_maxValue - _maxBound)/valueRange;
            float q = (p / (1 + 2*p))*0.95;
            _maxValue = q*valueRange + _maxBound;
            _minValue = _maxValue-valueRange;
        }
    }
}

- (float) getValueForPos:(float)pos {
    return _minValue + pos*(_maxValue-_minValue);
}

@end


