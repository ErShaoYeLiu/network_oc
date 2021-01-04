//
//  LTNetWorkBaseRequest.h
//  network_oc
//
//  Created by 8000yi on 2020/12/29.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^LTSuccessBlock)(NSDictionary *data);
typedef void(^LTFailureBlock)(NSError *error);
@interface LTNetWorkBaseRequest : NSObject

@end

NS_ASSUME_NONNULL_END
