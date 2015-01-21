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


#import "PFWeatherReportView.h"
#import "UIFont+ApplicationFonts.h"
#import "PFForecastTableViewCell.h"
#import "PFForecastConditions.h"
#import "PFWeatherReport.h"
#import "PFCurrentConditions.h"
#import "PFTemperature.h"
#import "CKUITools.h"
#import "PFTheme.h"
#import "NGAParallaxMotion.h"
#import "UIColor+CKUITools.h"


@implementation PFWeatherReportView

/* ====================================================================================================================================== */
#pragma mark - Initialization & Destruction

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initBackgroundView];
        [self initCityNameLabel];
        [self initConditionsDescriptionLabel];
        [self initConditionsIcon];
        [self initTemperatureLabel];
        [self initTableView];
        [self initToolbar];
        [self initLastUpdateLabel];
    }

    return self;
}


/* ====================================================================================================================================== */
#pragma mark - Interface Methods

- (void)setWeatherReport:(PFWeatherReport *)weatherReport
{
    if (weatherReport)
    {
        [_tableView setHidden:NO];
        LogDebug(@"Set weather report: %@", weatherReport);
        _weatherReport = weatherReport;

        [_conditionsIcon setHidden:NO];
        [_temperatureLabelContainer setHidden:NO];

        NSArray *indexPaths = @[
            [NSIndexPath indexPathForRow:0 inSection:0],
            [NSIndexPath indexPathForRow:1 inSection:0],
            [NSIndexPath indexPathForRow:2 inSection:0]
        ];

        [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        [_cityNameLabel setText:[_weatherReport cityDisplayName]];
        [_temperatureLabel setText:[_weatherReport.currentConditions.temperature asShortStringInDefaultUnits]];
        [_conditionsDescriptionLabel setText:[_weatherReport.currentConditions longSummary]];
        [_conditionsIcon setImage:[self uiImageForConditionType:weatherReport.currentConditions.conditionType]];
        [_lastUpdateLabel setText:[NSString stringWithFormat:@"Updated %@", [weatherReport reportDateAsString]]];
    }
}

/* ====================================================================================================================================== */
#pragma mark - Overridden Methods

- (void)layoutSubviews
{
    [super layoutSubviews];
    [_backgroundView setFrame:CGRectInset(self.bounds, -10, -10)];

    [_cityNameLabel setFrame:CGRectMake(0, 60, self.width, 40)];
    [_conditionsDescriptionLabel setFrame:CGRectMake(0, 90, 320, 50)];
    [_conditionsIcon setFrame:CGRectMake(40, 143, 130, 120)];
    [_temperatureLabelContainer setFrame:CGRectMake(180, 155, 88, 88)];

    [_toolbar setFrame:CGRectMake(0, self.frame.size.height - _toolbar.height, self.width, _toolbar.height)];
    [_tableView setFrame:CGRectMake(0, self.frame.size.height - _toolbar.frame.size.height - 150, 320, 150)];
    [_lastUpdateLabel setFrame:[_toolbar bounds]];
}

- (void)setTheme:(PFTheme *)theme
{
    _theme = theme;
    dispatch_async(dispatch_get_main_queue(), ^
    {
        [_toolbar setBarTintColor:theme.forecastTintColor];
        [(UIImageView *) _backgroundView setImage:[UIImage imageNamed:theme.backgroundResourceName]];
        [_tableView reloadData];
    });

}

/* ====================================================================================================================================== */
#pragma mark - Protocol Methods
#pragma mark <UITableVieDelegate> & <UITableViewDataSource>


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFForecastConditions *forecastConditions;
    if ([[_weatherReport forecast] count] > indexPath.row)
    {
        forecastConditions = [[_weatherReport forecast] objectAtIndex:indexPath.row];
    }
    static NSString *reuseIdentifier = @"weatherForecast";
    PFForecastTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil)
    {
        cell = [[PFForecastTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }

    [cell.dayLabel setText:forecastConditions.longDayOfTheWeek];
    [cell.descriptionLabel setText:forecastConditions.summary];
    [cell.lowTempLabel setText:[forecastConditions.low asShortStringInDefaultUnits]];
    [cell.highTempLabel setText:[forecastConditions.high asShortStringInDefaultUnits]];
    [cell.conditionsIcon setImage:[self uiImageForConditionType:forecastConditions.conditionType]];

    [cell.backgroundView setBackgroundColor:[self colorForRow:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
}

/* ====================================================================================================================================== */
#pragma mark - Private Methods

- (void)initBackgroundView
{
    _backgroundView = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_backgroundView setContentMode:UIViewContentModeScaleToFill];
    [self addSubview:_backgroundView];

    if ([[[UIDevice currentDevice] systemVersion] integerValue] >= 7)
    {

        [_backgroundView setParallaxIntensity:20];
    }
}


- (void)initCityNameLabel
{
    _cityNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_cityNameLabel setFont:[UIFont applicationFontOfSize:35]];
    [_cityNameLabel setTextColor:[UIColor colorWithHexRGB:0xf9f7f4]];
    [_cityNameLabel setBackgroundColor:[UIColor clearColor]];
    [_cityNameLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_cityNameLabel];
}

- (void)initConditionsDescriptionLabel
{
    _conditionsDescriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_conditionsDescriptionLabel setFont:[UIFont applicationFontOfSize:16]];
    [_conditionsDescriptionLabel setTextColor:[UIColor colorWithHexRGB:0xf9f7f4]];
    [_conditionsDescriptionLabel setBackgroundColor:[UIColor clearColor]];
    [_conditionsDescriptionLabel setTextAlignment:NSTextAlignmentCenter];
    [_conditionsDescriptionLabel setNumberOfLines:0];
    [self addSubview:_conditionsDescriptionLabel];
}

- (void)initConditionsIcon
{
    _conditionsIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
    [_conditionsIcon setImage:[UIImage imageNamed:@"icon_cloudy"]];
    [_conditionsIcon setHidden:YES];
    [self addSubview:_conditionsIcon];
}

- (void)initTemperatureLabel
{
    _temperatureLabelContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 88, 88)];
    [self addSubview:_temperatureLabelContainer];

    UIImageView *labelBackground = [[UIImageView alloc] initWithFrame:_temperatureLabelContainer.bounds];
    [labelBackground setImage:[UIImage imageNamed:@"temperature_circle"]];
    [_temperatureLabelContainer addSubview:labelBackground];

    _temperatureLabel = [[UILabel alloc] initWithFrame:_temperatureLabelContainer.bounds];
    [_temperatureLabel setFont:[UIFont temperatureFontOfSize:35]];
    [_temperatureLabel setTextColor:[UIColor colorWithHexRGB:0x7f9588]];
    [_temperatureLabel setBackgroundColor:[UIColor clearColor]];
    [_temperatureLabel setTextAlignment:NSTextAlignmentCenter];

    [_temperatureLabelContainer setHidden:YES];
    [_temperatureLabelContainer addSubview:_temperatureLabel];
}

- (void)initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setUserInteractionEnabled:NO];
    [_tableView setHidden:YES];
    [self addSubview:_tableView];
}

- (void)initToolbar
{
    _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    [self addSubview:_toolbar];
}

- (void)initLastUpdateLabel
{
    _lastUpdateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    [_lastUpdateLabel setFont:[UIFont applicationFontOfSize:10]];
    [_lastUpdateLabel setTextColor:[UIColor colorWithHexRGB:0xf9f7f4]];
    [_lastUpdateLabel setBackgroundColor:[UIColor clearColor]];
    [_lastUpdateLabel setTextAlignment:NSTextAlignmentCenter];
    [_toolbar addSubview:_lastUpdateLabel];
}

/* ====================================================================================================================================== */

- (UIColor *)colorForRow:(NSUInteger)row
{
    switch (row)
    {
        case 0:
            return [_theme.forecastTintColor colorWithAlphaComponent:0.55];
        case 1:
            return [_theme.forecastTintColor colorWithAlphaComponent:0.75];
        default:
            return [_theme.forecastTintColor colorWithAlphaComponent:0.95];
    }
}

- (UIImage *)uiImageForConditionType:(PFConditionType)conditionType
{
    UIImage *conditionImage;
    
    switch (conditionType) {
        case conditionTypeSunny:
            conditionImage = [UIImage imageNamed:@"icon_sunny"];
            break;
        case conditionTypeCloudy:
            conditionImage = [UIImage imageNamed:@"icon_cloudy"];
            break;
        case conditionTypeRainy:
            conditionImage = [UIImage imageNamed:@"icon_rainy"];
            break;
        default:
            LogDebug(@"*** No icon for condition type:%i . . rerturning sunny ***", conditionType);
            conditionImage = [UIImage imageNamed:@"icon_sunny"];
            break;
    }

    return conditionImage;
}


@end