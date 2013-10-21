//
//  GenericService.h
//  ProofOfConcept
//
//  Created by Alex Gutierrez on 10/14/13.
//  Copyright (c) 2013 Alex Gutierrez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GenericService : NSObject

+ (instancetype)sharedInstance;

// Cleans up everything in memory
- (void)cleanUpDatabase;

// Only for migrations that are not lightweight
- (void)setupDatabaseForMigrationPolicies;

// Initialization of the database. Encapsulates the core data stack setup process
- (void)setupDatabase;

// Trucates records but doesn't delete the store
- (void)dropDatabase;

@end
