//
//  MyUIViewController.h
//  ToDoManager
//
//  Created by Mircea Popescu on 8/20/18.
//  Copyright © 2018 Mircea Popescu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPHandlesMOC.h"

@interface MyUIViewController : UIViewController <MPHandlesMOC>

- (void) receiveMOC:(NSManagedObjectContext *)incomingMOC;

@end
