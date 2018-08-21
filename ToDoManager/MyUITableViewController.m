//
//  MyUITableViewController.m
//  ToDoManager
//
//  Created by Mircea Popescu on 8/20/18.
//  Copyright © 2018 Mircea Popescu. All rights reserved.
//

#import "MyUITableViewController.h"
#import <CoreData/CoreData.h>
#import "MyUITableViewCell.h"

@interface MyUITableViewController () <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) NSFetchedResultsController *resultsController;

@end

@implementation MyUITableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initialiseNSFetchedResultsControllerDelegate];
    
}

#pragma mark - TableView Delegates and data source

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _resultsController.sections[section].numberOfObjects;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ToDoEntity *item = _resultsController.sections[indexPath.section].objects[indexPath.row];
    
    MyUITableViewCell *cell = (MyUITableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"TableCellIdentifier" forIndexPath:indexPath];
    
    [cell setInternalFields:item];
    
    return cell;
}


#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
        
        id<MPHandlesMOC> child = (id<MPHandlesMOC>)[segue destinationViewController];
        [child receiveMOC:_managedObjectContext];

}

- (void) receiveMOC:(NSManagedObjectContext *)incomingMOC{
    
    _managedObjectContext = incomingMOC;
    
}


#pragma mark - NSFetchedResultsControllerDelegate

-(void) initialiseNSFetchedResultsControllerDelegate {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        
        fetchRequest.entity = [NSEntityDescription entityForName:@"ToDoEntity" inManagedObjectContext:_managedObjectContext];
        
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
        
        fetchRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"toDoTitle" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
        
        _resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:_managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        _resultsController.delegate = self;
        
        NSError *err;
        BOOL fetchSucceeded = [_resultsController performFetch:&err];
        if(!fetchSucceeded){
            @throw [NSException exceptionWithName:NSGenericException reason:@"Could't fetch!" userInfo:@{NSUnderlyingErrorKey:err}];
        }
        
}

-(void) controllerWillChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView beginUpdates];
}

-(void) controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath{
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:{
            MyUITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
            ToDoEntity *item = [controller objectAtIndexPath:indexPath];
            [cell setInternalFields:item];
            break;
        }
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

-(void) controllerDidChangeContent:(NSFetchedResultsController *)controller{
    [self.tableView endUpdates];
}


@end
