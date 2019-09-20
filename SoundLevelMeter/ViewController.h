//
//  ViewController.h
//  SoundLevelMeter
//
//  Created by Андрей Зябкин on 26.02.2019.
//  Copyright © 2019 Андрей Зябкин. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "CircleProgressBar.h"

#define AR_AUDIO_RECOGNIZER_SENSITIVITY_LOW 0.90f
#define AR_AUDIO_RECOGNIZER_SENSITIVITY_MODERATE 0.70f
#define AR_AUDIO_RECOGNIZER_SENSITIVITY_HIGH 0.50f
#define AR_AUDIO_RECOGNIZER_SENSITIVITY_DEFAULT AR_AUDIO_RECOGNIZER_SENSITIVITY_MODERATE

#define AR_AUDIO_RECOGNIZER_FREQUENCY_LOW 0.1f
#define AR_AUDIO_RECOGNIZER_FREQUENCY_MODERATE 0.03f
#define AR_AUDIO_RECOGNIZER_FREQUENCY_HIGH 0.02f
#define AR_AUDIO_RECOGNIZER_FREQUENCY_DEFAULT AR_AUDIO_RECOGNIZER_FREQUENCY_MODERATE


@interface ViewController : UIViewController{
    
    IBOutlet UIButton *startStopBtn;
    IBOutlet UILabel *textResultLabel;
    IBOutlet CircleProgressBar *volumeBar;
    
    IBOutlet UILabel *minLabel;
    IBOutlet UILabel *avgLabel;
    IBOutlet UILabel *maxLabel;
    
    float minVolume;
    float avgVolume;
    float maxVolume;
    
    double allSumm;
    int count;
    double average; 
    
}

@property (nonatomic, readonly) float sensitivity;
@property (nonatomic, readonly) float frequency;
@property (nonatomic, readonly) float lowPassResults;

-(IBAction)startStopBtnPressed:(id)sender;

@end

