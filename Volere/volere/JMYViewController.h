//
//  JMYViewController.h
//  volere
//
//  Created by Patrick Allison on 3/28/12.
//  Copyright (c) 2012 Jaminya. All rights reserved.
//
//  Remarks: Added landscape, upside down rotation 
//

#import <UIKit/UIKit.h>
#import "fraction.h"

@interface JMYViewController : UIViewController {
    
    int currentNumber;
    char op;
    char cstring[60];                   // c conversion of NSString* input
    int cstrlength;
    UIButton *delButton;
    NSNumber *number;
    long double globalresult;           // global result
    NSMutableString *displayString;     // first line display string
    NSMutableString *display2String;    // second line of display string
    long double Mplus;                  // memory storage for global result
    NSMutableArray *displayArray;
    BOOL equalPressed; 
    unsigned int Dec2FracBtn;           // On/Off flag
    UIView *portrait;
    UIView *landscape;
}

@property (nonatomic, retain) IBOutlet UIButton *delButton;
@property (nonatomic, retain) NSMutableString *displayString;
@property (nonatomic, retain) NSMutableString *display2String;
@property (nonatomic, retain) NSMutableArray *displayArray;
@property (nonatomic, retain) IBOutlet UIView *portrait;
@property (nonatomic, retain) IBOutlet UIView *landscape;

// display collection
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *screen;
@property (retain, nonatomic) IBOutletCollection(UILabel) NSArray *screen2;

-(void) processDigit: (int) digit;
-(void) processOp: (char) op;
-(void) processInput;

// c-language code
void createRPN(char word[], char rpn[], int wordlength, int* rpnpointer); 
long double computeRPN(char rpn[], int* rpnPtr);
void popStk(char stack[], char rpn[], int* stackPtr, int* rtop);
void handleOperator(char stack[], char rpn[], int* stackPtr, int* rpntop, char item);
int priority(char);
long double validateInfix( char infix[], int length );

// convert decimal to fraction
-(fraction*) tofrac: (long double) X;

// numeric keys
-(IBAction) clickDigit: (id) sender;

// arithmetic operation keys
-(IBAction) clickPlus: (id) sender;
-(IBAction) clickMinus: (id) sender;
-(IBAction) clickMultiply: (id) sender;
-(IBAction) clickDivide: (id) sender;

// function operations
-(IBAction) clickSqrt: (id) sender;
-(IBAction) clickInverse: (id) sender;
-(IBAction) clickSquare: (id) sender;
-(IBAction) clickPwr: (id) sender;
-(IBAction) clickD2F: (id) sender;

// parenthesis
-(IBAction) clickBracketLH: (id) sender;
-(IBAction) clickBracketRH:(id)sender;

// shift keys
-(IBAction) clickMplus: (id) sender;
-(IBAction) clickMR: (id) sender;

// delete item, clear display
-(IBAction) clickDel: (id) sender;
-(IBAction) clickClr: (id) sender;

// misc key
-(IBAction) clickFloat: (id) sender;
-(IBAction) clickNegative: (id) sender;

// generate result
-(IBAction) clickEqual: (id) sender;

// view rotation
- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration;

@end
