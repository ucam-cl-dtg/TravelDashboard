//
//  TextCell.m
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

#import "TextCell.h"

@implementation TextCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Add a text field
        CGRect subViewFrame = self.contentView.frame;
        subViewFrame.origin.x += 10;
        subViewFrame.size.width -= 20;
        subViewFrame.origin.y += 12;
        self.textField = [[UITextField  alloc] initWithFrame:subViewFrame];
        self.textField.font = [UIFont systemFontOfSize:17];
        self.textField.backgroundColor = [UIColor clearColor];
        UIColor *blueTextColor = [UIColor colorWithRed:56.0f/255.0f green:84.0f/255.0f blue:135.0f/255.0f alpha:1.0f];
        self.textField.textColor = blueTextColor;
        self.textField.delegate = self;
        self.textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        self.textField.spellCheckingType = UITextSpellCheckingTypeNo;
        self.textField.returnKeyType = UIReturnKeyDone;
        [self.contentView addSubview:self.textField];
        
        // Add a label to give a hint if the length of the text field gets to zero
        subViewFrame.origin.y -= 12;
        self.hintLabel = [[UILabel alloc] initWithFrame:subViewFrame];
        self.hintLabel.font = [UIFont systemFontOfSize:17];
        self.hintLabel.backgroundColor = [UIColor clearColor];
        self.hintLabel.highlightedTextColor = [UIColor whiteColor];
        UIColor *greyTextColor = [UIColor colorWithRed:180.0f/255.0f green:180.0f/255.0f blue:180.0f/255.0f alpha:1.0f];
        self.hintLabel.textColor = greyTextColor;
        self.hintLabel.hidden = NO;
        [self.contentView addSubview:self.hintLabel];
        
        // Add a faint line at the bottom, so the user can tell this is an editable field
        CGFloat height = self.contentView.bounds.size.height;
        CGFloat width = self.contentView.bounds.size.width;
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, height-1, width, 1)];
        line.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        [self.contentView addSubview:line];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    // Dismiss the keyboard
    [textField resignFirstResponder];
    
    return YES;
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [self.delegate text:self.textField.text setInCell:self];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    // Work out the new text string
    NSString* newString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    // Work out if the hint should be hidden or not
    if (newString.length == 0) {
        self.hintLabel.hidden = NO;
    } else {
        self.hintLabel.hidden = YES;
    }
    
    return YES;
    
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.textField setText:@""];
    [self.hintLabel setHidden:NO];
}

@end
