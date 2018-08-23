//
//  MyUINavigationController.m
//  ToDoManager
//
//  Created by Mircea Popescu on 8/20/18.
//  Copyright © 2018 Mircea Popescu. All rights reserved.
//

#import "MyUINavigationController.h"

@interface MyUINavigationController ()

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation MyUINavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) receiveMOC:(NSManagedObjectContext *)incomingMOC{
    
    _managedObjectContext = incomingMOC;
    // Passed down to the child(TableViewControler in our case) the ManagedObjectContext
    id<MPHandlesMOC> child = (id<MPHandlesMOC>) self.viewControllers[0];
    [child receiveMOC:_managedObjectContext];
    
}

@end
