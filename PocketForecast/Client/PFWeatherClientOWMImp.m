//
//  PFWeatherClientOWMImp.m
//  PocketForecast
//
//  Created by Scott Hoyt on 1/20/15.
//  Copyright (c) 2015 typhoon. All rights reserved.
//

#import "PFWeatherClientOWMImp.h"
#import "NSURL+QueryDictionary.h"
#import "RXMLElement.h"
#import "RXMLElement+PFWeatherReportOWM.h"
#import "PFWeatherReport.h"

@implementation PFWeatherClientOWMImp

#pragma mark - PFWeatherClient Methods

- (void)loadWeatherReportFor:(NSString *)city onSuccess:(PFWeatherReportReceivedBlock)successBlock onError:(PFWeatherReportErrorBlock)errorBlock
{
    if (city)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^
                       {
                           NSData* forecastData = [NSData dataWithContentsOfURL:[self forecastQueryURL:city]];
                           RXMLElement* forecastElement = [RXMLElement elementFromXMLData:forecastData];
                           RXMLElement* forecastError = [forecastElement child:@"error"];
                           if (forecastError && errorBlock)
                           {
                               NSString* failureReason = [[[forecastError child:@"msg"] text] copy];
                               dispatch_async(dispatch_get_main_queue(), ^
                                              {
                                                  errorBlock(failureReason.length == 0 ? @"Unexpected error." : failureReason);
                                              });
                           }
                           else
                           {
                               NSData *currentData = [NSData dataWithContentsOfURL:[self currentQueryURL:city]];
                               RXMLElement *currentElement = [RXMLElement elementFromXMLData:currentData];
                               RXMLElement *currentError = [currentElement child:@"error"];
                               
                               if (currentError && errorBlock) {
                                   NSString* failureReason = [[[currentError child:@"msg"] text] copy];
                                   dispatch_async(dispatch_get_main_queue(), ^
                                                  {
                                                      errorBlock(failureReason.length == 0 ? @"Unexpected error." : failureReason);
                                                  });
                               }
                               else if (successBlock)
                               {
                                   PFWeatherReport *weatherReport = [PFWeatherReport reportWithCity:city date:[NSDate date] currentConditions:[currentElement asCurrentCondition] forecast:[forecastElement asForecasts]];
                                   [_weatherReportDao saveReport:weatherReport];
                                   dispatch_async(dispatch_get_main_queue(), ^
                                                  {
                                                      successBlock(weatherReport);
                                                  });
                               }
                           }
                       });
    }
}

#pragma mark - private

- (NSURL*)currentQueryURL:(NSString*)city
{
    NSURL *currentURL = [_serviceUrl URLByAppendingPathComponent:@"weather"];
    NSURL* url = [currentURL uq_URLByAppendingQueryDictionary:@{
                                                                 @"q"           : city,
                                                                 @"mode"        : @"xml",
                                                                 @"units"       : @"metric"
                                                                 }];
    return url;
}

- (NSURL*)forecastQueryURL:(NSString*)city
{
    NSURL *forecastURL = [[_serviceUrl URLByAppendingPathComponent:@"forecast" isDirectory:YES] URLByAppendingPathComponent:@"daily" isDirectory:NO];
    NSURL* queryURL = [forecastURL uq_URLByAppendingQueryDictionary:@{
                                                                      @"q"           : city,
                                                                      @"mode"        : @"xml",
                                                                      @"units"       : @"metric",
                                                                      @"cnt"         : [NSString stringWithFormat:@"%i", _daysToRetrieve],
                                                                      }];
    return queryURL;
}

@end
