//
//  BNRItemStore.m
//  Homepwner
//
//  Created by Gregor Brett on 02/04/2013.
//  Copyright (c) 2013 Gregor Brett. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRItem.h"

@implementation BNRItemStore

+(BNRItemStore *)sharedStore{
    static BNRItemStore *sharedStore = nil;
    if(!sharedStore){
        sharedStore = [[super allocWithZone:nil]init];
    }
    
    return sharedStore;
}

+(id)allocWithZone:(NSZone *)zone{
    return [self sharedStore];
}

-(id)init{
    self = [super init];
    if(self){
        allItems = [[NSMutableArray alloc]init];
    }
    
    return self;
}

-(NSArray *)allItems{
    return allItems;
}

-(BNRItem *)createItem{
    BNRItem *p = [BNRItem randomItem];
    [allItems addObject:p];
    return p;
}

-(void)removeItem:(BNRItem *)p{
    [allItems removeObjectIdenticalTo:p];
}

-(void)moveItemAtIndex:(int)from toIndex:(int)to{
    if(from == to){
        return;
    }
    BNRItem *p = [allItems objectAtIndex:from];
    
    [allItems removeObjectAtIndex:from];
    [allItems insertObject:p atIndex:to];
}


@end
