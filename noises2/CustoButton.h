//
//  CustoButton.h
//  MTPv2
//
//  Created by Bogdan Covaci on 18.02.2013.
//  Copyright (c) 2013 Bogdan Covaci. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustoButton : UIButton
{
    CGGradientRef _normalGradient;
    CGGradientRef _highlightedGradient;
    CGGradientRef _selectedGradient;
    CGGradientRef _disabledGradient;
    CGGradientRef _glossNormalGradient;
    CGGradientRef _glossHighlightedGradient;
    CGGradientRef _glossSelectedGradient;
    CGGradientRef _glossDisabledGradient;
    CGGradientRef _gradient;
    
    UIColor *_borderColor;
    
    BOOL _isCircle;
}

@property (nonatomic, assign) BOOL isCircle;
@property (nonatomic, retain) NSArray *gradientArray;
@end
