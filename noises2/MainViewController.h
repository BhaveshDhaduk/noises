//
//  MainViewController.h
//  noises2
//
//  Created by Bogdan Covaci on 16.11.2013.
//  Copyright (c) 2013 Bogdan Covaci. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TheAmazingAudioEngine.h"
#import "NVDSP.h"
#import "NVPeakingEQFilter.h"
#import "CustoButton.h"


@interface MainViewController : UIViewController <UIAlertViewDelegate>
{
}
- (IBAction)volumeButtonTapped:(id)sender;
- (IBAction)eqButtonTapped:(id)sender;
- (IBAction)settingsButtonTapped:(id)sender;
- (IBAction)volSliderChanged:(UISlider *)sender;
- (IBAction)panSliderChanged:(UISlider *)sender;
- (IBAction)restorePurchasesButtonTapped:(id)sender;

@property (nonatomic, retain) AEAudioController *audioController;
@property (retain, nonatomic) IBOutlet UIView *contentView;
@property (retain, nonatomic) IBOutlet UIView *topView;
@property (retain, nonatomic) IBOutlet UIView *topContentView;
@property (retain, nonatomic) IBOutlet UIView *bottomView;
@property (retain, nonatomic) IBOutlet UIView *bottomContentView;
@property (retain, nonatomic) IBOutlet UIButton *volumeButton;
@property (retain, nonatomic) IBOutlet UIButton *eqButton;
@property (retain, nonatomic) IBOutlet UIButton *settingsButton;
@property (retain, nonatomic) IBOutlet UIView *eqView;
@property (retain, nonatomic) IBOutlet UIView *volumeView;
@property (retain, nonatomic) IBOutlet UIView *settingsView;
@property (retain, nonatomic) IBOutlet UILabel *volLeftLabel;
@property (retain, nonatomic) IBOutlet UILabel *volRightLabel;
@property (retain, nonatomic) IBOutlet UILabel *panLeftLabel;
@property (retain, nonatomic) IBOutlet UILabel *panRightLabel;
@property (retain, nonatomic) IBOutlet UISlider *volSlider;
@property (retain, nonatomic) IBOutlet UISlider *panSlider;
@property (retain, nonatomic) IBOutlet UIButton *restorePurchasesButton;

@end
