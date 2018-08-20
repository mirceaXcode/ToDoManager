//
//  MPHandlesToDoEntity.h
//  ToDoManager
//
//  Created by Mircea Popescu on 8/20/18.
//  Copyright © 2018 Mircea Popescu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MPHandlesToDoEntity <NSObject>

- (void) receiveToDoEntity:(NSManagedObjectContext * ) incomingToDoEntity;

@end
