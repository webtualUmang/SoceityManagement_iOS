//
//  CopyData.m
//  Llyn
//
//  Created by tnmmac4 on 19/04/16.
//  Copyright © 2016 shoebpersonal. All rights reserved.
//

#import "CopyData.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "EncryptedStore.h"

#define USE_ENCRYPTED_STORE 1

@implementation CopyData

-(void)CoyDatabase {
    
 //   static NSPersistentStoreCoordinator *coordinator = nil;
    
    NSString *pathsToReources = [[NSBundle mainBundle] resourcePath];
    NSString *yourOriginalDatabasePath = [pathsToReources stringByAppendingPathComponent:@"BeUtopian.sqlite"];
    
    NSArray *pathsToDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathsToDocuments objectAtIndex: 0];
    
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"BeUtopian.sqlite"];
    NSLog(@"DataBase Path :: %@", dbPath);
    if (![[NSFileManager defaultManager] isReadableFileAtPath: dbPath]) {
        
        if ([[NSFileManager defaultManager] copyItemAtPath: yourOriginalDatabasePath toPath: dbPath error: NULL] != YES){
            NSLog(@"Fail to copy database from %@ to %@",yourOriginalDatabasePath, dbPath);
//            NSAssert2(0, @"Fail to copy database from %@ to %@", yourOriginalDatabasePath, dbPath);
        }
        
    }
}

-(void)RemoveDatabase {
    
    //   static NSPersistentStoreCoordinator *coordinator = nil;
    
//    NSString *pathsToReources = [[NSBundle mainBundle] resourcePath];
//    NSString *yourOriginalDatabasePath = [pathsToReources stringByAppendingPathComponent:@"50_ROOT.sqlite"];
    
    NSArray *pathsToDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [pathsToDocuments objectAtIndex: 0];
    
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"BeUtopian.sqlite"];
    NSLog(@"DataBase Path :: %@", dbPath);
    NSError *error;
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:dbPath]) {
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:dbPath error:&error];
        if (!success) {
            NSLog(@"Error removing file at path: %@", error.localizedDescription);
        }else{
             NSLog(@"Delete DB");
        }
    }
    
}

@end
