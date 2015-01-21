////////////////////////////////////////////////////////////////////////////////
//
//  TYPHOON FRAMEWORK
//  Copyright 2013, Jasper Blues & Contributors
//  All Rights Reserved.
//
//  NOTICE: The authors permit you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////



#import <Foundation/Foundation.h>
#import "PFConditionType.h"

@class PFTemperature;


@interface PFForecastConditions : NSObject <NSCoding>

@property(nonatomic, strong, readonly) NSDate* date;
@property(nonatomic, strong, readonly) PFTemperature* low;
@property(nonatomic, strong, readonly) PFTemperature* high;
@property(nonatomic, strong, readonly) NSString* summary;
@property(nonatomic, readonly) PFConditionType conditionType;

+ (PFForecastConditions*)conditionsWithDate:(NSDate*)date low:(PFTemperature*)low
        high:(PFTemperature*)high summary:(NSString*)summary conditionType:(PFConditionType)conditionType;

- (id)initWithDate:(NSDate*)date low:(PFTemperature*)low high:(PFTemperature*)high
           summary:(NSString*)summary conditionType:(PFConditionType)conditionType;

- (NSString*)longDayOfTheWeek;

@end