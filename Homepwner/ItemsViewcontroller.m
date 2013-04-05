//
//  ItemsViewcontroller.m
//  Homepwner
//
//  Created by Gregor Brett on 02/04/2013.
//  Copyright (c) 2013 Gregor Brett. All rights reserved.
//

#import "ItemsViewcontroller.h"
#import "BNRItemStore.h"
#import "BNRItem.h"

@implementation ItemsViewcontroller

-(id)init{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self){
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Homepwner"];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        [[self navigationItem] setRightBarButtonItem:bbi];
        
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
        
    }
    
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [[self tableView]reloadData];
    NSLog(@"ok got here");
}

-(id)initWithStyle:(UITableViewStyle)style{
    return [self init];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if(!cell){
    
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    }
    
    BNRItem *p = [[[BNRItemStore sharedStore]allItems]objectAtIndex:[indexPath row]];
    
    [[cell textLabel]setText:[p description]];
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[BNRItemStore sharedStore]allItems]count];
}

/*-(UIView *)headerView{
    if(!headerView){
        [[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self headerView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   return [[self headerView] bounds].size.height;
}

-(IBAction)toggleEditingMode:(id)sender{
    if([self isEditing]){
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        [self setEditing:NO animated:YES];
    }
    else{
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self setEditing:YES animated:YES];
    }
}*/

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        return YES;
    }else{
        return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
    }
}

-(IBAction)addNewItem:(id)sender{
    
    //int lastRow = [[self tableView]numberOfRowsInSection:0];
    
    BNRItem *newItem = [[BNRItemStore sharedStore]createItem];
    
    /*int lastRow = [[[BNRItemStore sharedStore]allItems]indexOfObject:newItem];
    
    NSIndexPath *ip = [NSIndexPath indexPathForRow:lastRow inSection:0];
    [[self tableView] insertRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationTop];
    */
    
    DetailViewController *detailViewController = [[DetailViewController alloc]initForNewItem:YES];
    [detailViewController setItem:newItem];
    
    [detailViewController setDimissBlock:^{[[self tableView] reloadData];}];
    
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:detailViewController];
    
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    
    [self presentViewController:navController animated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        BNRItemStore *ps = [BNRItemStore sharedStore];
        NSArray *items = [ps allItems];
        BNRItem *p = [items objectAtIndex:[indexPath row]];
        [ps removeItem:p];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}

-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    
    [[BNRItemStore sharedStore]moveItemAtIndex:[sourceIndexPath row] toIndex:[destinationIndexPath row]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //DetailViewController *detailViewController = [[DetailViewController alloc]init];
    
    DetailViewController *detailViewController = [[DetailViewController alloc]initForNewItem:NO];
    
    NSArray *items = [[BNRItemStore sharedStore]allItems];
    BNRItem *selectedItem = [items objectAtIndex:[indexPath row]];
    
    [detailViewController setItem:selectedItem];
    
    
    //push it onto the nav controller stack
    [[self navigationController]pushViewController:detailViewController animated:YES];
}




@end
