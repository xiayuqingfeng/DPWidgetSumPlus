//
//  DPProvinceModel.h
//  ZCWBaseApp
//
//  Created by xiayupeng on 2021/6/6.
//  Copyright (c) 2021年 xiayupeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class DPCityModel;
@class DPCountyModel;

@interface DPProvinceModel : NSObject
///省编码
@property (nonatomic, strong) NSString *proCode;
///省名称
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSMutableArray <DPCityModel *>*array;
@end

@interface DPCityModel : NSObject
///城市编码
@property (nonatomic, strong) NSString *cityCode;
///城市名称
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSMutableArray <DPCountyModel *>*array;
@end

@interface DPCountyModel : NSObject
///区县编码
@property (nonatomic, strong) NSString *countyCode;
///区县名称
@property (nonatomic, strong) NSString *county;
@end
