//
//  Constants.h
//  volere
//
//  Created by Patrick Allison on 3/15/12.
//  Copyright (c) 2012 Jaminya. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Constants <NSObject>

// operator constants
#define SQRT_OP        11
#define INVERSE_OP     12
#define SQUARE_OP      13
#define CUBE_OP        14

// operator priorities
#define MINUS_PRI       1
#define PLUS_PRI        1
#define DIV_PRI         2
#define MUL_PRI         2
#define EXP_PRI         3
#define NEGATIVE_PRI    4
#define ROOT_PRI        5
#define RT_PAREN_PRI    0
#define LT_PAREN_PRI    0

#define TRUE            1
#define FALSE           0
#define EMPTY          -1
#define ON              1
#define OFF             0
#define ERROR1         -0.8888888888
#define ERROR2         -0.9999999999
#define ERROR3         -0.7777777777
#define PRECISION       0.0000000001
#define NOERROR         0.0

// cstring array character values
#define NEGATIVE    '_'
#define ROOT        'R'

@end
