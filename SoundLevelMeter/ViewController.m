//
//  ViewController.m
//  SoundLevelMeter
//
//  Created by Андрей Зябкин on 26.02.2019.
//  Copyright © 2019 Андрей Зябкин. All rights reserved.
//

#import "ViewController.h"

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSTimer *levelTimer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    minVolume=100;
    avgVolume=0;
    maxVolume=0;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *err = nil;
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    if(err)
    {
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    [audioSession setActive:YES error:&err];
    err = nil;
    if(err)
    {
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    
    // Create a new audio file
    NSString *audioFileName = @"recordingTestFile";
    NSString *recorderFilePath = [NSString stringWithFormat:@"%@/%@.caf", DOCUMENTS_FOLDER, audioFileName] ;
    
    NSURL *url = [NSURL fileURLWithPath:recorderFilePath];
    
    NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
                              [NSNumber numberWithFloat: 44100.0],                 AVSampleRateKey,
                              [NSNumber numberWithInt: kAudioFormatLinearPCM], AVFormatIDKey,
                              [NSNumber numberWithInt: 1],                         AVNumberOfChannelsKey,
                              [NSNumber numberWithInt: AVAudioQualityMax],         AVEncoderAudioQualityKey,
                              nil];
    
    NSError *error;
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    
    if (self.recorder) {
        [self.recorder prepareToRecord];
        [self.recorder setMeteringEnabled:YES];
        [self.recorder record];
    } else
        NSLog(@"Error in initializeRecorder: %@", [error description]);
    
    
    [self initializeLevelTimer];
}

-(IBAction)startStopBtnPressed:(id)sender{
    
    //Если замер уже производился ранее - останавливаем
    if (self.levelTimer){
        minVolume=100;
        avgVolume=0;
        maxVolume=0;
        
        allSumm=0;
        count=0;
    }
    
}

- (void)initializeLevelTimer
{
    self.levelTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
}

- (void)levelTimerCallback:(NSTimer *)timer
{
    [self.recorder updateMeters];
    //float volInDb = pow(10.0, [self.recorder averagePowerForChannel:0] / 20.0) * 120.0;
    float volInDb = [self.recorder averagePowerForChannel:0]+100;
    //Коррекция минимаьных значений из-за чувствительности микрофона
    //if (volInDb<1 && volInDb>0.1)
    //    volInDb++;
    
    //Избавляемся от отрицательных значений
    if (volInDb<0)
        volInDb=0;
    
    //Вычисляем среднее
    allSumm+=volInDb;
    count++;
    average=allSumm/count;
    [avgLabel setText: [NSString stringWithFormat:@"%d db",(int)average]];
    
    
    //Выводим в круговую шкалу
    if (volInDb<=15){
        //[volumeBar setProgressBarProgressColor:UIColorFromRGB(0xe1997b)];
        [textResultLabel setText:@"Mosquito"];
    }
    else if (volInDb>15 && volInDb<=30){
        //[volumeBar setProgressBarProgressColor:UIColorFromRGB(0xdf7f6d)];
        [textResultLabel setText:@"Whisper"];
    }
    else if (volInDb>30 && volInDb<=45){
        //[volumeBar setProgressBarProgressColor:UIColorFromRGB(0xd86653)];
        [textResultLabel setText:@"Quiet library"];
    }
    else if (volInDb>45 && volInDb<=60){
        //[volumeBar setProgressBarProgressColor:UIColorFromRGB(0xda4f3e)];
        //[volumeBar setProgressBarProgressColor:UIColorFromRGB(0xcb2621)];
        [textResultLabel setText:@"Office"];
    }
    else if (volInDb>60 && volInDb<=75){
        //[volumeBar setProgressBarProgressColor:UIColorFromRGB(0xcb2621)];
        [textResultLabel setText:@"Busy traffic"];
    }
    else if (volInDb>75 && volInDb<=80){
        //[volumeBar setProgressBarProgressColor:UIColorFromRGB(0xcb2621)];
        [textResultLabel setText:@"Gunshot"];
    }
    else if (volInDb>80){
        //[volumeBar setProgressBarProgressColor:UIColorFromRGB(0x761129)];
        [textResultLabel setText:@"Airplane"];
    }
    
    [volumeBar setProgress:volInDb/100 animated:YES];
    
    //[volumeLevel setText:[NSString stringWithFormat:@"%f",volInDb]];
    NSLog(@"%@", [NSString stringWithFormat:@"%f",volInDb]);
    
    //Определяем минимальное, максимальное и среднее значение
    if (minVolume > volInDb)
        minVolume=volInDb;
    if (maxVolume < volInDb)
        maxVolume=volInDb;
    
    [minLabel setText:[NSString stringWithFormat:@"%d db", (int)minVolume]];
    [maxLabel setText:[NSString stringWithFormat:@"%d db", (int)maxVolume]];
}


@end
