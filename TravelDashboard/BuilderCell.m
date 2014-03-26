//
//  BuilderCell.m
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

#import <QuartzCore/QuartzCore.h>
#import "BuilderCell.h"

@implementation BuilderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        // Prevent selection
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // Initialization code for each stage
        // Add button
        self.addButton =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.addButton setFrame:CGRectMake(0,0,40,40)];
        [self.addButton setTitle:@"+" forState:UIControlStateNormal];
        [self.addButton addTarget:self action:@selector(flipButton) forControlEvents:UIControlEventTouchUpInside];
        [self.addButton setTitleColor:[UIColor colorWithRed:1.0 green:59.0/255.0 blue:48.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self.addButton setTitleColor:[UIColor colorWithRed:1.0 green:59.0/255.0 blue:48.0/255.0 alpha:1.0] forState:UIControlStateSelected];
        self.addButton.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
        self.addButton.layer.borderWidth = 1.0f;
        self.addButton.layer.cornerRadius = 20.0f;
        
        self.addButton.backgroundColor = [UIColor whiteColor];
        CAShapeLayer* buttonMask = [[CAShapeLayer alloc] init];
        buttonMask.frame = CGRectMake(0, 0, self.addButton.bounds.size.width, self.addButton.bounds.size.height);
        buttonMask.path = [[UIBezierPath bezierPathWithRoundedRect:buttonMask.frame cornerRadius:20] CGPath];
        self.addButton.layer.mask = buttonMask;
        
        
        [self.contentView addSubview:self.addButton];
        float width =  self.bounds.size.width;
        self.addButton.center = CGPointMake(width/2.0, 22);
        
        // Mode selector
        //NSArray *itemArray = [NSArray arrayWithObjects: @"Car", @"Bus", @"Train", @"Walk", nil];
        NSArray *itemArray = [NSArray arrayWithObjects:
                              [UIImage imageNamed:@"Car.png"],
                              [UIImage imageNamed:@"Bus.png"],
                              [UIImage imageNamed:@"Train.png"],
                              [UIImage imageNamed:@"Walk.png"],
                              nil];

        self.modeSelector = [[UISegmentedControl alloc] initWithItems:itemArray];
        self.modeSelector.frame = CGRectMake(0, 0, 240 + 5, 40 + 2);
        self.modeSelector.selectedSegmentIndex = -1;
        [self.modeSelector addTarget:self
                              action:@selector(modeSelected)
                    forControlEvents:UIControlEventValueChanged];
        self.modeSelector.center = CGPointMake(width/2.0, 22);
        [self.modeSelector setHidden:YES];
        self.modeSelector.backgroundColor = [UIColor whiteColor];
        self.modeSelector.tintColor = [UIColor colorWithRed:1.0 green:59.0/255.0 blue:48.0/255.0 alpha:1.0];
        CAShapeLayer* mask = [[CAShapeLayer alloc] init];
        mask.frame = CGRectMake(0, 0, self.modeSelector.bounds.size.width-2, self.modeSelector.bounds.size.height);
        mask.path = [[UIBezierPath bezierPathWithRoundedRect:mask.frame cornerRadius:4] CGPath];
        self.modeSelector.layer.mask = mask;
        [self.contentView addSubview:self.modeSelector];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) flipButton
{
    [self.modeSelector setSelectedSegmentIndex:-1];
    [UIView transitionWithView:self.contentView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [self.addButton setHidden:YES];
                        [self.modeSelector setHidden:NO];
                    } completion:nil];
}

- (void) modeSelected
{
    [self.delegate journeyMode:(JourneyMode)self.modeSelector.selectedSegmentIndex selectedInCell:self];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.delegate = nil;
    [self.addButton setHidden:NO];
    [self.modeSelector setHidden:YES];
    [self.modeSelector setSelectedSegmentIndex:-1];
}

@end
