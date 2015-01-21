//
//  RXMLElement+PFWeatherReportOWM.m
//  PocketForecast
//
//  Created by Scott Hoyt on 1/20/15.
//  Copyright (c) 2015 typhoon. All rights reserved.
//

#import "RXMLElement+PFWeatherReportOWM.h"
#import "PFWeatherReport.h"
#import "PFTemperature.h"
#import "PFCurrentConditions.h"
#import "PFForecastConditions.h"

@implementation RXMLElement (PFWeatherReportOWM)

//- (PFWeatherReport*)asWeatherReport
//{
//    if (![self.tag isEqualToString:@"data"])
//    {
//        [NSException raise:NSInvalidArgumentException format:@"Element is not 'data'."];
//    }
//    
//    NSString* city = [[self child:@"request.query"] text];
//    PFCurrentConditions* currentConditions = [[self child:@"current_condition"] asCurrentCondition];
//    
//    NSMutableArray* forecast = [[NSMutableArray alloc] init];
//    for (RXMLElement* e in [self children:@"weather"])
//    {
//        [forecast addObject:[e asForecastConditions]];
//    }
//    
//    return [PFWeatherReport reportWithCity:city date:[NSDate date] currentConditions:currentConditions forecast:forecast];
//}

- (PFCurrentConditions*)asCurrentCondition
{
    if (![self.tag isEqualToString:@"current"])
    {
        [NSException raise:NSInvalidArgumentException format:@"Element is not 'current'."];
    }
    RXMLElement *weatherElement = [self child:@"weather"];
    NSString* summary = [weatherElement attribute:@"value"];
    //RXMLElement *temperature = [self child:@"temperature"];
    PFTemperature* temp = [PFTemperature temperatureWithCelsiusString:[[self child:@"temperature"] attribute:@"value"]];
    NSString* humidity = [[self child:@"humidity"] attribute:@"value"];
    RXMLElement *windElement = [self child:@"wind"];
    NSString* wind =
    [NSString stringWithFormat:@"Wind: %@ km %@", [[windElement child:@"speed"] attribute:@"value"], [[windElement child:@"direction"] attribute:@"code"]];
    PFConditionType conditionType = [self getConditionTypeFromCode:[weatherElement attribute:@"number"]];
    
    return [PFCurrentConditions conditionsWithSummary:summary temperature:temp humidity:humidity wind:wind conditionType:conditionType];
    
}

- (NSArray *)asForecasts
{
    RXMLElement *forecastElement = [self child:@"forecast"];
    if (!forecastElement)
    {
        [NSException raise:NSInvalidArgumentException format:@"Element is not 'forecast'."];
    }
    
    NSMutableArray *forecasts = [NSMutableArray array];
    
    [forecastElement iterate:@"time" usingBlock:^(RXMLElement *time) {

        [forecasts addObject:[time asForecastConditions]];
    }];
    
    return forecasts;
}

- (PFForecastConditions *)asForecastConditions
{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate* date = [formatter dateFromString:[self attribute:@"day"]];
    RXMLElement *symbol = [self child:@"symbol"];
    NSString *description = [symbol attribute:@"name"];
    PFConditionType conditionType = [self getConditionTypeFromCode:[symbol attribute:@"number"]];
    RXMLElement *temperature = [self child:@"temperature"];
    PFTemperature *low = [PFTemperature temperatureWithCelsiusString:[temperature attribute:@"min"]];
    PFTemperature *high = [PFTemperature temperatureWithCelsiusString:[temperature attribute:@"max"]];
    PFForecastConditions *forecastConditions = [PFForecastConditions conditionsWithDate:date low:low high:high summary:description conditionType:conditionType];
    return forecastConditions;
}

- (PFConditionType)getConditionTypeFromCode:(NSString *)weatherCode
{
    NSInteger codePrefix = [weatherCode integerValue] / 100;
    NSInteger codeRemainder = [weatherCode integerValue] % 100;
    PFConditionType conditionType;
    switch (codePrefix) {
        case 2:
        case 3:
        case 4:
        case 5:
        case 6:
            conditionType = conditionTypeRainy;
            break;
        case 7:
            conditionType = conditionTypeOther;
            break;
        case 8:
            conditionType = codeRemainder == 0 ? conditionTypeSunny : conditionTypeCloudy;
            break;
        case 9:
            conditionType = conditionTypeOther;
            break;
        default:
            conditionType = conditionTypeOther;
            break;
    }
    return conditionType;
}

@end
