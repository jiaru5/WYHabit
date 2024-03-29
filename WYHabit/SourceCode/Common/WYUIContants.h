//
//  WYUIContants.h
//  WYHabit
//
//  Created by Jia Ru on 2/23/14.
//  Copyright (c) 2014 JiaruPrimer. All rights reserved.
//

#define UI_SCREEN_WIDTH             ([[UIScreen mainScreen] bounds].size.width)
#define UI_SCREEN_HEIGHT            ([[UIScreen mainScreen] bounds].size.height)

#pragma mark - Color

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 \
green:((float)(((rgbValue) & 0xFF00) >> 8))/255.0 \
blue:((float)((rgbValue) & 0xFF))/255.0 \
alpha:1.0]

#define UIColorFromRGBA(rgbValue, alphaValue) \
[UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 \
green:((float)(((rgbValue) & 0xFF00) >> 8))/255.0 \
blue:((float)((rgbValue) & 0xFF))/255.0 \
alpha:(alphaValue)]

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define UI_COLOR_GREEN_GRASS UIColorFromRGB(0x638e22)
#define UI_COLOR_ORANGE     [UIColor orangeColor]
#define UI_COLOR_GRAY_LIGHT [UIColor lightGrayColor] 

#define UI_COLOR_MAIN_BACKGROUND_GRAY UIColorFromRGB(0xd9d9d9)
#define UI_COLOR_MAIN_BACKGROUND_GRAY_EXSTREAM_LIGHT UIColorFromRGB(0xf2f2f2)


#define kAnimationDurationShort     0.1f
#define kAnimationDurationNormal    0.25f
