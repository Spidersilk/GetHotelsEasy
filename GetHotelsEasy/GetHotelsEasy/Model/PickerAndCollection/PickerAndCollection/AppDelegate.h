//
//  AppDelegate.h
//  PickerAndCollection
//
//  Created by admin on 2017/8/26.
//  Copyright © 2017年 Education. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end
