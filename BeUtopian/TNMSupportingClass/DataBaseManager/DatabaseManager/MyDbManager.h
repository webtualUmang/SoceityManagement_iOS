//
//  MyDbManager.h
//  DataBase
//
//  Created by Jigar Zalavadiya on 24/01/14.
//  Copyright (c) 2014 OEPL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface MyDbManager : NSObject
{
    NSString *databasePath, *databaseFavoritesPath;

}
@property (strong, nonatomic) NSString *databasePath;
@property (strong, nonatomic) NSString *databaseFavoritesPath;

-(void)myDbPath;

+(MyDbManager *)sharedClass ;

-(NSMutableArray *)SelectFieldFromTable: (NSString* )TableName FieldList:(NSArray *)fieldList WhereFieldName:(NSString *)fieldName ValuesEqueal:(NSString *)value Duplicate:(NSString*)DuplicateFieldName;
-(NSMutableArray *)ExecuteQuery: (NSString* )querySQL;
-(NSMutableArray *)ExicuteSQLiteQuery: (NSString* )query;

- (NSString *) GetSum;
-(NSMutableArray *)SelectFieldFromTable: (NSString* )TableName FieldList:(NSArray *)fieldList WhereFieldName:(NSString *)fieldName1 ValuesEqueal1:(NSString *)value FiledName2:(NSString*)FielName2 ValuesEqueal2:(NSString *)value2 limit:(NSString*)limit Duplicate:(NSString*)DuplicateFieldName;
-(NSMutableArray *)ExecuteQueryCountWithField: (NSString* )querySQL;
-(NSMutableArray *)SelectFieldFromTableNew: (NSString* )TableName FieldList:(NSArray *)fieldList WhereFieldName:(NSString *)fieldName ValuesEqueal:(NSString *)value Duplicate:(NSString*)DuplicateFieldName;
-(NSMutableArray *)Sorting: (NSMutableArray* )arrayOfDictionaries sortBool:(BOOL)Flag SortingKey:(NSString *)Key;
-(NSMutableArray*)DateSorting:(NSArray*)arrayOfData sortBool:(BOOL)flag sortingKey:(NSString*)key;

-(NSMutableArray *)SelectMultipleWhereFieldFromTable: (NSString* )TableName FieldList:(NSArray *)fieldList WhereFieldName:(NSString *)fieldName ValuesEqueal:(NSString *)value Duplicate:(NSString*)DuplicateFieldName;



-(BOOL)deleteData : (NSString *)strids;

//favourite
-(BOOL)saveMydata :(NSString *)strCompetitionType :(NSString *)strOpponentTeam :(NSString *)strMatchDate :(NSString *)strForGoal :(NSString *)strAgainGoal :(NSString *)strTeamName :(NSString *)strMatchID :(NSString *)favPlayerName :(NSString *)favPlayerDebutInfo :(NSString *)favPlayerStartingApp :(NSString *)favPlayerSubstiApp :(NSString *)favPlayerGoal :(NSString *)favPlayerID :(NSString *)favTypeID :(NSString *)favLoginID;

-(BOOL)deleteFavrtPlayer : (NSString *)strids;

-(BOOL)InsertInto:(NSString*)tableName Field:(NSDictionary*)data;

- (BOOL)updateName:(NSString*)tableName Field:(NSDictionary*)data whereField:(NSArray*)fieldName FieldValue:(NSArray*)fieldValue OR:(BOOL)isOr;
 
-(NSMutableArray *)SelectFieldFromTableFavorites: (NSString* )TableName FieldList:(NSArray *)fieldList WhereFieldName:(NSString *)fieldName ValuesEqueal:(NSString *)value Duplicate:(NSString*)DuplicateFieldName;

-(void)myDbPathFavourites;
-(NSMutableArray *)ExecuteSQLiteQueryForFavoritesTable: (NSString* )query;
+(MyDbManager *)sharedClassFavourites;

-(NSMutableArray *)SortingDate: (NSMutableArray* )arrayOfDictionaries sortBool:(BOOL)Flag SortingKey:(NSString *)Key;
@end
