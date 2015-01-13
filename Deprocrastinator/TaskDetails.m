//
//  TaskDetails.m
//  Deprocrastinator
//
//  Created by Yi-Chin Sun on 1/13/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import "TaskDetails.h"

@implementation TaskDetails

-(id)initWithProperties:(NSMutableAttributedString*)string textColor:(UIColor *)textColor isStrikethrough:(BOOL)isStrikethrough
{
    self.taskText = string;
    self.taskColor = textColor;
    self.isStrikethrough = isStrikethrough;
    return self;
}

@end
