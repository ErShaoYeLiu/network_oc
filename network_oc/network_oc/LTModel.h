//
//  LTModel.h
//  network_oc
//
//  Created by 8000yi on 2020/12/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LTModel : NSObject
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *userid;
+(instancetype)modelWithDictionary:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
