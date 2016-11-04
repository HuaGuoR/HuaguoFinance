#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DB : FMDatabase {
	//FMDatabase *db;
}

+(id)initFanweDb:(BOOL) debug;

/*
- (BOOL)initDatabase;
- (void)closeDatabase;
- (FMDatabase *)getDatabase;
*/
@end
