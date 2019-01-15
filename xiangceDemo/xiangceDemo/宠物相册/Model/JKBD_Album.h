//
//  JKBD_Album.h
//  NewPetFeeder
//
//  Created by lijiang on 2017/9/23.
//  Copyright © 2017年 lijiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JKBD_Album : NSObject

@property(nonatomic,copy)NSString *gateway_uid;//设备ID
@property(nonatomic,copy)NSString *picture_year;//抓拍年月日
@property(nonatomic,copy)NSString *picture_path;//图片地址
@property(nonatomic,strong)NSIndexPath *indexpath;//图片标识
@property(nonatomic,assign)int index_num;//图片标识


@end
