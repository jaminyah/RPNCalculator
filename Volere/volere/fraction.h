//
//  fraction.h
//  volere
//
//  Created by Patrick Allison on 3/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface fraction : NSObject {
    int numerator;
    int denominator;   
}

@property int numerator, denominator;

-(void) print;
-(void) setTo: (int) n over: (int) d;
-(fraction *) add: (fraction *) f;
-(fraction *) subtract: (fraction *) f;
-(fraction *) multiply: (fraction *) f;
-(fraction *) divide: (fraction *) f;
-(void) reduce;
-(double) convertToNum;
-(NSString *) convertToString;

@end
