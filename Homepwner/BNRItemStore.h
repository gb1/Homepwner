//
//  BNRItemStore.h
//  Homepwner
//
//  Created by Gregor Brett on 02/04/2013.
//  Copyright (c) 2013 Gregor Brett. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BNRItem;

@interface BNRItemStore : NSObject{
    NSMutableArray *allItems;
}


+(BNRItemStore *)sharedStore;
-(void)removeItem:(BNRItem *)p;
-(NSArray *)allItems;
-(BNRItem *)createItem;
-(void)moveItemAtIndex:(int)from toIndex:(int)to;

@end
