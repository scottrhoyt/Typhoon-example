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


@interface PFCurrentConditions : NSObject<NSCoding>

@property(nonatomic, strong, readonly) NSString* summary;
@property(nonatomic, strong, readonly) PFTemperature* temperature;
@property(nonatomic, strong, readonly) NSString* humidity;
@property(nonatomic, strong, readonly) NSString* wind;
@property(nonatomic, readonly) PFConditionType conditionType;

+ (PFCurrentConditions*) conditionsWithSummary:(NSString*)summary temperature:(PFTemperature*)temperature
                                      humidity:(NSString*)humidity wind:(NSString*)wind conditionType:(PFConditionType)conditionType;

- (id) initWithSummary:(NSString*)summary temperature:(PFTemperature*)temperature humidity:(NSString*)humidity
        wind:(NSString*)wind conditionType:(PFConditionType)conditionType;

- (NSString*) longSummary;


@end