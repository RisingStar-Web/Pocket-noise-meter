//
//  CircleProgressBar.h
//  SoundLevelMeter
//
//  Created by Андрей Зябкин on 26.02.2019.
//  Copyright © 2019 Андрей Зябкин. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString*(^StringGenerationBlock)(CGFloat progress);
typedef NSAttributedString*(^AttributedStringGenerationBlock)(CGFloat progress);

IB_DESIGNABLE
@interface CircleProgressBar : UIView

//Ширина прогресса
@property (nonatomic) IBInspectable CGFloat progressBarWidth;
//Цвет прогресса
@property (nonatomic) IBInspectable UIColor *progressBarProgressColor;
//Цвет прогресса
@property (nonatomic) IBInspectable UIColor *progressBarTrackColor;
//Угол старта
@property (nonatomic) IBInspectable CGFloat startAngle;


@property (nonatomic) IBInspectable BOOL hintHidden;

@property (nonatomic) IBInspectable CGFloat hintViewSpacing;

@property (nonatomic) IBInspectable UIColor *hintViewBackgroundColor;

@property (nonatomic) IBInspectable UIFont *hintTextFont;

@property (nonatomic) IBInspectable UIColor *hintTextColor;


- (void)setHintTextGenerationBlock:(StringGenerationBlock)generationBlock;


- (void)setHintAttributedGenerationBlock:(AttributedStringGenerationBlock)generationBlock;


@property (nonatomic, readonly) IBInspectable CGFloat progress;

@property (nonatomic, readonly) BOOL isAnimating;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated duration:(CGFloat)duration;

// Остановка анимации
- (void)stopAnimation;

@end
