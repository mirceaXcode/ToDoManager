//
//  ToDoEntity+CoreDataProperties.m
//  ToDoManager
//
//  Created by Mircea Popescu on 8/20/18.
//  Copyright © 2018 Mircea Popescu. All rights reserved.
//
//

#import "ToDoEntity+CoreDataProperties.h"

@implementation ToDoEntity (CoreDataProperties)

+ (NSFetchRequest<ToDoEntity *> *)fetchRequest {
	return [NSFetchRequest fetchRequestWithEntityName:@"ToDoEntity"];
}

@dynamic toDoTitle;
@dynamic toDoDetails;
@dynamic toDoDueDate;

@end
