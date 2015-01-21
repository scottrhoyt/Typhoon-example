//
//  PFWeatherClientOWMImp.h
//  PocketForecast
//
//  Created by Scott Hoyt on 1/20/15.
//  Copyright (c) 2015 typhoon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFWeatherClient.h"
#import "PFWeatherReportDao.h"

@interface PFWeatherClientOWMImp : NSObject <PFWeatherClient>

@property(nonatomic, strong) id <PFWeatherReportDao> weatherReportDao;
@property(nonatomic, strong) NSURL* serviceUrl;
@property(nonatomic) int daysToRetrieve;

@end
