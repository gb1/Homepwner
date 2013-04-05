//
//  BNRImageStore.h
//  Homepwner
//
//  Created by Gregor Brett on 03/04/2013.
//  Copyright (c) 2013 Gregor Brett. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRImageStore : NSObject{
    NSMutableDictionary *dictionary;
}

+(BNRImageStore *)sharedStore;
-(void)setImage:(UIImage *)i forKey:(NSString *)s;
-(UIImage *)imageForKey:(NSString *)s;
-(void)deleteImageForKey:(NSString *)s;
-(NSString *)imagePathForKey:(NSString *)key;

@end
