//
//  CustoButton.m
//  MTPv2
//
//  Created by Bogdan Covaci on 18.02.2013.
//  Copyright (c) 2013 Bogdan Covaci. All rights reserved.
//

#import "CustoButton.h"


@implementation CustoButton
@synthesize isCircle = _isCircle;

- (id)init
{
    self = [super init];
    if(self)
    {
        [self setup];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self setup];
    }
    return self;
}

- (void)dealloc
{
    if(_normalGradient) CGGradientRelease(_normalGradient);
    if(_highlightedGradient) CGGradientRelease(_highlightedGradient);
    if(_selectedGradient) CGGradientRelease(_selectedGradient);
    if(_disabledGradient) CGGradientRelease(_disabledGradient);
    if(_glossNormalGradient) CGGradientRelease(_glossNormalGradient);
    if(_glossHighlightedGradient) CGGradientRelease(_glossHighlightedGradient);
    if(_glossSelectedGradient) CGGradientRelease(_glossSelectedGradient);
    if(_glossDisabledGradient) CGGradientRelease(_glossDisabledGradient);
    if(_gradient) CGGradientRelease(_gradient);
    [_borderColor release];
    [super dealloc];
}

#pragma mark - setters
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    [self setNeedsDisplay];
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    [self setNeedsDisplay];
}

- (void)setIsCircle:(BOOL)isCircle
{
    _isCircle = isCircle;
    self.layer.shadowPath = _isCircle ? [UIBezierPath bezierPathWithOvalInRect:self.bounds].CGPath : [UIBezierPath bezierPathWithRect:self.bounds].CGPath;

    [self setNeedsDisplay];
}

#pragma mark - internals
- (void)sizeToFit
{
    [super sizeToFit];
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
    [self setNeedsDisplay];
}

- (void)setup
{
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected | UIControlStateHighlighted];
    
//    self.layer.shadowColor = [UIColor colorWithWhite:0 alpha:1].CGColor;
//    self.layer.shadowOffset = CGSizeMake(0, 0);
//    self.layer.shadowOpacity = 0.4;
//    self.layer.shadowRadius = 6;
//    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;

    _borderColor = [[UIColor whiteColor] retain];
    _isCircle = NO;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat gradientLocations[] = {0.0, 1.0};
    
    NSArray* normalGradientColors = [NSArray arrayWithObjects:
                                     (id)[UIColor colorWithRed:0.153 green:0.345 blue:0.624 alpha:1].CGColor,
                                     (id)[UIColor colorWithRed:0.153 green:0.345 blue:0.624 alpha:0].CGColor, nil];
    NSArray* highlightedGradientColors = [NSArray arrayWithObjects:
                                          (id)[UIColor colorWithRed:0.000 green:0.596 blue:0.839 alpha:1].CGColor,
                                          (id)[UIColor colorWithRed:0.000 green:0.596 blue:0.839 alpha:1].CGColor, nil];
    NSArray* selectedGradientColors = [NSArray arrayWithObjects:
                                       (id)[UIColor colorWithRed:1.000 green:0.573 blue:0.106 alpha:1].CGColor,
                                       (id)[UIColor colorWithRed:0.796 green:0.420 blue:0.078 alpha:1].CGColor, nil];
    NSArray* disabledGradientColors = [NSArray arrayWithObjects:
                                       (id)[UIColor colorWithRed:0.745 green:0.749 blue:0.757 alpha:1].CGColor,
                                       (id)[UIColor colorWithRed:0.745 green:0.749 blue:0.757 alpha:1].CGColor, nil];
    NSArray* glossNormalGradientColors = [NSArray arrayWithObjects:
                                          (id)[UIColor colorWithRed:0.000 green:0.620 blue:0.851 alpha:0].CGColor,
                                          (id)[UIColor colorWithRed:0.100 green:0.720 blue:0.951 alpha:0.6].CGColor, nil];
    NSArray* glossHighlightedGradientColors = [NSArray arrayWithObjects:
                                               (id)[UIColor colorWithRed:0.690 green:0.931 blue:0.949 alpha:0].CGColor,
                                               (id)[UIColor colorWithRed:0.790 green:0.931 blue:0.949 alpha:0.6].CGColor, nil];
    NSArray* glossSelectedGradientColors = [NSArray arrayWithObjects:
                                            (id)[UIColor colorWithRed:0.992 green:0.976 blue:0.604 alpha:0].CGColor,
                                            (id)[UIColor colorWithRed:0.992 green:0.976 blue:0.904 alpha:0.6].CGColor, nil];
    NSArray* glossDisabledGradientColors = [NSArray arrayWithObjects:
                                            (id)[UIColor colorWithWhite:1 alpha:0].CGColor,
                                            (id)[UIColor colorWithWhite:1 alpha:0.8].CGColor, nil];
    
    _normalGradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)normalGradientColors, gradientLocations);
    _highlightedGradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)highlightedGradientColors, gradientLocations);
    _selectedGradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)selectedGradientColors, gradientLocations);
    _disabledGradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)disabledGradientColors, gradientLocations);
    _glossNormalGradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)glossNormalGradientColors, gradientLocations);
    _glossHighlightedGradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)glossHighlightedGradientColors, gradientLocations);
    _glossSelectedGradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)glossSelectedGradientColors, gradientLocations);
    _glossDisabledGradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)glossDisabledGradientColors, gradientLocations);
    CGColorSpaceRelease(colorSpace);
    
    [self setNeedsDisplay];
}

- (void)setGradientArray:(NSArray *)gradientArray
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat gradientLocations[] = {0.0, 1.0};
    _gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef)gradientArray, gradientLocations);
    CGColorSpaceRelease(colorSpace);

    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGRect roundedRect = CGRectMake(0.5, 0.5, rect.size.width-1.0, rect.size.height-1.0);
    CGRect contentGradientRect = rect;//CGRectInset(roundedRect, 3, 3);
    UIBezierPath *path = nil;

    CGContextSaveGState(context);
//    path = _isCircle ? [UIBezierPath bezierPathWithOvalInRect:roundedRect] : [UIBezierPath bezierPathWithRoundedRect:roundedRect cornerRadius:7];
//    [path addClip];
//    [_borderColor set];
//    CGContextFillRect(context, rect);
    CGContextRestoreGState(context);
    
    CGContextSaveGState(context);
    path = _isCircle ? [UIBezierPath bezierPathWithOvalInRect:contentGradientRect] : [UIBezierPath bezierPathWithRoundedRect:contentGradientRect cornerRadius:0];
    [path addClip];
    CGContextDrawLinearGradient(context, _gradient, CGPointMake(0, 0), CGPointMake(0, rect.size.height), 0);
    CGContextRestoreGState(context);
    
//    CGRect glossOvalRect = CGRectMake(-roundedRect.size.width / 4, -roundedRect.size.height / 2, roundedRect.size.width / 4 * 6, roundedRect.size.height / 20 * 21);
//    CGRect glossRect = CGRectInset(contentGradientRect, 2, 2);
//    glossRect.origin.y += glossRect.size.height / 10;
//
//    CGContextSaveGState(context);
//    path = [UIBezierPath bezierPathWithOvalInRect:glossOvalRect];
//    [path addClip];
//    path = _isCircle ? [UIBezierPath bezierPathWithOvalInRect:glossRect] : [UIBezierPath bezierPathWithRect:glossRect];
//    [path addClip];
//    if(self.enabled)
//    {
//        if(self.highlighted)
//        {
//            CGContextDrawLinearGradient(context, _glossHighlightedGradient, glossRect.origin, CGPointMake(glossRect.origin.x, glossRect.size.height), 0);
//        }else if(self.selected)
//        {
//            CGContextDrawLinearGradient(context, _glossSelectedGradient, glossRect.origin, CGPointMake(glossRect.origin.x, glossRect.size.height), 0);
//        }else
//        {
//            CGContextDrawLinearGradient(context, _glossNormalGradient, glossRect.origin, CGPointMake(glossRect.origin.x, glossRect.size.height), 0);
//        }
//    }else
//    {
//        CGContextDrawLinearGradient(context, _glossDisabledGradient, glossRect.origin, CGPointMake(glossRect.origin.x, glossRect.size.height), 0);
//    }
//    CGContextRestoreGState(context);
}
@end
