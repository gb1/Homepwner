//
//  BNRItem.h
//  RandomPossessions
//
//  Created by Gregor Brett on 14/01/2013.
//  Copyright (c) 2013 Gregor Brett. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem;

@interface BNRItem : NSObject{
    //instance variables
    NSString *itemName;
    NSString *serialNumber;
    int valueInDollars;
    NSDate *dateCreated;
}

@property (nonatomic, copy) NSString *imageKey;

+(id)randomItem;

//gg-(void)doSomethingWeird;

-(id)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber;

-(void)setItemName:(NSString *)str;
-(NSString *)itemName;

-(void)setSerialNumber:(NSString *)str;
-(NSString *)serialNumber;

-(void)setValueInDollars:(int)i;
-(int)valueInDollars;

-(NSDate *)dateCreated;

@end
