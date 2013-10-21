//
//  SampleHelper.h
//  ProofOfConcept
//
//  Created by Alex Gutierrez on 10/15/13.
//  Copyright (c) 2013 Alex Gutierrez. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LogHelper : NSObject

+ (instancetype)sharedInstance;

- (void)setupLogger;

@end
