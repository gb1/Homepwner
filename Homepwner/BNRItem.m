//
//  BNRItem.m
//  RandomPossessions
//
//  Created by Gregor Brett on 14/01/2013.
//  Copyright (c) 2013 Gregor Brett. All rights reserved.
//

#import "BNRItem.h"

@implementation BNRItem

@synthesize imageKey;

+(id)randomItem{
    
    NSArray *randomAdjectiveList = [NSArray arrayWithObjects:@"Fluffy", @"Rusty", @"Shiny", nil];
    NSArray *randomNounsList = [NSArray arrayWithObjects:@"Bear", @"Spork", @"Sheriffs Badge", nil];
    
    NSInteger adjectiveIndex = rand() % [randomAdjectiveList count];
    NSInteger nounIndexList = rand() % [randomNounsList count];
    
    NSString *randomName = [NSString stringWithFormat:@"%@ %@",
                            [randomAdjectiveList objectAtIndex:adjectiveIndex],
                            [randomNounsList objectAtIndex:nounIndexList]];
    int randomValue = rand() * 100;
    
    NSString *randomSerialNumber = [NSString stringWithFormat:@"%c%c%c%c%c",
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10,
                                    'A' + rand() % 26,
                                    '0' + rand() % 10];
    BNRItem *newItem = [[self alloc]initWithItemName:randomName valueInDollars:randomValue serialNumber:randomSerialNumber];
    return newItem;
}

-(id)init{
    return [self initWithItemName:@"Item" valueInDollars:0 serialNumber:@""];
}

-(id)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber{
    self = [super init];
    
    if(self){
        [self setItemName:name];
        [self setSerialNumber:sNumber];
        [self setValueInDollars:value];
        dateCreated = [[NSDate alloc]init];
    }
    return self;
}


-(void)setItemName:(NSString *)str{
    itemName = str;
}
-(NSString *)itemName{
    return itemName;
}

-(void)setSerialNumber:(NSString *)str{
    serialNumber = str;
}
-(NSString *)serialNumber{
    return serialNumber;
}

-(void)setValueInDollars:(int)i{
    valueInDollars = i;
}
-(int)valueInDollars{
    return valueInDollars;
}

-(NSDate *)dateCreated{
    return dateCreated;
}

-(NSString *)description{
    NSString *descriptionString = [[NSString alloc]initWithFormat:@"%@ (%@): Worth $%d, recorded on %@",
    itemName, serialNumber, valueInDollars, dateCreated ];
    
    return descriptionString;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:itemName forKey:@"itemName"];
    [aCoder encodeObject:serialNumber forKey:@"serialNumber"];
    [aCoder encodeObject:dateCreated forKey:@"dateCreated"];
    [aCoder encodeObject:imageKey forKey:@"imageKey"];
    [aCoder encodeInt:valueInDollars forKey:@"valueInDollars"];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if(self){
        [self setItemName:[aDecoder decodeObjectForKey:@"itemName"]];
        [self setSerialNumber:[aDecoder decodeObjectForKey:@"serialNumber"]];
        [self setImageKey:[aDecoder decodeObjectForKey:@"imageKey"]];
        [self setValueInDollars:[aDecoder decodeIntForKey:@"valueInDollars"]];
        
        dateCreated = [aDecoder decodeObjectForKey:@"dateCreated"];
    }
    
    return self;
}

@end
