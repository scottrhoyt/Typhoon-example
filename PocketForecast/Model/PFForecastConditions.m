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



#import "PFForecastConditions.h"
#import "PFTemperature.h"


@implementation PFForecastConditions


/* =========================================================== Class Methods ============================================================ */
+ (PFForecastConditions*)conditionsWithDate:(NSDate*)date low:(PFTemperature*)low
        high:(PFTemperature*)high summary:(NSString*)summary conditionType:(PFConditionType)conditionType
{

    return [[PFForecastConditions alloc] initWithDate:date low:low high:high summary:summary conditionType:conditionType];
}


/* ============================================================ Initializers ============================================================ */
- (id)initWithDate:(NSDate*)date low:(PFTemperature*)low high:(PFTemperature*)high
        summary:(NSString*)summary conditionType:(PFConditionType)conditionType
{

    self = [super init];
    if (self)
    {
        _date = date;
        _low = low;
        _high = high;
        _summary = summary;
        _conditionType = conditionType;
    }
    return self;
}

- (id)initWithCoder:(NSCoder*)coder
{
    self = [super init];
    if (self)
    {
        _date = [coder decodeObjectForKey:@"_date"];
        _low = [coder decodeObjectForKey:@"_low"];
        _high = [coder decodeObjectForKey:@"_high"];
        _summary = [coder decodeObjectForKey:@"_summary"];
        _conditionType = [coder decodeIntForKey:@"_conditionType"];
    }
    return self;
}


/* ========================================================== Interface Methods ========================================================= */
- (NSString*)longDayOfTheWeek
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEEE"];
    return [formatter stringFromDate:_date];
}


/* ============================================================ Utility Methods ========================================================= */
- (NSString*)description
{
    return [NSString stringWithFormat:@"Forcast: day=%@, low=%@, high=%@", [self longDayOfTheWeek], _low, _high];
}

- (void)encodeWithCoder:(NSCoder*)coder
{
    [coder encodeObject:_date forKey:@"_date"];
    [coder encodeObject:_low forKey:@"_low"];
    [coder encodeObject:_high forKey:@"_high"];
    [coder encodeObject:_summary forKey:@"_summary"];
    [coder encodeInteger:_conditionType forKey:@"_conditionType"];
}

@end