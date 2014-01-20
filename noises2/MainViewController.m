//
//  MainViewController.m
//  noises2
//
//  Created by Bogdan Covaci on 16.11.2013.
//  Copyright (c) 2013 Bogdan Covaci. All rights reserved.
//

#import "MainViewController.h"
#import "AELimiterFilter.h"


@interface MainViewController ()
{
}

@property (nonatomic, strong) NSMutableArray *filters;
@property (nonatomic, strong) NSMutableArray *filterCenterFrequencies;
@property (nonatomic, strong) NSMutableArray *colorButtons;
@property (nonatomic, strong) NSMutableArray *frequencySliders;
@property (nonatomic, strong) NSMutableArray *frequencySlidersDeltas;
@property (nonatomic, assign) int frequencySlidersAnimationIndex;
@property (nonatomic, strong) NSTimer *frequencySlidersTimer;
@property (nonatomic, strong) NSArray *colorPowers;
@property (nonatomic, strong) AEBlockChannel *noiseChannel;
@property (nonatomic, assign) float volumeDelta;
@property (nonatomic, assign) int volumeAnimationIndex;
@property (nonatomic, strong) NSTimer *volumeTimer;
@property (nonatomic, strong) UIButton *purchaseButton;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.audioController = [[[AEAudioController alloc] initWithAudioDescription:[AEAudioController nonInterleavedFloatStereoAudioDescription] inputEnabled:NO] autorelease];
        self.audioController.preferredBufferDuration = 0.005;
//        AELimiterFilter *limiter = [[[AELimiterFilter alloc] initWithAudioController:self.audioController] autorelease];
//        limiter.level = 0.1;
//        [self.audioController addFilter:limiter];

        self.filters = [NSMutableArray array];
        self.filterCenterFrequencies = [NSMutableArray array];
        self.colorButtons = [NSMutableArray array];
        self.frequencySliders = [NSMutableArray array];
        self.frequencySlidersDeltas = [NSMutableArray array];
        self.frequencySlidersAnimationIndex = 0;
        self.frequencySlidersTimer = nil;
        self.volumeDelta = 0;
        self.volumeAnimationIndex = 0;
        self.volumeTimer = nil;

        // white
        // pink
        // @15.0, @8.2, @2.5, @-0.8, @-3.8, @-5.5, @-7.0, @-7.2, @-10.5, @-12.0
        // brown
        // @19.0, @13.5, @5.5, @-0.2, @-7.0, @-16.2, @-24.0, @-33.0, @-39.8, @-48.2
        // blue
        // @-30.0, @-23.5, @-17.5, @-11.5, @-10.0, @-4.0, @0.0, @1.0, @1.8, @1.5
        // violet
        // @-41.2, @-42.0, @-31.2, @-20.8, @-14.0, @-7.2, @-2.8, @2.2, @3.8, @8.2
        // grey
        // @13.0, @7.8, @0.2, @-8.2, @-11.5, @-11.8, @-9.8, @-4.2, @0.5, @2.5
        self.colorPowers = @[
                             @[@0, @0, @0, @0, @0, @0, @0, @0, @0, @0],
                             @[@15.0, @8.2, @2.5, @-0.8, @-3.8, @-5.5, @-7.0, @-7.2, @-10.5, @-12.0],
                             @[@4.5, @3.5, @3.0, @-2.2, @-9.0, @-16.2, @-24.0, @-33.0, @-39.8, @-48.2],
                             @[@-30.0, @-23.5, @-17.5, @-11.5, @-10.0, @-4.0, @0.0, @1.0, @1.8, @1.5],
                             @[@-41.2, @-42.0, @-31.2, @-20.8, @-14.0, @-7.2, @-2.8, @2.2, @3.8, @8.2],
                             @[@13.0, @7.8, @0.2, @-8.2, @-11.5, @-11.8, @-9.8, @-4.2, @0.5, @2.5],
                             ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.contentView.backgroundColor = [UIColor blackColor];
    self.topView.backgroundColor = [UIColor whiteColor];
    self.topContentView.backgroundColor = self.topView.backgroundColor;
    self.bottomView.backgroundColor = [UIColor colorWithRed:0.250 green:0.250 blue:0.250 alpha:1];
    self.eqView.backgroundColor = self.bottomView.backgroundColor;
    self.volumeView.backgroundColor = self.bottomView.backgroundColor;
    self.settingsView.backgroundColor = self.bottomView.backgroundColor;

    self.view.frame = [UIScreen mainScreen].bounds;
    self.bottomView.frame = (CGRect){{self.bottomView.frame.origin.x, self.topView.frame.size.height + 2}, {self.bottomView.frame.size.width, self.contentView.frame.size.height - self.topView.frame.size.height - 2}};
    self.bottomContentView.frame = (CGRect){{self.bottomContentView.frame.origin.x, self.volumeButton.frame.size.height}, {self.bottomContentView.frame.size.width, self.bottomView.frame.size.height - self.volumeButton.frame.size.height}};
    self.volumeView.frame = self.bottomContentView.bounds;
    self.eqView.frame = self.bottomContentView.bounds;
    self.settingsView.frame = self.bottomContentView.bounds;

    self.volumeButton.titleLabel.font = [UIFont fontWithName:@"icomoon" size:18];
    [self.volumeButton setTitle:@"b" forState:UIControlStateNormal];
    self.eqButton.titleLabel.font = [UIFont fontWithName:@"icomoon" size:18];
    [self.eqButton setTitle:@"a" forState:UIControlStateNormal];
    self.settingsButton.titleLabel.font = [UIFont fontWithName:@"icomoon" size:18];
    [self.settingsButton setTitle:@"g" forState:UIControlStateNormal];

    self.restorePurchasesButton.backgroundColor = [UIColor colorWithRed:0.150 green:0.150 blue:0.150 alpha:1];
    [self.restorePurchasesButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.2] forState:UIControlStateNormal];

    [self.volSlider setThumbImage:[UIImage imageNamed:@"knob.png"] forState:UIControlStateNormal];
    [self.volSlider setMinimumTrackImage:[UIImage imageNamed:@"track.png"] forState:UIControlStateNormal];
    [self.volSlider setMaximumTrackImage:[UIImage imageNamed:@"track.png"] forState:UIControlStateNormal];
    [self.panSlider setThumbImage:[UIImage imageNamed:@"knob.png"] forState:UIControlStateNormal];
    [self.panSlider setMinimumTrackImage:[UIImage imageNamed:@"track.png"] forState:UIControlStateNormal];
    [self.panSlider setMaximumTrackImage:[UIImage imageNamed:@"track.png"] forState:UIControlStateNormal];

    self.volLeftLabel.font = [UIFont fontWithName:@"icomoon" size:16];
    self.volLeftLabel.textColor = [UIColor whiteColor];
    self.volLeftLabel.textAlignment = NSTextAlignmentCenter;
    self.volLeftLabel.text = @"e";
    self.volRightLabel.font = [UIFont fontWithName:@"icomoon" size:16];
    self.volRightLabel.textColor = [UIColor whiteColor];
    self.volRightLabel.textAlignment = NSTextAlignmentCenter;
    self.volRightLabel.text = @"f";
    self.panLeftLabel.font = [UIFont fontWithName:@"icomoon" size:16];
    self.panLeftLabel.textColor = [UIColor whiteColor];
    self.panLeftLabel.textAlignment = NSTextAlignmentCenter;
    self.panLeftLabel.text = @"c";
    self.panRightLabel.font = [UIFont fontWithName:@"icomoon" size:16];
    self.panRightLabel.textColor = [UIColor whiteColor];
    self.panRightLabel.textAlignment = NSTextAlignmentCenter;
    self.panRightLabel.text = @"d";

    [self volumeButtonTapped:nil];

    CustoButton *b;
    float p = self.topContentView.frame.size.width / 6;
    b = [[[CustoButton alloc] init] autorelease];
    b.frame = CGRectMake(p * 0, 0, p, self.topContentView.frame.size.height);
    b.gradientArray = [NSArray arrayWithObjects:
                       (id)[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1].CGColor,
                       (id)[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1].CGColor, nil];
    [b addTarget:self action:@selector(colorButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.topContentView addSubview:b];
    [self.colorButtons addObject:b];

    b = [[[CustoButton alloc] init] autorelease];
    b.frame = CGRectMake(p * 1, 0, p, self.topContentView.frame.size.height);
    b.gradientArray = [NSArray arrayWithObjects:
                       (id)[UIColor colorWithRed:0.988 green:0.792 blue:0.804 alpha:1].CGColor,
                       (id)[UIColor colorWithRed:0.949 green:0.267 blue:0.498 alpha:1].CGColor, nil];
    [b addTarget:self action:@selector(colorButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.topContentView addSubview:b];
    [self.colorButtons addObject:b];

    b = [[[CustoButton alloc] init] autorelease];
    b.frame = CGRectMake(p * 2, 0, p, self.topContentView.frame.size.height);
    b.gradientArray = [NSArray arrayWithObjects:
                       (id)[UIColor colorWithRed:0.510 green:0.412 blue:0.325 alpha:1].CGColor,
                       (id)[UIColor colorWithRed:0.404 green:0.200 blue:0.004 alpha:1].CGColor, nil];
    [b addTarget:self action:@selector(colorButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.topContentView addSubview:b];
    [self.colorButtons addObject:b];

    b = [[[CustoButton alloc] init] autorelease];
    b.frame = CGRectMake(p * 3, 0, p, self.topContentView.frame.size.height);
    b.gradientArray = [NSArray arrayWithObjects:
                       (id)[UIColor colorWithRed:0.639 green:0.694 blue:0.933 alpha:1].CGColor,
                       (id)[UIColor colorWithRed:0.047 green:0.165 blue:0.635 alpha:1].CGColor, nil];
    [b addTarget:self action:@selector(colorButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.topContentView addSubview:b];
    [self.colorButtons addObject:b];

    b = [[[CustoButton alloc] init] autorelease];
    b.frame = CGRectMake(p * 4, 0, p, self.topContentView.frame.size.height);
    b.gradientArray = [NSArray arrayWithObjects:
                       (id)[UIColor colorWithRed:0.780 green:0.659 blue:0.890 alpha:1].CGColor,
                       (id)[UIColor colorWithRed:0.584 green:0.000 blue:0.831 alpha:1].CGColor, nil];
    [b addTarget:self action:@selector(colorButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.topContentView addSubview:b];
    [self.colorButtons addObject:b];

    b = [[[CustoButton alloc] init] autorelease];
    b.frame = CGRectMake(p * 5, 0, p, self.topContentView.frame.size.height);
    b.gradientArray = [NSArray arrayWithObjects:
                       (id)[UIColor colorWithRed:0.784 green:0.804 blue:0.788 alpha:1].CGColor,
                       (id)[UIColor colorWithRed:0.706 green:0.710 blue:0.729 alpha:1].CGColor, nil];
    [b addTarget:self action:@selector(colorButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.topContentView addSubview:b];
    [self.colorButtons addObject:b];


    self.filterCenterFrequencies = [@[@60.0f, @170.0f, @310.0f, @600.0f, @1000.0f, @3000.0f, @6000.0f, @12000.0f, @14000.0f, @16000.0f] mutableCopy];

    for(NSNumber *v in self.filterCenterFrequencies)
    {
        NVPeakingEQFilter *eq = [[[NVPeakingEQFilter alloc] initWithSamplingRate:self.audioController.audioDescription.mSampleRate] autorelease];
        eq.Q = 2.0f;
        eq.centerFrequency = [v floatValue];
        eq.G = 0;
        [self.filters addObject:eq];
    }

    p = self.eqView.frame.size.width / self.filterCenterFrequencies.count;
    float h = self.eqView.frame.size.height;
    for(int i = 0; i < self.filterCenterFrequencies.count; i++)
    {
        UISlider *s = [[[UISlider alloc] initWithFrame:CGRectMake(0, 0, 100, 100)] autorelease];
        s.tag = 100+i;
        s.minimumValue = -50.0;
        s.maximumValue = 50.0;
        s.value = 0.0;
        s.frame = (CGRect){{i * p - h/2 + p/2 + 7, h / 2 - 15}, {h - 10, p}};
        s.transform = CGAffineTransformMakeRotation(M_PI * -0.5);

        [s addTarget:self action:@selector(mod:) forControlEvents:UIControlEventValueChanged];

        [s setThumbImage:[UIImage imageNamed:@"knob.png"] forState:UIControlStateNormal];
        [s setMinimumTrackImage:[UIImage imageNamed:@"track.png"] forState:UIControlStateNormal];
        [s setMaximumTrackImage:[UIImage imageNamed:@"track.png"] forState:UIControlStateNormal];

        [self.eqView addSubview:s];
        [self.frequencySliders addObject:s];
    }

    self.purchaseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.purchaseButton.frame = self.eqView.bounds;
    [self.purchaseButton addTarget:self action:@selector(purchaseEQ:) forControlEvents:UIControlEventTouchDown];
    if(![MKStoreManager isFeaturePurchased:@"com.moghoul.noises2.eq"])
    {
        [self.eqView addSubview:self.purchaseButton];
    }

    self.noiseChannel = [AEBlockChannel channelWithBlock:^(const AudioTimeStamp *time, UInt32 frames, AudioBufferList *audio) {
        for(int i = 0; i < frames; i++)
        {
            float r = (rand() % 100) / 100.0f / 2;
            ((float*)audio->mBuffers[0].mData)[i] = r;
            ((float*)audio->mBuffers[1].mData)[i] = r;
        }

        for(NVPeakingEQFilter *eq in self.filters)
        {
            [eq filterData:(float*)audio->mBuffers[0].mData numFrames:frames numChannels:1];
            [eq filterData:(float*)audio->mBuffers[1].mData numFrames:frames numChannels:1];
        }
    }];
    self.noiseChannel.audioDescription = [AEAudioController nonInterleavedFloatStereoAudioDescription];
    [self.audioController addChannels:@[self.noiseChannel]];
}

- (void)mod:(UISlider*)s
{
    float v = s.value;

    UILabel *l = (UILabel*)[self.view viewWithTag:1000 + (s.tag - 100)];
    l.text = [NSString stringWithFormat:@"%.01f", v];

    ((NVPeakingEQFilter*)self.filters[s.tag - 100]).G = v;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    self.noiseChannel = nil;
    [_contentView release];
    [_eqView release];
    [_topView release];
    [_volumeButton release];
    [_eqButton release];
    [_bottomView release];
    [_bottomContentView release];
    [_eqView release];
    [_volumeView release];
    [_volLeftLabel release];
    [_volRightLabel release];
    [_panLeftLabel release];
    [_panRightLabel release];
    [_volSlider release];
    [_panSlider release];
    [_topContentView release];
    [_settingsButton release];
    [_settingsView release];
    [_restorePurchasesButton release];
    [super dealloc];
}

#pragma mark - actions
- (IBAction)dump:(id)sender
{
    NSMutableArray *arr = [NSMutableArray array];
    for(NVPeakingEQFilter *eq in self.filters)
    {
        [arr addObject:[NSString stringWithFormat:@"@%.01f", eq.G]];
    }
    NSLog(@"%@", [arr componentsJoinedByString:@", "]);
}

- (IBAction)volumeButtonTapped:(id)sender
{
    if(self.eqView.superview) [self.eqView removeFromSuperview];
    if(self.settingsView.superview) [self.settingsView removeFromSuperview];
    [self.bottomContentView addSubview:self.volumeView];

    self.eqButton.backgroundColor = [UIColor colorWithRed:0.150 green:0.150 blue:0.150 alpha:1];
    self.volumeButton.backgroundColor = [UIColor colorWithRed:0.250 green:0.250 blue:0.250 alpha:1];
    self.settingsButton.backgroundColor = [UIColor colorWithRed:0.150 green:0.150 blue:0.150 alpha:1];
    [self.eqButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.2] forState:UIControlStateNormal];
    [self.volumeButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.95] forState:UIControlStateNormal];
    [self.settingsButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.2] forState:UIControlStateNormal];
}

- (IBAction)eqButtonTapped:(id)sender
{
    if(self.settingsView.superview) [self.settingsView removeFromSuperview];
    if(self.volumeView.superview) [self.volumeView removeFromSuperview];
    [self.bottomContentView addSubview:self.eqView];

    self.eqButton.backgroundColor = [UIColor colorWithRed:0.250 green:0.250 blue:0.250 alpha:1];
    self.volumeButton.backgroundColor = [UIColor colorWithRed:0.150 green:0.150 blue:0.150 alpha:1];
    self.settingsButton.backgroundColor = [UIColor colorWithRed:0.150 green:0.150 blue:0.150 alpha:1];
    [self.eqButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.95] forState:UIControlStateNormal];
    [self.volumeButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.2] forState:UIControlStateNormal];
    [self.settingsButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.2] forState:UIControlStateNormal];
}

- (IBAction)settingsButtonTapped:(id)sender
{
    if(self.eqView.superview) [self.eqView removeFromSuperview];
    if(self.volumeView.superview) [self.volumeView removeFromSuperview];
    [self.bottomContentView addSubview:self.settingsView];

    self.eqButton.backgroundColor = [UIColor colorWithRed:0.150 green:0.150 blue:0.150 alpha:1];
    self.volumeButton.backgroundColor = [UIColor colorWithRed:0.150 green:0.150 blue:0.150 alpha:1];
    self.settingsButton.backgroundColor = [UIColor colorWithRed:0.250 green:0.250 blue:0.250 alpha:1];
    [self.eqButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.2] forState:UIControlStateNormal];
    [self.volumeButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.2] forState:UIControlStateNormal];
    [self.settingsButton setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.95] forState:UIControlStateNormal];
}

- (IBAction)volSliderChanged:(UISlider *)sender
{
    self.noiseChannel.volume = sender.value;
}

- (IBAction)panSliderChanged:(UISlider *)sender
{
    self.noiseChannel.pan = sender.value;
}

- (IBAction)restorePurchasesButtonTapped:(id)sender
{
    [[MKStoreManager sharedManager] restorePreviousTransactionsOnComplete:^{
        [[[[UIAlertView alloc] initWithTitle:nil message:@"Restore complete" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
    }
                                                                  onError:^(NSError *error) {
                                                                      [[[[UIAlertView alloc] initWithTitle:@"Restore failed" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease] show];
                                                                  }];
}

- (IBAction)colorButtonTapped:(id)sender
{
    __block BOOL stop = NO;
    [UIView animateWithDuration:0.3 animations:^{
        for(UIButton *b in self.colorButtons)
        {
            if(b == sender)
            {
                if(b.frame.origin.y > 0)
                {
                    b.frame = CGRectMake(b.frame.origin.x, 0, b.frame.size.width, self.topContentView.frame.size.height);
                    stop = YES;
                }else
                {
                    b.frame = CGRectMake(b.frame.origin.x, 70, b.frame.size.width, self.topContentView.frame.size.height - 70);
                }
            }else
            {
                b.frame = CGRectMake(b.frame.origin.x, 0, b.frame.size.width, self.topContentView.frame.size.height);
            }
        }
    }];

    if(stop)
    {
        if(self.audioController.running)
        {
            self.volumeDelta = -self.volSlider.value / 10;
            self.volumeAnimationIndex = 0;
            self.volumeTimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(volTimer:) userInfo:nil repeats:YES];
        }
    }else
    {
        if(!self.audioController.running)
        {
            self.noiseChannel.volume = 0;
            self.volumeDelta = self.volSlider.value / 10;
            self.volumeAnimationIndex = 0;
            self.volumeTimer = [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(volTimer:) userInfo:nil repeats:YES];

            [self.audioController start:NULL];
        }
    }

    NSArray *targetFrequencies = self.colorPowers[[self.colorButtons indexOfObject:sender]];
    [self.frequencySlidersDeltas removeAllObjects];
    for(int i = 0; i < self.frequencySliders.count; i++)
    {
        UISlider *s = (UISlider*)self.frequencySliders[i];
        float v = s.value;
        float t = [targetFrequencies[i] floatValue];
        float delta = (t - v) / 16;
        [self.frequencySlidersDeltas addObject:[NSNumber numberWithFloat:delta]];
    }
    self.frequencySlidersAnimationIndex = 0;
    self.frequencySlidersTimer = [NSTimer scheduledTimerWithTimeInterval:0.025 target:self selector:@selector(freqTimer:) userInfo:nil repeats:YES];
}

- (void)purchaseEQ:(id)sender
{
    [[[[UIAlertView alloc] initWithTitle:nil
                                 message:@"Would you like to get access to the equalizer so you can create personalized noises?"
                                delegate:self
                       cancelButtonTitle:@"No, thank you"
                       otherButtonTitles:@"Yes", nil] autorelease] show];
}

- (void)freqTimer:(NSTimer*)timer
{
    if(self.frequencySlidersAnimationIndex == 16)
    {
        [self.frequencySlidersTimer invalidate];
        self.frequencySlidersTimer = nil;
        return;
    }
    self.frequencySlidersAnimationIndex++;

    for(int i = 0; i < self.frequencySliders.count; i++)
    {
        UISlider *s = (UISlider*)self.frequencySliders[i];
        float v = s.value;
        float delta = [self.frequencySlidersDeltas[i] floatValue];
        v += delta;
        s.value = v;
        [self mod:s];
    }
}

- (void)volTimer:(NSTimer*)timer
{
    if(self.volumeAnimationIndex == 10)
    {
        [self.volumeTimer invalidate];
        self.volumeTimer = nil;
        return;
    }
    self.volumeAnimationIndex++;

    self.noiseChannel.volume += self.volumeDelta;
    if(self.noiseChannel.volume < 0.1)
    {
        [self.audioController stop];
    }
}

#pragma mark - alert view delegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [[MKStoreManager sharedManager] buyFeature:@"com.moghoul.noises2.eq"
                                        onComplete:^(NSString* purchasedFeature,
                                                     NSData* purchasedReceipt,
                                                     NSArray* availableDownloads)
         {
             [self.purchaseButton removeFromSuperview];
             [[[[UIAlertView alloc] initWithTitle:nil
                                          message:@"Thank you for your purchase"
                                         delegate:self
                                cancelButtonTitle:@"Dismiss"
                                otherButtonTitles:nil] autorelease] show];
         }
                                       onCancelled:^
         {
         }];
    }
}
@end
