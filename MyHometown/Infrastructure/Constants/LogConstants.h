//
//  LogConstants.h
//  ProofOfConcept
//
//  Created by Alex Gutierrez on 10/15/13.
//  Copyright (c) 2013 Alex Gutierrez. All rights reserved.
//

#import "DDLog.h"

#ifdef DEBUG
    static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
    static const int ddLogLevel = LOG_LEVEL_OFF;
#endif
