//
//  GenericService.m
//  ProofOfConcept
//
//  Created by Alex Gutierrez on 10/14/13.
//  Copyright (c) 2013 Alex Gutierrez. All rights reserved.
//

#import "GenericService.h"
#import "Entity.h"

@interface GenericService()

//Migration process using Migration Policies
- (void)migrateModel;

@end

@implementation GenericService

#pragma mark -
#pragma mark Class Methods

+ (instancetype)sharedInstance
{
    static GenericService *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [GenericService new];
    });
    return _sharedInstance;
}

#pragma mark -
#pragma mark Public Methods

- (void)cleanUpDatabase
{
    [MagicalRecord cleanUp];
}

- (void)setupDatabaseForMigrationPolicies
{
    [self migrateModel];
}

- (void)setupDatabase
{
    [MagicalRecord setShouldDeleteStoreOnModelMismatch:YES];
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:STORE_NAME];
}

- (void)dropDatabase
{
    [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
        [Entity truncateAllInContext:localContext];
    }];
}

#pragma mark -
#pragma mark Private Methods

- (void)migrateModel
{
    // Accessing the Persistent Store Coordinator
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [NSPersistentStoreCoordinator MR_coordinatorWithSqliteStoreNamed:STORE_NAME];
    
    // Accessing the Persistent Store Metadata
    NSString *sourceStoreType = NSSQLiteStoreType;
    NSURL *sourceStoreURL = [NSPersistentStore urlForStoreName:STORE_NAME];
    NSError *error = nil;
    
    NSDictionary *storeMetadata = [NSPersistentStoreCoordinator metadataForPersistentStoreOfType:sourceStoreType URL:sourceStoreURL error:&error];
    
    if (storeMetadata == nil) {
        DDLogError(@"GENERIC SERVICE: Migrate Model Method - Store metadata is nil");
    }
    
    // Accessing the Destination Managed Object Model from the Persistent Store Coordinator
    NSString *configuration = nil;
    NSManagedObjectModel *destinationModel = [persistentStoreCoordinator managedObjectModel];
    
    // Checking if the existing Persistent Store is compatible with the destination Model
    BOOL storeCompatible = [destinationModel isConfiguration:configuration compatibleWithStoreMetadata:storeMetadata];
    
    if (storeCompatible) {
        [MagicalRecord setupCoreDataStackWithStoreNamed:STORE_NAME];
    }
    else {
        // Getting the Source Managed Object Model from the documents directory (the one that is on the device right now)
        NSString *documentsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSBundle *bundleSourceModel = (NSBundle *)[NSBundle pathForResource:STORE_NAME ofType:@"sqlite" inDirectory:documentsDir];
        NSArray *bundlesForSourceModel = @[bundleSourceModel];
        NSManagedObjectModel *sourceModel = [NSManagedObjectModel mergedModelFromBundles:bundlesForSourceModel forStoreMetadata:storeMetadata];
        
        if (sourceModel == nil) {
            DDLogError(@"GENERIC SERVICE: Migrate Model Method - Source model is nil");
        }
        
        // Accessing the Migration Manager
        NSMigrationManager *migrationManager = [[NSMigrationManager alloc] initWithSourceModel:sourceModel destinationModel:destinationModel];
        
        // Accessing all the Mapping Models
        NSMappingModel *firstMappingModel = [[NSMappingModel alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"MappingModel_1.1.6_1.3" withExtension:@"cdm"]];
        NSArray *bundlesForMappingModel = @[firstMappingModel]; // an array of bundles, or nil for the main bundle
        NSError *error = nil;
        
        // Getting the Mapping Model that can migrate the Source Model to the Destination one from the Bundles array
        NSMappingModel *mappingModel = [NSMappingModel mappingModelFromBundles:bundlesForMappingModel forSourceModel:sourceModel destinationModel:destinationModel];
        
        if (mappingModel == nil) {
            DDLogError(@"GENERIC SERVICE: Migrate Model Method - Mapping model is nil");
        }
        
        NSDictionary *sourceStoreOptions = nil; // options for the source store
        NSURL *destinationStoreURL = [NSPersistentStore urlForStoreName:[STORE_NAME stringByAppendingString:@"migration"]]; // URL for the destination store
        NSString *destinationStoreType = NSSQLiteStoreType; // type for the destination store
        NSDictionary *destinationStoreOptions = nil; // options for the destination store
        
        // Migrating
        BOOL ok = [migrationManager migrateStoreFromURL:sourceStoreURL
                                                   type:sourceStoreType
                                                options:sourceStoreOptions
                                       withMappingModel:mappingModel
                                       toDestinationURL:destinationStoreURL
                                        destinationType:destinationStoreType
                                     destinationOptions:destinationStoreOptions
                                                  error:&error];
        
        if (ok) {
            DDLogVerbose(@"GENERIC SERVICE: Migrate Model Method - Should delete the old store and rename the new store");
        }
    }
     
    
}

@end
