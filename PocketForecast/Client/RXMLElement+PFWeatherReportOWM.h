//
//  RXMLElement+PFWeatherReportOWM.h
//  PocketForecast
//
//  Created by Scott Hoyt on 1/20/15.
//  Copyright (c) 2015 typhoon. All rights reserved.
//

#import "RXMLElement.h"

@class PFWeatherReport;
@class PFCurrentConditions;
@class PFForecastConditions;

@interface RXMLElement (PFWeatherReportOWM)

//- (PFWeatherReport*) asWeatherReport;

- (PFCurrentConditions*)asCurrentCondition;

- (PFForecastConditions*) asForecastConditions;

- (NSArray *)asForecasts;

@end
