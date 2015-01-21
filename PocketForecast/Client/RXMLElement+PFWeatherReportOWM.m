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
    NSString* imageUri = [self getImageURLStringFromIconCode:[weatherElement attribute:@"icon"]];
    
    return [PFCurrentConditions conditionsWithSummary:summary temperature:temp humidity:humidity wind:wind imageUrl:imageUri];
    
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
    NSString *imageURI = [self getImageURLStringFromIconCode:[symbol attribute:@"var"]];
    RXMLElement *temperature = [self child:@"temperature"];
    PFTemperature *low = [PFTemperature temperatureWithCelsiusString:[temperature attribute:@"min"]];
    PFTemperature *high = [PFTemperature temperatureWithCelsiusString:[temperature attribute:@"max"]];
    PFForecastConditions *forecastConditions = [PFForecastConditions conditionsWithDate:date low:low high:high summary:description imageUri:imageURI];
    return forecastConditions;
}

- (NSString *)getImageURLStringFromIconCode:(NSString *)weatherCode
{
//    NSString *baseURLString = @"http://openweathermap.org/img/w/";
//    NSString *iconURLString = [[baseURLString stringByAppendingPathComponent:iconCode] stringByAppendingPathExtension:@"png"];
//    return iconURLString;
    NSInteger codePrefix = [weatherCode integerValue] / 100;
    switch (codePrefix) {
        case 2:
            //
            break;
        case 3:
            break;
        case 4:
            break;
        case 5:
            break;
        case 6:
            break;
        case 7:
            break;
        case 8:
            break;
        case 9:
            break;
        default:
            break;
    }
}

@end
