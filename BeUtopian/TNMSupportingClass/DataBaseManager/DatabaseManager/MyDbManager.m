//
//  MyDbManager.m
//  DataBase
//
//  Created by Jigar Zalavadiya on 24/01/14.
//  Copyright (c) 2014 OEPL. All rights reserved.
//

#import "MyDbManager.h"



static MyDbManager *sharedInstance = nil;
static MyDbManager *sharedInstanceFavourites = nil;
static sqlite3 *contactDB = nil;
static sqlite3 *contactDBFav = nil;

@implementation MyDbManager
@synthesize databasePath, databaseFavoritesPath;

+(MyDbManager *)sharedClass
{
    if (!sharedInstance)
    {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance myDbPath];
    }
    return sharedInstance;
}
+(MyDbManager *)sharedClassFavourites
{
    if (!sharedInstanceFavourites)
    {
        sharedInstanceFavourites = [[super allocWithZone:NULL]init];
        [sharedInstanceFavourites myDbPathFavourites];
    }
    return sharedInstanceFavourites;
}
-(void)myDbPath
{
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    databasePath = [[NSString alloc]initWithString: [docsDir stringByAppendingPathComponent:@"/BeUtopian.sqlite"]];
}
-(void)myDbPathFavourites
{
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    databaseFavoritesPath = [[NSString alloc]initWithString: [docsDir stringByAppendingPathComponent:@"/favorites.sqlite"]];
}

- (int) GetArticlesCount
{
    int count = 0;
    if (sqlite3_open([self.databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        const char* sqlStatement = "SELECT COUNT(*) FROM Photos";
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(contactDB, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                count = sqlite3_column_int(statement, 0);
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(contactDB) );
        }
        // Finalize and close database.
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    
    return count;
}

- (NSString *) GetSum
{
    NSString *count = @"";
    if (sqlite3_open([self.databasePath UTF8String], &contactDB) == SQLITE_OK)
    {
        const char* sqlStatement = "SELECT sum(TotalPrice) FROM Photos";
        sqlite3_stmt *statement;
        
        if( sqlite3_prepare_v2(contactDB, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            //Loop through all the returned rows (should be just one)
            while( sqlite3_step(statement) == SQLITE_ROW )
            {
                //count = sqlite3_column_text(statement, 0);
                 count = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement, 0)];
            }
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(contactDB) );
        }
        // Finalize and close database.
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    
    return count;
}
-(NSMutableArray *)Sorting: (NSMutableArray* )arrayOfDictionaries sortBool:(BOOL)Flag SortingKey:(NSString *)Key{
    
    NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:Key ascending:Flag comparator:^(id obj1, id obj2) {
        
        if ([obj1 integerValue] > [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1 integerValue] < [obj2 integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    NSMutableArray *myList = [NSMutableArray arrayWithArray:[arrayOfDictionaries sortedArrayUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]]];
    
    return myList;
}

-(NSMutableArray*)DateSorting:(NSArray*)arrayOfData sortBool:(BOOL)flag sortingKey:(NSString*)key {

    NSSortDescriptor *dateDescriptor = [NSSortDescriptor
                                        sortDescriptorWithKey:key
                                        ascending:flag];
    NSArray *sortDescriptors = [NSArray arrayWithObject:dateDescriptor];
    NSMutableArray *sortedEventArray = [NSMutableArray arrayWithArray:[arrayOfData
                                                                       sortedArrayUsingDescriptors:sortDescriptors]];

    return sortedEventArray;
    
}
-(NSMutableArray *)SelectFieldFromTable: (NSString* )TableName FieldList:(NSArray *)fieldList WhereFieldName:(NSString *)fieldName ValuesEqueal:(NSString *)value Duplicate:(NSString*)DuplicateFieldName{
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrMyData =[[NSMutableArray alloc] init];
    
//    SELECT count(DISTINCT no) FROM hatTricks group by hattrickID
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
 

        NSString *querySQL = @"SELECT";
        
        if (![DuplicateFieldName isEqualToString:@""]) {
            querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" DISTINCT %@",DuplicateFieldName]];
            querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" FROM %@",TableName]];
        }else{
            int index = 0;
            
            for (NSString *fieldStr in fieldList) {
                querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" %@",fieldStr]];
                index ++;
                
                if (index == fieldList.count) {
                   
                    querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" FROM %@",TableName]];
                }else{
                    querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@","]];
                }
            }
//            NSLog(@"query : %@",querySQL);
            
//            if ([wehereFieldArray count] > 0) {
//                for (NSString *fieldStr in wehereFieldArray) {
//                    querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" WHERE %@=\"%@\"",fieldStr, value]];
//                }
//            }
            if (![fieldName isEqualToString:@""]) {
                querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" WHERE %@=\"%@\"",fieldName, value]];
            }
        }
        
        
//        NSLog(@"query : %@",querySQL);
        
//        NSString *querySQL = [NSString stringWithFormat:@"SELECT sub1, sub2 FROM %@ ", TableName];
        
        //  @"delete from Photos Where PhotoDetailID= \"%@\"",strids];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSInteger columnCount = sqlite3_column_count(statement);
            id value;
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                
                for (int i = 0; i < columnCount; i++) {
                    
                    NSString *columnName   = [NSString stringWithUTF8String:sqlite3_column_name(statement, i)];
                    switch (sqlite3_column_type(statement, i)) {
                        case SQLITE_NULL:
                            value = @"";
                            break;
                        case SQLITE_TEXT:
                            value = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, i)];
                            break;
                        case SQLITE_INTEGER:
                            value = @(sqlite3_column_int64(statement, i));
                            break;
                        case SQLITE_FLOAT:
                            value = @(sqlite3_column_double(statement, i));
                            break;
                        case SQLITE_BLOB:
                        {
                            NSInteger length  = sqlite3_column_bytes(statement, i);
                            const void *bytes = sqlite3_column_blob(statement, i);
                            value = [NSData dataWithBytes:bytes length:length];
                            break;
                        }
                        default:
                            NSLog(@"unknown column type");
                            value = @"";
                            break;
                    }
                    dictionary[columnName] = value;
                }
                
                [arrMyData addObject:dictionary];
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDB);
    }
    return arrMyData;
}

-(NSMutableArray *)ExecuteQuery: (NSString* )querySQL{
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrMyData =[[NSMutableArray alloc] init];
    
    //    SELECT count(DISTINCT no) FROM hatTricks group by hattrickID
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSInteger columnCount = sqlite3_column_count(statement);
            id value;
            id tempEncode;
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                
                for (int i = 0; i < columnCount; i++) {
                    
                    NSString *columnName   = [NSString stringWithUTF8String:sqlite3_column_name(statement, i)];
                    switch (sqlite3_column_type(statement, i)) {
                        case SQLITE_NULL:
                            value = @"";
                            break;
                        case SQLITE_TEXT:
                            tempEncode = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, i)];
                            value = [self getDecode:tempEncode];
                            break;
                        case SQLITE_INTEGER:
                            value = @(sqlite3_column_int64(statement, i));
                            break;
                        case SQLITE_FLOAT:
                            value = @(sqlite3_column_double(statement, i));
                            break;
                        case SQLITE_BLOB:
                        {
                            NSInteger length  = sqlite3_column_bytes(statement, i);
                            const void *bytes = sqlite3_column_blob(statement, i);
                            value = [NSData dataWithBytes:bytes length:length];
                            break;
                        }
                        default:
                            NSLog(@"unknown column type");
                            value = @"";
                            break;
                    }
                    dictionary[@"count"] = value;
                }
                
                [arrMyData addObject:dictionary];
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDB);
    }
    return arrMyData;
}

-(NSMutableArray *)SelectFieldFromTable: (NSString* )TableName FieldList:(NSArray *)fieldList WhereFieldName:(NSString *)fieldName1 ValuesEqueal1:(NSString *)value FiledName2:(NSString*)FielName2 ValuesEqueal2:(NSString *)value2 limit:(NSString*)limit Duplicate:(NSString*)DuplicateFieldName
{
    
    const char *dbpath = [databasePath UTF8String];
    
    sqlite3_stmt    *statement;
    
    
    
    NSMutableArray *arrMyData =[[NSMutableArray alloc] init];
    
    
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        
    {
        
        // NSData *encodeData = [value dataUsingEncoding:NSUTF8StringEncoding];
        
        // NSString *base64String = [encodeData base64EncodedStringWithOptions:0];
        
        // NSLog(@"Encode String Value: %@", base64String);
        
        
        
        //        NSString *querySQL = [NSString stringWithFormat:@"SELECT sub1, sub2 FROM %@ WHERE %@=\"%@\"", TableName, fieldName, value];
        
        
        
        //        NSString *querySQL = [NSString stringWithFormat:@"SELECT DISTINCT competition FROM %@",TableName];
        
        
        
        NSString *querySQL = @"SELECT";
        
        
        
        if (![DuplicateFieldName isEqualToString:@""]) {
            
            querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" DISTINCT %@",DuplicateFieldName]];
            
            querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" FROM %@",TableName]];
            
        }else{
            
            int index = 0;
            
            
            
            
            
            for (NSString *fieldStr in fieldList) {
                
                querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" %@",fieldStr]];
                
                index ++;
                
                
                
                if (index == fieldList.count) {
                    
                    
                    
                    querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" FROM %@",TableName]];
                    
                }else{
                    
                    querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@","]];
                    
                }
                
            }
            
            //            NSLog(@"query : %@",querySQL);
            
            
            
            if (![fieldName1 isEqualToString:@""]) {
                
                if(![limit isEqualToString:@""]){
                    querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" WHERE %@=\"%@\" AND %@=\"%@\" LIMIT %@",fieldName1, value,FielName2,value2,limit]];
                }else{
                    querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" WHERE %@=\"%@\" AND %@=\"%@\"",fieldName1, value,FielName2,value2]];
                }
            }
            
//            NSLog(@"Final Query = %@ ",querySQL);
            
            
            
        }
        
        
        
        
        
        //        NSLog(@"query : %@",querySQL);
        
        
        
        //        NSString *querySQL = [NSString stringWithFormat:@"SELECT sub1, sub2 FROM %@ ", TableName];
        
        
        
        //  @"delete from Photos Where PhotoDetailID= \"%@\"",strids];
        
        
        
        const char *query_stmt = [querySQL UTF8String];
        
        
        
        if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
            
        {
            
            NSInteger columnCount = sqlite3_column_count(statement);
            
            id value;
            
            
            
            while (sqlite3_step(statement) == SQLITE_ROW)
                
            {
                
                
                
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                
                
                
                for (int i = 0; i < columnCount; i++) {
                    
                    
                    
                    NSString *columnName   = [NSString stringWithUTF8String:sqlite3_column_name(statement, i)];
                    
                    switch (sqlite3_column_type(statement, i)) {
                            
                        case SQLITE_NULL:
                            
                            value = @"";
                            
                            break;
                            
                        case SQLITE_TEXT:
                            
                            value = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, i)];
                            
                            break;
                            
                        case SQLITE_INTEGER:
                            
                            value = @(sqlite3_column_int64(statement, i));
                            
                            break;
                            
                        case SQLITE_FLOAT:
                            
                            value = @(sqlite3_column_double(statement, i));
                            
                            break;
                            
                        case SQLITE_BLOB:
                            
                        {
                            
                            NSInteger length  = sqlite3_column_bytes(statement, i);
                            
                            const void *bytes = sqlite3_column_blob(statement, i);
                            
                            value = [NSData dataWithBytes:bytes length:length];
                            
                            break;
                            
                        }
                            
                        default:
                            
                            NSLog(@"unknown column type");
                            
                            value = @"";
                            
                            break;
                            
                    }
                    
                    dictionary[columnName] = value;
                    
                }
                
                
                
                [arrMyData addObject:dictionary];
                
            }
            
            sqlite3_finalize(statement);
            
        }
        
        
        
        sqlite3_close(contactDB);
        
    }
    
    return arrMyData;
    
}


-(NSMutableArray *)ExecuteQueryCountWithField: (NSString* )querySQL{
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrMyData =[[NSMutableArray alloc] init];
    
    //    SELECT count(DISTINCT no) FROM hatTricks group by hattrickID
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSInteger columnCount = sqlite3_column_count(statement);
            id value;
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                
                for (int i = 0; i < columnCount; i++) {
                    
                    NSString *columnName   = [NSString stringWithUTF8String:sqlite3_column_name(statement, i)];
                    switch (sqlite3_column_type(statement, i)) {
                        case SQLITE_NULL:
                            value = @"";
                            break;
                        case SQLITE_TEXT:
                            value = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, i)];
                            break;
                        case SQLITE_INTEGER:
                            value = @(sqlite3_column_int64(statement, i));
                            break;
                        case SQLITE_FLOAT:
                            value = @(sqlite3_column_double(statement, i));
                            break;
                        case SQLITE_BLOB:
                        {
                            NSInteger length  = sqlite3_column_bytes(statement, i);
                            const void *bytes = sqlite3_column_blob(statement, i);
                            value = [NSData dataWithBytes:bytes length:length];
                            break;
                        }
                        default:
                            NSLog(@"unknown column type");
                            value = @"";
                            break;
                    }
                    if([columnName  isEqual: @"count(DISTINCT competition)"])
                    {
                        columnName = @"Count";
                    }
                    dictionary[columnName] = value;
                }
                
                [arrMyData addObject:dictionary];
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDB);
    }
    return arrMyData;
}
-(NSMutableArray *)SelectFieldFromTableNew: (NSString* )TableName FieldList:(NSArray *)fieldList WhereFieldName:(NSString *)fieldName ValuesEqueal:(NSString *)value Duplicate:(NSString*)DuplicateFieldName{
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrMyData =[[NSMutableArray alloc] init];
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        
        NSString *querySQL = @"SELECT";
        
        if (![DuplicateFieldName isEqualToString:@""]) {
            querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" DISTINCT %@",DuplicateFieldName]];
            querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" FROM %@",TableName]];
        }else{
            int index = 0;
            
            for (NSString *fieldStr in fieldList) {
                querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" %@",fieldStr]];
                index ++;
                
                if (index == fieldList.count) {
                    
                    querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" FROM %@",TableName]];
                }else{
                    querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@","]];
                }
            }
            
            if (![fieldName isEqualToString:@""]) {
                querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" WHERE %@=\"%@\" ORDER BY date(attendance) ASC LIMIT 25",fieldName, value]];
            }
        }
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSInteger columnCount = sqlite3_column_count(statement);
            id value;
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                
                for (int i = 0; i < columnCount; i++) {
                    
                    NSString *columnName   = [NSString stringWithUTF8String:sqlite3_column_name(statement, i)];
                    switch (sqlite3_column_type(statement, i)) {
                        case SQLITE_NULL:
                            value = @"";
                            break;
                        case SQLITE_TEXT:
                            value = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, i)];
                            break;
                        case SQLITE_INTEGER:
                            value = @(sqlite3_column_int64(statement, i));
                            break;
                        case SQLITE_FLOAT:
                            value = @(sqlite3_column_double(statement, i));
                            break;
                        case SQLITE_BLOB:
                        {
                            NSInteger length  = sqlite3_column_bytes(statement, i);
                            const void *bytes = sqlite3_column_blob(statement, i);
                            value = [NSData dataWithBytes:bytes length:length];
                            break;
                        }
                        default:
                            NSLog(@"unknown column type");
                            value = @"";
                            break;
                    }
                    dictionary[columnName] = value;
                }
                
                [arrMyData addObject:dictionary];
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDB);
    }
    return arrMyData;
}






//MARK:- MultipleWhere

-(NSMutableArray *)SelectMultipleWhereFieldFromTable: (NSString* )TableName FieldList:(NSArray *)fieldList WhereFieldName:(NSString *)fieldName ValuesEqueal:(NSString *)value Duplicate:(NSString*)DuplicateFieldName{
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrMyData =[[NSMutableArray alloc] init];
    
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = @"SELECT";
        
        if (![DuplicateFieldName isEqualToString:@""]) {
            querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" DISTINCT %@",DuplicateFieldName]];
            querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" FROM %@",TableName]];
        }else{
            int index = 0;
            
            for (NSString *fieldStr in fieldList) {
                querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" %@",fieldStr]];
                index ++;
                
                if (index == fieldList.count) {
                    
                    querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" FROM %@",TableName]];
                }else{
                    querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@","]];
                }
            }
            if (![fieldName isEqualToString:@""]) {
                querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" WHERE %@",fieldName]];
            }
            
        }
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSInteger columnCount = sqlite3_column_count(statement);
            id value;
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                
                for (int i = 0; i < columnCount; i++) {
                    
                    NSString *columnName   = [NSString stringWithUTF8String:sqlite3_column_name(statement, i)];
                    switch (sqlite3_column_type(statement, i)) {
                        case SQLITE_NULL:
                            value = @"";
                            break;
                        case SQLITE_TEXT:
                            value = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, i)];
                            break;
                        case SQLITE_INTEGER:
                            value = @(sqlite3_column_int64(statement, i));
                            break;
                        case SQLITE_FLOAT:
                            value = @(sqlite3_column_double(statement, i));
                            break;
                        case SQLITE_BLOB:
                        {
                            NSInteger length  = sqlite3_column_bytes(statement, i);
                            const void *bytes = sqlite3_column_blob(statement, i);
                            value = [NSData dataWithBytes:bytes length:length];
                            break;
                        }
                        default:
                            NSLog(@"unknown column type");
                            value = @"";
                            break;
                    }
                    dictionary[columnName] = value;
                }
                
                [arrMyData addObject:dictionary];
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDB);
    }
    return arrMyData;
}



#pragma mark - Exicute Sqlite Static Condition -
//commond
-(NSMutableArray *)ExicuteSQLiteQuery: (NSString* )query
{
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrMyData =[[NSMutableArray alloc] init];
    
    //    SELECT count(DISTINCT no) FROM hatTricks group by hattrickID
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        
        NSString *querySQL = query;
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDB,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSInteger columnCount = sqlite3_column_count(statement);
            id value;
            id tempEncode;
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                
                for (int i = 0; i < columnCount; i++) {
                    
                    NSString *columnName   = [NSString stringWithUTF8String:sqlite3_column_name(statement, i)];
                    switch (sqlite3_column_type(statement, i)) {
                        case SQLITE_NULL:
                            value = @"";
                            break;
                        case SQLITE_TEXT:
                            tempEncode = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, i)];
                            value = [self getDecode:tempEncode];
                            if([value isEqualToString:@""] || value == nil){
                                value = tempEncode;
                            }
                            break;
                        case SQLITE_INTEGER:
                            value = @(sqlite3_column_int64(statement, i));
                            break;
                        case SQLITE_FLOAT:
                            value = @(sqlite3_column_double(statement, i));
                            break;
                        case SQLITE_BLOB:
                        {
                            NSInteger length  = sqlite3_column_bytes(statement, i);
                            const void *bytes = sqlite3_column_blob(statement, i);
                            value = [NSData dataWithBytes:bytes length:length];
                            break;
                        }
                        default:
                            NSLog(@"unknown column type");
                            value = @"";
                            break;
                    }
                    dictionary[columnName] = value;
                }
                
                [arrMyData addObject:dictionary];
            }
            
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(contactDB);
    }
    return arrMyData;
}
-(NSString*)getEncode:(NSString*)valueStr {
    NSData *encodeData = [valueStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [encodeData base64EncodedStringWithOptions:0];
    return base64String;
}
-(NSString*)getDecode:(NSString*)valueStr {
    
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:valueStr options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    if (decodedString) {
        return decodedString;
    }
    return valueStr;
    
}
-(BOOL)InsertInto:(NSString*)tableName Field:(NSDictionary*)data
{
    
    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        
        NSString *fieldStr = @"(";
        NSString *valueStr = @"(";
        
        NSInteger index = 0;
        for (NSString *tempStr in data.allKeys) {
            fieldStr = [fieldStr stringByAppendingString:tempStr];
            
            
            if ([[data objectForKey:tempStr] isKindOfClass:[NSNumber class]]) {
               NSString *newValues = [data objectForKey:tempStr];
                valueStr = [valueStr stringByAppendingString:[NSString stringWithFormat:@"\"%@\"",newValues]];
            }else{
                
                
                NSString *newValues = [data objectForKey:tempStr];
                
                int ids = [newValues intValue];
                if(ids != 0){
                    valueStr = [valueStr stringByAppendingString:[NSString stringWithFormat:@"\"%@\"",newValues]];
                }
                else{
                   valueStr = [valueStr stringByAppendingString:[NSString stringWithFormat:@"\"%@\"",[self getEncode:newValues]]];
                }
            }
                       
            
            
            index ++;
            if (data.allKeys.count <= index) {
                fieldStr = [fieldStr stringByAppendingString:@")"];
                valueStr = [valueStr stringByAppendingString:@")"];
            }else{
                fieldStr = [fieldStr stringByAppendingString:@","];
                valueStr = [valueStr stringByAppendingString:@","];
            }
        }
        
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO %@ %@ VALUES %@",tableName,fieldStr,valueStr];
        
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(contactDB, insert_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_finalize(statement);
            sqlite3_close(contactDB);
            return YES;
            
        } else {
            sqlite3_finalize(statement);
            sqlite3_close(contactDB);
            return NO;
        }
        
    }
    return NO;
}

- (BOOL)updateName:(NSString*)tableName Field:(NSDictionary*)data whereField:(NSArray*)fieldName FieldValue:(NSArray*)fieldValue OR:(BOOL)isOr{

    sqlite3_stmt    *statement;
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        
        NSString *valueStr = @"";
        
        NSInteger index = 0;
        for (NSString *tempStr in data.allKeys) {
            
            
            if ([[data objectForKey:tempStr] isKindOfClass:[NSNumber class]]) {
                NSString *newValues = [data objectForKey:tempStr];
                valueStr = [valueStr stringByAppendingString:[NSString stringWithFormat:@"%@ = '%@'",tempStr,newValues]];
            }else{
                
                NSString *newValues = [data objectForKey:tempStr];
                
                int ids = [newValues intValue];
                if(ids != 0){
                     valueStr = [valueStr stringByAppendingString:[NSString stringWithFormat:@"%@ = '%@'",tempStr,newValues]];
                }
                else{
                     valueStr = [valueStr stringByAppendingString:[NSString stringWithFormat:@"%@ = '%@'",tempStr,[self getEncode:newValues]]];
                }
            }
            
            
            
            
            index ++;
            
            if (data.allKeys.count <= index) {
                
            }else{
                
                valueStr = [valueStr stringByAppendingString:@","];
            }
        }
        
        
        //Where Condition
        NSString *whereCondtition = @"";
        
        if (fieldName.count > 0) {
            whereCondtition = @"WHERE ";
        }
        NSInteger whereIndex = 0;
        for (NSString *tempStr in fieldName) {
            NSString *value = @"";
            if ([fieldValue count] > whereIndex) {
                value = [fieldValue objectAtIndex:whereIndex];
            }
            
            whereCondtition = [whereCondtition stringByAppendingString:[NSString stringWithFormat:@"%@ = \"%@\"",tempStr,value]];
            
            whereIndex ++;
            
            if (fieldName.count <= whereIndex) {
                
            }else{
                if (isOr == true) {
                    whereCondtition = [whereCondtition stringByAppendingString:@" OR "];
                }else{
                    whereCondtition = [whereCondtition stringByAppendingString:@" AND "];
                }
                
            }
        }

        
        NSString *insertSQL = [NSString stringWithFormat:@"update %@ set %@ %@",tableName,valueStr,whereCondtition];
//        NSLog(@"%@",insertSQL);
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(contactDB, insert_stmt,
                           -1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_finalize(statement);
            sqlite3_close(contactDB);
            return YES;
            
        } else {
            sqlite3_finalize(statement);
            sqlite3_close(contactDB);
            return NO;
        }
        
    }
    return NO;
    
    
}

//MARK:-  Favorites Queries

-(BOOL)saveMydata :(NSString *)strCompetitionType :(NSString *)strOpponentTeam :(NSString *)strMatchDate :(NSString *)strForGoal :(NSString *)strAgainGoal :(NSString *)strTeamName :(NSString *)strMatchID :(NSString *)favPlayerName :(NSString *)favPlayerDebutInfo :(NSString *)favPlayerStartingApp :(NSString *)favPlayerSubstiApp :(NSString *)favPlayerGoal :(NSString *)favPlayerID :(NSString *)favTypeID :(NSString *)favLoginID
{
    sqlite3_stmt    *statement;

    const char *dbpath = [databaseFavoritesPath UTF8String];
    
    //contactDBFav
    if (sqlite3_open(dbpath, &contactDBFav) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO favorite (competitionType, opponentTeam, matchDate,forGoal,againGoal,teamName,MatchID,favPlayerName,favPlayerDebutInfo,favPlayerStartingApp,favPlayerSubstiApp,favPlayerGoal,favPlayerID,favTypeID,LoginID) VALUES (\"%@\", \"%@\", \"%@\",\"%@\", \"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\",\"%@\")",strCompetitionType, strOpponentTeam, strMatchDate,strForGoal,strAgainGoal,strTeamName,strMatchID,favPlayerName,favPlayerDebutInfo,favPlayerStartingApp,favPlayerSubstiApp,favPlayerGoal,favPlayerID,favTypeID,favLoginID];
        
        
        const char *insert_stmt = [insertSQL UTF8String];
        
        sqlite3_prepare_v2(contactDBFav, insert_stmt,
                           -1, &statement, NULL);
        
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_finalize(statement);
            sqlite3_close(contactDBFav);
            return YES;
            
        }
        else {
            NSLog(@"%d",SQLITE_ERROR);
            NSLog(@"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(contactDB) );
            sqlite3_finalize(statement);
            sqlite3_close(contactDBFav);
            return NO;
        }
        
        
    }
    return NO;
}

-(NSMutableArray *)SelectFieldFromTableFavorites: (NSString* )TableName FieldList:(NSArray *)fieldList WhereFieldName:(NSString *)fieldName ValuesEqueal:(NSString *)value Duplicate:(NSString*)DuplicateFieldName
{
    
    const char *dbpath = [databaseFavoritesPath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrMyData =[[NSMutableArray alloc] init];
    

    
    if (sqlite3_open(dbpath, &contactDBFav) == SQLITE_OK)
    {
        
        
        NSString *querySQL = @"SELECT";
        
        if (![DuplicateFieldName isEqualToString:@""])
        {
            querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" DISTINCT %@",DuplicateFieldName]];
            querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" FROM %@",TableName]];
        }
        else
        {
            int index = 0;
            
            for (NSString *fieldStr in fieldList)
            {
                querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" %@",fieldStr]];
                index ++;
                
                if (index == fieldList.count)
                {
                    
                    querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" FROM %@",TableName]];
                }
                else
                {
                    querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@","]];
                }
            }

            if (![fieldName isEqualToString:@""])
            {
                querySQL = [querySQL stringByAppendingString:[NSString stringWithFormat:@" WHERE %@=\"%@\"",fieldName, value]];
            }
        }
        

        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDBFav,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSInteger columnCount = sqlite3_column_count(statement);
            id value;
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                
                for (int i = 0; i < columnCount; i++)
                {
                    
                    NSString *columnName   = [NSString stringWithUTF8String:sqlite3_column_name(statement, i)];
                    switch (sqlite3_column_type(statement, i)) {
                        case SQLITE_NULL:
                            value = @"";
                            break;
                        case SQLITE_TEXT:
                            value = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, i)];
                            break;
                        case SQLITE_INTEGER:
                            value = @(sqlite3_column_int64(statement, i));
                            break;
                        case SQLITE_FLOAT:
                            value = @(sqlite3_column_double(statement, i));
                            break;
                        case SQLITE_BLOB:
                        {
                            NSInteger length  = sqlite3_column_bytes(statement, i);
                            const void *bytes = sqlite3_column_blob(statement, i);
                            value = [NSData dataWithBytes:bytes length:length];
                            break;
                        }
                        default:
                            NSLog(@"unknown column type");
                            value = @"";
                            break;
                    }
                    dictionary[columnName] = value;
                }
                
                [arrMyData addObject:dictionary];
            }
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(contactDBFav);
    }
    return arrMyData;
}

-(BOOL)deleteFavrtPlayer : (NSString *)strids
{
    sqlite3_stmt    *statement;
    const char *dbpath = [databaseFavoritesPath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDBFav) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"delete from favorite Where favPlayerName= \"%@\"",strids];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(contactDBFav, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_finalize(statement);
            sqlite3_close(contactDBFav);
            return YES;
        } else {
            sqlite3_finalize(statement);
            sqlite3_close(contactDBFav);
            return NO;
        }
        
    }
    return NO;
    
}
-(BOOL)deleteData : (NSString *)strids
{
    
    sqlite3_stmt    *statement;
    const char *dbpath = [databaseFavoritesPath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDBFav) == SQLITE_OK)
    {
        
        NSString *insertSQL = [NSString stringWithFormat:
                               @"delete from favorite Where MatchID= \"%@\"",strids];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(contactDBFav, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            sqlite3_finalize(statement);
            sqlite3_close(contactDBFav);
            return YES;
        } else {
            sqlite3_finalize(statement);
            sqlite3_close(contactDBFav);
            return NO;
        }
        
    }
    return NO;
    
}
-(NSMutableArray *)ExecuteSQLiteQueryForFavoritesTable: (NSString* )query
{
    const char *dbpath = [databaseFavoritesPath UTF8String];
    sqlite3_stmt    *statement;
    
    NSMutableArray *arrMyData =[[NSMutableArray alloc] init];
    
    //    SELECT count(DISTINCT no) FROM hatTricks group by hattrickID
    
    if (sqlite3_open(dbpath, &contactDBFav) == SQLITE_OK)
    {
        
        NSString *querySQL = query;
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(contactDBFav,query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            NSInteger columnCount = sqlite3_column_count(statement);
            id value;
            
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                
                for (int i = 0; i < columnCount; i++)
                {
                    
                    NSString *columnName   = [NSString stringWithUTF8String:sqlite3_column_name(statement, i)];
                    switch (sqlite3_column_type(statement, i)) {
                        case SQLITE_NULL:
                            value = @"";
                            break;
                        case SQLITE_TEXT:
                            value = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, i)];
                            break;
                        case SQLITE_INTEGER:
                            value = @(sqlite3_column_int64(statement, i));
                            break;
                        case SQLITE_FLOAT:
                            value = @(sqlite3_column_double(statement, i));
                            break;
                        case SQLITE_BLOB:
                        {
                            NSInteger length  = sqlite3_column_bytes(statement, i);
                            const void *bytes = sqlite3_column_blob(statement, i);
                            value = [NSData dataWithBytes:bytes length:length];
                            break;
                        }
                        default:
                            NSLog(@"unknown column type");
                            value = @"";
                            break;
                    }
                    dictionary[columnName] = value;
                }
                
                [arrMyData addObject:dictionary];
            }
            
            sqlite3_finalize(statement);
            
        }
        
        sqlite3_close(contactDBFav);
    }
    return arrMyData;
}

-(NSMutableArray *)SortingDate: (NSMutableArray* )arrayOfDictionaries sortBool:(BOOL)Flag SortingKey:(NSString *)Key{
    
    NSSortDescriptor *aSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:Key ascending:Flag comparator:^(NSDate *obj1, NSDate *obj2) {
        
        if (obj1 > obj2) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if (obj1 < obj2) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    NSMutableArray *myList = [NSMutableArray arrayWithArray:[arrayOfDictionaries sortedArrayUsingDescriptors:[NSArray arrayWithObject:aSortDescriptor]]];
    
    return myList;
}
@end
