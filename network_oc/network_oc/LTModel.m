//
//  LTModel.m
//  network_oc
//
//  Created by 8000yi on 2020/12/30.
//

#import "LTModel.h"

@implementation LTModel

- (instancetype)initWithDictionarylt:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dictionary];
    }
    return self;
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

+(instancetype)modelWithDictionary:(NSDictionary *)dict {
    
    LTModel *model = [[self alloc] initWithDictionarylt:dict];
    return model;
}
@end
