//
//  TaskDetails.h
//  Deprocrastinator
//
//  Created by Yi-Chin Sun on 1/13/15.
//  Copyright (c) 2015 MobileMakers. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TaskDetails : NSObject
@property NSMutableAttributedString *taskText;
@property UIColor * taskColor;
@property BOOL isStrikethrough;

-(id)initWithProperties:(NSMutableAttributedString*)string textColor:(UIColor *)textColor isStrikethrough:(BOOL)isStrikethrough;

@end
