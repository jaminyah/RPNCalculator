//
//  JMYViewController.m
//  volere
//
//  Created by Patrick Allison on 3/28/12.
//  Copyright (c) 2012 Jaminya. All rights reserved.
//
//  Remarks: added landscape, upside down view rotation
//  Revision: 1.3
//  Line: 1079 - changed:      else if (isdigit(infix[i-1]))
//               to:           else if (isdigit(infix[i-1]) || infix[i-1] == ')')
//               removed:      else if (infix[i-1] == '(')
//               reason:       expressions such as: (1 + 3)-4 did not give an error. Note '-' is the negative sign in this case.



#import "JMYViewController.h"
#import "Constants.h"
#import "fraction.h"

// degree to radians macro for view rotation
#define degreesToRadians(x) (M_PI * (x) / 180.0)

@implementation JMYViewController

@synthesize displayString, display2String, displayArray, delButton;
@synthesize portrait;
@synthesize landscape;
@synthesize screen;
@synthesize screen2;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.displayString = [NSMutableString stringWithCapacity: 70];
    self.display2String = [NSMutableString stringWithCapacity: 70];
    self.displayArray = [[[NSMutableArray alloc] initWithCapacity: 70] autorelease];     // display array
    
    // display collection set font
    [screen setValue:[UIFont fontWithName:@"Checkbook" size: 16] forKey:@"font"];      
    [screen2 setValue:[UIFont fontWithName:@"Checkbook" size: 16] forKey:@"font"];     
        
    // display collection
    [screen setValue:[UIColor blackColor] forKey:@"textColor"];      
    [screen2 setValue:[UIColor blackColor] forKey:@"textColor"];     
             
    cstrlength = 0;
    globalresult = 0.0;                            // global access to computation result
    equalPressed = NO;
    Dec2FracBtn = OFF;  
    
}

- (void)viewDidUnload
{
    [self setPortrait:nil];
    [self setLandscape:nil];
    [self setScreen:nil];
    [self setScreen2:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void) dealloc {
    [displayArray dealloc];
    [displayString dealloc];
    [display2String dealloc];
    [displayArray dealloc];
    [delButton dealloc];
    [portrait dealloc];
    [landscape dealloc];
    [screen release];
    [screen2 release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    }
    else return YES; 
}


// view rotation
- (void) willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration 
{    
    // if the device is iphone
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) 
    {
        if (interfaceOrientation == UIInterfaceOrientationPortrait) {
            self.view = self.portrait;
            self.view.transform = CGAffineTransformIdentity;
            self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(0));
            self.view.bounds = CGRectMake(0.0, 0.0, 320.0, 460.0);
        }
        else
        {
            if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
                self.view = self.landscape;
                self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(-90));
                self.view.bounds = CGRectMake(0.0, 0.0, 480.0, 300.0);
            }
            else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
                self.view = self.landscape;
                self.view.transform = CGAffineTransformIdentity;
                self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(90));
                self.view.bounds = CGRectMake(0.0, 0.0, 480.0, 300.0);
            }
        }
    }
    else
    {
        if (interfaceOrientation == UIInterfaceOrientationPortrait) {
            self.view = self.portrait;
            self.view.transform = CGAffineTransformIdentity;
            self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(0));
            self.view.bounds = CGRectMake(0.0, 0.0, 768.0, 1004.0);
        }
        else
        {
            if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
                self.view = self.landscape;
                self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(-90));
                self.view.bounds = CGRectMake(0.0, 0.0, 1024.0, 748.0);
            }
            else if (interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
                self.view = self.landscape;
                self.view.transform = CGAffineTransformIdentity;
                self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(90));
                self.view.bounds = CGRectMake(0.0, 0.0, 1024.0, 748.0);
            }
            else if (interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
                self.view = self.portrait;
                self.view.transform = CGAffineTransformIdentity;
                self.view.transform = CGAffineTransformMakeRotation(degreesToRadians(-180));
                self.view.bounds = CGRectMake(0.0, 0.0, 768.0, 1004.0);
            }
        }        
    }
} // rotation


// add each digit clicked to the displayArray, display contents of the array
-(void) processDigit: (int) digit
{
    currentNumber = currentNumber * 10 + digit;
    
    // convert each digit to a number object
    number = [NSNumber numberWithInt: digit];
    
    // add each digit object to displayArray 
    [displayArray addObject: number];
    
    // empty the displayString for line 1 before appending
    [displayString setString: @""];
    
    // convert NSArray to NSString
    for (NSObject * obj in displayArray)
    {
        [displayString appendString: [obj description]];
    }
    
    //[display setText: displayString];
    [screen setValue: displayString forKey:@"text"]; 
}

// process each non-digit keyboard key
-(void) processOp: (char) theOp
{
    NSString *opStr = nil;
    
    op = theOp;
    switch (theOp) {
        case '+':
            opStr = @" + ";
            break;
        case '-':
            opStr = @" - ";
            break;
        case '*':
            opStr = @" * ";
            break;
        case '/':
            opStr = @" / ";
            break;
        case '^':
            opStr = @"^( ";
            break;
        case '(':
            opStr = @"( ";
            break;
        case ')':
            opStr = @" )";
            break;
        case '.':
            opStr = @".";
            break;
        case '_':
            opStr = @"\u2010";
            break;
        case SQRT_OP:
            opStr = @"\u221A ( ";
            break;
        case INVERSE_OP:
            opStr = @"1/";
            break;
        case SQUARE_OP:
            opStr = @"^2";
            break;
        case '=':
            opStr = @"";
            break;
        default: opStr = nil;
            break;
    }
    
    // add objects to the array
    [displayArray addObject: opStr];
    
    // empty the previous displayString content before dumping contents of the array.
    [displayString setString: @""];
    
    // convert NSArray to NSString
    for (NSObject * obj in displayArray)
    {
        [displayString appendString: [obj description]];
    }
    
    // show the items entered so far on line 1
    [screen setValue: displayString forKey:@"text"]; 
    
    [display2String setString: @""];
    
    // ensure text color is black
    [screen2 setValue:[UIColor blackColor] forKey:@"textColor"];
     
    // display on line 2
    [screen2 setValue: display2String forKey:@"text"]; 

} // processOp


/**********************************************************************************************************/
// on clickEqual create Reverse Polish Notation (RPN) string.
// perform the computation using the RPN string.
// display the result of computation.
/**********************************************************************************************************/
-(void) processInput
{
    long double result = 0.0;                // final computation value
    long double difference = 0.0;            // difference between two double values
    long double difference2 = 0.0;         
    char rpn[50] = {'\0'};                   // RPN expression
    int rpnpointer = 0;                      // pointer to next open slot in rpn array. Also the rpn length
    NSNumber *n;
    NSNumberFormatter *formatter;
    
    // set the output number format parameter
    formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits: 10];
    [formatter setNumberStyle: NSNumberFormatterDecimalStyle];
    
    // validate the input infix expression
    result = validateInfix(cstring, cstrlength);
    
    // error condition
    difference2 = fabsl( ERROR2 - result );
    
    // confirm that result is an error value
    if ( difference2 <= PRECISION )
    {
        // empty contents of second line output string
        [display2String setString: @""];
        
        // output syntax error on second line
        //display2.textColor = [UIColor purpleColor];
        [screen2 setValue:[UIColor purpleColor] forKey:@"textColor"];
        [display2String appendString:@"SYNTAX ERROR"];
        
        //[display2 setText: display2String]; 
        [screen2 setValue: display2String forKey:@"text"]; 
    }
    else
    {
        // create RPN 
        createRPN(cstring, rpn, cstrlength, &rpnpointer);  
        
        // calculate result
        result = computeRPN(rpn, &rpnpointer);
        
        // error check
        if ( isnan(result) )
        {
            result = ERROR2;
        }
        
        // error condition
        difference = fabsl( ERROR1 - result );
        
        if ( difference <= PRECISION )
        {
            // empty contents of second line output string
            [display2String setString: @""];
            [display2String appendString:@"DIVIDE BY ZERO ERROR"];
            [screen2 setValue:[UIColor purpleColor] forKey:@"textColor"];
            [screen2 setValue: display2String forKey:@"text"];              

        }
        else if ( fabsl( ERROR2 - result) <= PRECISION )
        {
            // empty contents of second line output string
            [display2String setString: @""];
            [screen2 setValue:[UIColor purpleColor] forKey:@"textColor"];
            [display2String appendString:@"SYNTAX ERROR"];
            [screen2 setValue: display2String forKey:@"text"];              

        }            
        else if ( fabsl( ERROR3 - result) <= PRECISION )
        {
            // empty contents of second line output string
            [display2String setString: @""];
            [screen2 setValue:[UIColor purpleColor] forKey:@"textColor"];
            [display2String appendString:@"EXPONENT ERROR"];
            [screen2 setValue: display2String forKey:@"text"];             

        }
        else
        {
            // make the result available globally
            globalresult = result;
            
            // empty the previous displayString content before dumping contents of the array.
            [display2String setString: @""];
            
            // output floating point result on second line
            n = [NSNumber numberWithDouble: globalresult];
            
            // display formatted string
            [display2String appendString:[formatter stringFromNumber: n]];            
            [screen2 setValue: display2String forKey:@"text"];             
        }
    } // end else
    [formatter autorelease];
} // end processInput


// c language code
void createRPN(char word[], char rpn[], int wordlength, int *rpnPtr) 
{
    char stack[20] = {'\0'};
    unsigned char item;	
    BOOL isOperator = NO;
    //BOOL isDigit = NO;
    BOOL spaceON = FALSE;
   // BOOL isSign = NO;                                       // -ve number sign flag
    int i = 0;                                              // loop control variable
    int stkPointer = 0;                                     // next empty slot on the stack 
    int rtop = EMPTY;
    
    // loop thru contents of input infix string (cstring)
    for (i = 0; i < wordlength; i++)
    {
        item = word[i];	
        //isDigit = isdigit(item);
        
        // identify operator and non-operator characters
        switch (item)
        {
            case '(':
                if (spaceON)
                {
                    rtop++;
                    rpn[rtop] = ' '; 
                    item = '*';                                 // artifically add a multiply
                    handleOperator(stack, rpn, &stkPointer, &rtop, item);
                    item = '(';
                    handleOperator(stack, rpn, &stkPointer, &rtop, item);
                    isOperator = NO;
                    spaceON = FALSE;
                    break;
                }
                else
                {
                    isOperator = YES;
                    break; 
                }
            case ')':
                if (word[i+1] == '(')
                {
                    isOperator = NO;                            // not placed on stack so not considered operator                        
                    popStk(stack, rpn, &stkPointer, &rtop);     // for each parenthesis pop the stack
                    
                    rtop++;
                    item = '*';                                 // artifically add a multiply
                    handleOperator(stack, rpn, &stkPointer, &rtop, item);
                }
                else
                {
                    isOperator = NO;                            // not placed on stack so not considered operator                        
                    popStk(stack, rpn, &stkPointer, &rtop);     // for each parenthesis pop the stack
                }
                break;
            case '*':
                isOperator = YES;
                break;
            case '/':
                isOperator = YES;
                if (spaceON)                                    // add a space at the end of the number                
                {
                    rtop++;
                    rpn[rtop] = ' ';                   
                    spaceON = FALSE;
                }
                break;
            case '+':
                isOperator = YES;
                break;
            case '-': 
                isOperator = YES;
                break;
            case '^':
                isOperator = YES;
                if (spaceON)                                    // add a space at the end of the number                
                {
                    rtop++;
                    rpn[rtop] = ' ';                   
                    spaceON = FALSE;
                }
                break;
            case '_':                                           // negative sign
                //isSign = YES;
                isOperator = YES;
                break;
            case ROOT:                                          // square root operator
                isOperator = YES;
                if (isdigit(word[i-1])) {
                    spaceON = FALSE;
                    rtop++;
                    rpn[rtop] = ' '; 
                    item = '*';                                 // artifically add a multiply
                    handleOperator(stack, rpn, &stkPointer, &rtop, item);
                    item = ROOT;
                }
                break;
            case ' ':
                isOperator = NO;
                if (spaceON)                                    // add a space at the end of the number                
                {
                    rtop++;
                    rpn[rtop] = item;
                    spaceON = FALSE;
                }
                break;
            case '.':                                           // floating point value
                isOperator = NO;
                rtop++;
                rpn[rtop] = item;
                break;
            default:
                break;
        } // end switch
        
        if (isdigit(item))                                            // array character is a digit 
        {
            rtop++;
            rpn[rtop] = item;
            spaceON = TRUE;                                     // add a space after the number in the rpn array
        }
        else if (isOperator)
        {
            handleOperator(stack, rpn, &stkPointer, &rtop, item);
            isOperator = NO;                                    // reset
        }
    } // end for
    
    // pop all remaining elements off stack, push to rpn queue
    popStk(stack, rpn, &stkPointer, &rtop);
    *rpnPtr = rtop + 1;		
    return;    	
} // end createRPN


void handleOperator(char stack[], char rpn[], int* stackPtr, int* rpntop, char item)
{
    int top = *stackPtr - 1;
    int rtop = *rpntop;
    
    if (top == EMPTY)
    {
        top++;
        stack[top] = item;                                      // stack.push(item)  
    }
    else if (item == '(')
    {
        top++;
        stack[top] = item;                                      // stack.push(item)
    }	
    else
    {
        while ( top != EMPTY && priority(stack[top]) >= priority(item) )        
        {
            rtop++;
            rpn[rtop] = stack[top];                             // rpn.push(top)
            rtop++;
            rpn[rtop] = ' ';                                    // add a space after each operator
            top--;                                              // next operator on the stack
        }
        top++;
        stack[top] = item;                                      // stack.push(item)
    }
    
    *stackPtr = top + 1;                                        // return pointer positions
    *rpntop   = rtop;
    return;
	
} // end handleOperator


/*********************************************************************************************/
// assign a priority to each operator based on operator precedence
//
/*********************************************************************************************/
int priority(char item)
{
    int rank = 0;
    
    switch (item)
    {
        case '(':
            rank = LT_PAREN_PRI;
            break;
        case '*':
            rank = MUL_PRI;
            break;
        case '/':
            rank = DIV_PRI;
            break;
        case '+':
            rank = PLUS_PRI;
            break;
        case '-':
            rank = MINUS_PRI;
            break;
        case '_':
            rank = NEGATIVE_PRI;
            break;
        case '^':
            rank = EXP_PRI;
            break;
        case ROOT:
            rank = ROOT_PRI;
            break;
        default:
            break;							
    }		
    return rank;
} // end priority


void popStk(char stack[], char rpn[], int* stackPtr, int* rpntop)
{	
    int i = 0;                                                  // array index
    int top = *stackPtr - 1;
    int rtop = *rpntop;
    int numberStackItems = *stackPtr;                           // size of items on the stack
    
    // pop all elements off stack. 
    // Stop if left parenthesis found and push to rpn queue
    for (i = numberStackItems; i > 0; i--)
    {
        if (top == EMPTY)
        {
            return;
        }
        else if (stack[top] == '(')
        {
            top--;                                              // stack.pop(item)
            break;                                              // stop popping for left parenthesis	
        }		
        else
        {
            rtop++;                                             //rpn.push(top)
            rpn[rtop] = stack[top];
            rtop++;
            rpn[rtop] = ' ';                                    // add a space after each operator
            top--;
        }						
    }	// end for
    *stackPtr = top + 1;
    *rpntop = rtop;	
    return;		
} // end popStk


long double computeRPN(char rpn[], int *rpnPtr)
{
    long double stack[20] = {0.0};
    int top = EMPTY;
    int size = *rpnPtr;
    int i = 0, digit = 0;   
    long double result = 0.0, decimal = 0.0;
    long double factor = 1.0;
    char item = '\0';
    long double operand1 = 0.0, operand2 = 0.0, realNumber = 0.0;
    long double difference = 0.0;
    BOOL isDigit = NO;
    BOOL digitFlag = NO;
    BOOL isFloat = NO;
    int wholeNumber = 0;
    int operandCount = 0;                                   // number of operators
    int opCount = 0;                                        // number of operands
    
    // loop thru contents of the rpn array
    for (i = 0; i < size; i++)
    {        
        item = rpn[i];	
        isDigit = isdigit(item);                            // identify numeric digits
        
        switch (item)
        {
            case '*':
                opCount++;
                operand2 = stack[top];
                stack[top] = 0.0;                            // reset to an "empty" value
                top--;
                operand1 = stack[top];
                
                // error checking
                if ( isnan(operand1) || isnan(operand2) ) {
                    result = ERROR2;
                    return result;
                    break; }
                
                // compute intermediate result
                result = operand1 * operand2;
                stack[top] = result;
                break;
            case '/':
                opCount++;
                operand2 = stack[top];
                stack[top] = 0.0;
                top--;
                operand1 = stack[top];
                
                // error checking
                if ( isnan(operand1) || isnan(operand2) )
                {
                    result = ERROR2;
                    return result;
                    break;
                }
                else if (operand2 == 0.0)
                {
                    // divide by zero error
                    result = ERROR1;
                    return result;
                }
                else
                {   // compute intermediate result
                    result = operand1 / (long double)operand2;
                    stack[top] = result;
                }	
                break;
            case '+':
                opCount++;
                operand2 = stack[top];
                stack[top] = 0.0;                               // reset to an "empty" value
                top--;
                operand1 = stack[top];
                
                // error checking
                if ( isnan(operand1) || isnan(operand2) ) {
                    result = ERROR2;
                    return result;
                    break; }
                
                // compute intermediate result
                result = operand1 + operand2;
                stack[top] = result;
                break;
            case '-':
                opCount++;
                operand2 = stack[top];
                stack[top] = 0.0;                                // reset to an "empty" value
                top--;
                operand1 = stack[top];
                
                // error checking
                if ( isnan(operand1) || isnan(operand2) ) {
                    result = ERROR2;
                    return result;
                    break; }
                
                // check for near zero error condition i.e. -0.000000 difference
                difference = fabsl( operand1 - operand2 );
                
                if ( difference <= PRECISION )
                {
                    result = 0.0;
                }
                else
                {
                    // compute intermediate result
                    result = operand1 - operand2;
                }
                
                stack[top] = result;
                break;
            case '^':
                opCount++;
                operand2 = stack[top];
                stack[top] = 0.0;                                 // reset to an "empty" value
                top--;
                operand1 = stack[top];
                
                // error check
                if ( isnan(operand1) || isnan(operand2) )
                {
                    result = ERROR2;
                    return result;
                    break;
                }
                
                //if exponent is float value and operand1 negative
                if ( fabsl(operand2 - (int)operand2) > 0.0 && operand1 < 0) 
                {
                    result = ERROR3;
                    return result;
                    break;
                }
                
                // if exponent is negative and operand1 is zero
                if (operand1 == 0 && operand2 < 0)
                {
                    result = ERROR3;
                    return result;
                    break;
                }
                
                // raise operand1 to pwr of operand2
                result = pow(operand1, operand2);
                
                stack[top] = result;                              // push result to the stack
                break;
            case ROOT:
                opCount++;
                operand2 = stack[top];
                
                // error checking
                if ( isnan(operand2) )
                {
                    result = ERROR2;
                    return result;
                    break; 
                }
                else if (operand2 < 0)
                {
                    result = ERROR2;
                    return result;
                    break; 
                }
                else 
                {
                    result = sqrt(operand2);
                    stack[top] = result; }
                break;
            case '_':                                             // negative sign
                operand1 = stack[top];
                stack[top] = -1 * operand1;
                break;
            case '.':
                isFloat = YES;
                continue;
                break;
            case ' ':
                if (digitFlag == YES)
                {
                    top++;
                    operandCount++;
                    stack[top] = realNumber;
                    
                    // reset 
                    digitFlag = NO;
                    isFloat = NO;
                    realNumber = 0.0;
                    decimal = 0.0;
                    factor = 1.0;
                    wholeNumber = 0;
                }
                break;
            default:
                break;							
        } // end switch
        
        if (item != ' ')
        {
            if (isFloat)
            {
                // create the floating point value from character array contents
                digitFlag = YES;
                factor = factor / 10.0;
                digit = (int)item - (int)'0';
                decimal = decimal + digit * factor;
                realNumber = (long double) wholeNumber + decimal;
                
            }
            else if (isDigit)
            {
                // create the integer number value from the character array elements
                digitFlag = YES;
                digit = (int)item - (int)'0';
                wholeNumber = wholeNumber * 10 + digit;
                realNumber = (long double) wholeNumber;
            }
        } // end if
    } // end for
    
    // check for well formed syntax
    if ((operandCount >= 2) && (opCount == 0))
    {
        result = ERROR2;
    }
    else
    {
        result = stack[top];
    }    
    return result; 
}


// convert decimal to fraction
-(fraction *) tofrac: (long double) X
{   
    
    fraction *dbl2fract = [[fraction alloc] init];
    long double Z = X;
    int Dprevious = 0;
    int Di = 1;
    int D = 0;
    int N = 0;
    
    double fractpart = 0.0, intpart = 0.0;
    long double difference, ratio;
    
    // prevent compiler warning
    #pragma unused(fractpart)

    int index = 0;
    
    // account for a zero input value
    if (X == 0.0)
    {
        dbl2fract.numerator = 0;
        dbl2fract.denominator = 1;
    }
    else
    {
        for (index = 1; index < 11; index++)
        {
            // obtain the integer part, intpart, of Z
            fractpart = modf(Z, &intpart);
            Z = 1 / ( Z - (int)intpart );
            
            fractpart = modf(Z, &intpart);
            D = Di * (int)intpart + Dprevious;
            
            Dprevious = Di;
            Di = D;
            
            N = round(X * D);
            
            ratio = (long double) N / (long double) D;
            difference = fabsl ( X - ratio );
            
            if ( difference <=  PRECISION)
            {
                break;
            }
        }
        
        //  swap minus sign from denominator to numerator
        if (D < 0)
        {
            D = -1 * D;
            N = -1 * N;
        }
        dbl2fract.numerator = N;
        dbl2fract.denominator = D;
    }
    return [dbl2fract autorelease];
}


/* Determine if the input expression is a well formed math expression */

long double validateInfix( char infix[], int length )
{
    long double result = 0.0;
    int i = 0;
    char item;
    //BOOL isDigit = NO;
    int LeftBracketCount = 0;
    int RightBracketCount = 0;
    int FloatCount = 0;
    
    for (i = 0; i < length; i++)
    {
        item = infix[i];
        //isDigit = isdigit(item);
        
        // count left/right brackets
        switch (item)
        {
            case '(': LeftBracketCount++;
                break;
            case ')': RightBracketCount++;
                break;
            default: break;
        }
        
        switch (item)
        {
            case 0:
            case 1:
            case 2:       
            case 3:
            case 4:
            case 5:       
            case 6:
            case 7:       
            case 8:
            case 9:
                if (isdigit(infix[0])) 
                    result = NOERROR;
                break;
                
            case 'R':
                if (infix[0] == 'R')
                    result = NOERROR;
                break;
                
            case '+': case '-': case '*':
                if (i == 1)                           // begins with operator. eg. " + "
                {
                    result = ERROR2;
                    return result;
                }
                if ( isdigit(infix[i-2]) || (infix[i-2] == ')') || (infix[i-2] == ')') ||
                     isdigit(infix[i+2]) || (infix[i+2] == '(') || (infix[i+2] == 'R') || 
                                            (infix[i+2] == '_') || (infix[i+2] == '.')   )
                {
                    result = NOERROR;
                }
                else {
                    result = ERROR2;
                    return result;
                }
                break;
                                
            case '/':
                if ((i == 1) && (infix[i-1] == ' '))  // begins with operator. i.e. " / "
                {
                    result = ERROR2;
                    return result;
                }
                if (isdigit(infix[i-1]) && (isdigit(infix[i+1]))) {
                    result = NOERROR;
                }
                else if (isdigit(infix[i-2]) && isdigit(infix[i+2]))
                {
                    result = NOERROR;
                }
                else if ((infix[i-2] == '(') || (infix[i-2] == ')')
                         || (infix[i+1] == '(') || (infix[i+2] == '(') || (infix[i+2] == ')'))
                {
                    result = NOERROR;
                    
                }
                else if ((infix[i+2] == 'R') || (infix[1+1] == '_') || (infix[i+2] == '_') || (infix[i+1] == '.') || 
                         (infix[i+2] == '.'))
                {
                    result = NOERROR;
                }
                else if (isdigit(infix[i-1]) && (infix[i+1] == ' '))
                {
                    result = ERROR2;
                    return result;
                }
                else
                {
                    result = ERROR2;
                    return result;
                }
                break;
                
            case '(':
                if (infix[i+3] == ')')                  // empty brackets
                {
                    result = ERROR2;
                    return  result;
                }
                else if (isdigit(infix[i-1]) || (infix[i-1] == ')') || (infix[i-1] == 'R'))
                {
                    result = NOERROR;
                }
                else if (isdigit(infix[i+2]) || (infix[i+2] == '(') || (infix[i+2] == 'R') 
                         || (infix[i+2] == '_'))
                {
                    result = NOERROR;                        
                }
                else if ((infix[i-2] == '+') || (infix[i-2] == '-') || (infix[i-2] == '*') 
                         || (infix[i-2] == '/') || (infix[i-2] =='('))
                {
                    result = NOERROR;
                }
                else if ((infix[i+2] == '+') || (infix[i+2] == '-') || (infix[i+2] == '*') 
                         || (infix[i+2] =='('))
                {
                    result = NOERROR;
                }
                else
                {
                    result = ERROR2;
                    return  result;
                }
                break;
 
            case ')':
                if (isdigit(infix[i+1])) {
                    result = ERROR2;
                    return  result;
                }
                break;
 
            case '_': // negative sign
                if (i == 0)
                {
                    if (((infix[0] == '_') && isdigit(infix[1])) ||
                        ((infix[0] == '_') && (infix[1] == 'R')) ||
                        ((infix[0] == '_') && (infix[1] == '.')) ||
                        ((infix[0] == '_') && (infix[1] == '('))   ) 
                    {
                        result = NOERROR;
                    }
                    else {
                        result = ERROR2;
                        return result;
                    }
                }
                else if (isdigit(infix[i-1]) || infix[i-1] == ')')
                {
                    result = ERROR2;
                    return result;
                }
                else if (isdigit(infix[i+1]) || (infix[i+1] == '(') || (infix[i+1] == 'R') ||
                        (infix[i+1] == '.')) 
                {
                    result = NOERROR; 
                }
                else {
                    result = ERROR2;
                    return result;
                }
                break;

            case '^': 
                if (i == 0)                             // begins with operator. i.e. "^("
                {
                    result = ERROR2;
                    return result;
                }
                if ((isdigit(infix[i-1]) || (infix[i-1] == ')' )) && (isdigit(infix[i+1]) 
                    || (infix[i+1] == '(')))
                {
                    result = NOERROR;
                }
                else {
                    result = ERROR2;
                    return result; }
                break;
                
            case '.': 
                FloatCount++;
                if ((infix[0] == '.') && isdigit(infix[1]))
                {
                    result = NOERROR;
                }
                
                else if (isdigit(infix[i+1]))
                {
                    result = NOERROR;
                }
                else
                {
                    result = ERROR2;
                    return result;
                }
                break;
                
            case ' ':
                if (FloatCount > 1)
                { 
                    result = ERROR2;
                    return  result;
                }
                FloatCount = 0; 
                break;
            default: result = NOERROR;
                break;
        } // end switch
        
    } // end for
    
    // check for matching pair of parenthesis 
    if (LeftBracketCount != RightBracketCount) {
        result = ERROR2; }
    
    return result;
} //  end validate


-(IBAction) clickDigit:(id)sender
{
    int digit = [sender tag];
    
    // a space character is added to cstring to signal end of input on clickEqual
    // remove this space character from the cstring array
    if (equalPressed)
    {
        cstring[--cstrlength] = '\0';
        equalPressed = NO;              // reset
    }
    
    // convert int to char
    char dig = (char)((int)'0' + digit);
    cstring[cstrlength++] = dig;
    
    // add digit to display array
    [self processDigit: digit];
}

// arithmetic operation keys
-(IBAction) clickPlus: (id) sender
{
    // a space character is added to cstring to signal end of input on clickEqual
    // remove this space character from the cstring array
    if (equalPressed)
    {
        cstring[--cstrlength] = '\0';
        equalPressed = NO;              // reset
    }
    cstring[cstrlength++] = ' ';
    cstring[cstrlength++] = '+';
    cstring[cstrlength++] = ' ';
    [self processOp: '+'];
}

-(IBAction) clickMinus: (id) sender
{
    // a space character is added to cstring to signal end of input on clickEqual
    // remove this space character from the cstring array
    if (equalPressed)
    {
        cstring[--cstrlength] = '\0';
        equalPressed = NO;              // reset
    }
    cstring[cstrlength++] = ' ';
    cstring[cstrlength++] = '-';
    cstring[cstrlength++] = ' ';
    [self processOp: '-'];
}

-(IBAction) clickMultiply: (id) sender
{
    // a space character is added to cstring to signal end of input on clickEqual
    // remove this space character from the cstring array
    if (equalPressed)
    {
        cstring[--cstrlength] = '\0';
        equalPressed = NO;              // reset
    }
    cstring[cstrlength++] = ' ';
    cstring[cstrlength++] = '*';
    cstring[cstrlength++] = ' ';
    [self processOp: '*'];
}

-(IBAction) clickDivide: (id) sender
{
    // a space character is added to cstring to signal end of input on clickEqual
    // remove this space character from the cstring array
    if (equalPressed)
    {
        cstring[--cstrlength] = '\0';
        equalPressed = NO;              // reset
    }
    cstring[cstrlength++] = ' ';
    cstring[cstrlength++] = '/';
    cstring[cstrlength++] = ' ';
    [self processOp: '/'];
}

// square root operations
-(IBAction) clickSqrt: (id) sender
{
    cstring[cstrlength++] = ROOT;
    cstring[cstrlength++] = '(';
    cstring[cstrlength++] = ' ';
    [self processOp: SQRT_OP];
}

-(IBAction) clickInverse: (id) sender
{
    cstring[cstrlength++] = '1';
    cstring[cstrlength++] = '/';
    [self processOp: INVERSE_OP];
}

-(IBAction) clickSquare: (id) sender
{
    cstring[cstrlength++] = '^';
    cstring[cstrlength++] = '2';
    [self processOp: SQUARE_OP];
}


-(IBAction) clickPwr: (id) sender
{
    cstring[cstrlength++] = '^';
    cstring[cstrlength++] = '(';
    cstring[cstrlength++] = ' ';
    [self processOp: '^'];
}

// parenthesis
-(IBAction) clickBracketLH: (id) sender
{
    cstring[cstrlength++] = '(';
    cstring[cstrlength++] = ' ';
    [self processOp: '('];
}

-(IBAction) clickBracketRH:(id)sender
{
    cstring[cstrlength++] = ' ';
    cstring[cstrlength++] = ')';
    [self processOp: ')'];
}

// M+ key to store result in memory
-(IBAction) clickMplus:(id)sender
{
    Mplus = globalresult;
}

// remember memory
-(IBAction) clickMR:(id)sender
{
    NSString *item;
    int index, size = 0;
    
    // convert double to string
    [displayString appendString: [[ NSNumber numberWithDouble: Mplus ] stringValue ]]; 
    
    //[display setText: displayString]; 
    [screen setValue: displayString forKey:@"text"]; 
    
    // add objects to the array
    [displayArray addObject: [ NSNumber numberWithDouble: Mplus ]];
    
    // convert a type double to item of type NSString
    item = [[ NSNumber numberWithDouble: Mplus ] stringValue ];
    
    // obtain length of item of type NSString*
    size = [ item length ];
    
    // add NSString characters to cstring
    for (index = 0; index < size; index++)
    {
        // if the number is negative
        if ( [item characterAtIndex: index ] == '-' )
        {
            cstring[ cstrlength++ ] = '_';
        }
        else
        {
            cstring[ cstrlength++ ] = [ item characterAtIndex: index ];  
        }
    } // end for   
}


// delete item, clear display
-(IBAction) clickDel: (id) sender
{
    NSString *lastItem;
    NSObject* item;
    int size, index;
    
    // reset the decimal to fraction button
    Dec2FracBtn = OFF;
    
    // verify that there is one or more items on the display before deleting
    if ([displayArray count] > 0)
    {
        // a space character is added to cstring to signal end of input.
        // remove space character from the cstring array
        if (equalPressed) {
            cstring[--cstrlength] = '\0';
            equalPressed = NO;
        }
        
        // obtain the last item in the display array
        item = [displayArray lastObject];
        
        // cast the last item to string type
        lastItem = [NSString stringWithFormat:@"%@", item];
        
        // obtain number of characters in string lastItem
        size = [lastItem length];
        
        // remove last display array object characters from cstring
        for (index = 0; index < size; index++)
        {
            cstring[--cstrlength] = '\0';
        }
        
        // remove last object from display array
        if ([displayArray count] > 0)                  // prevent exception
        { 
            [displayArray removeLastObject];
        }
        
        // empty the displayString before appending
        [displayString setString: @""];
        
        // convert NSArray to NSString
        for (NSObject * obj in displayArray)
        {
            [displayString appendString: [obj description]];
        }        
        [screen setValue: displayString forKey:@"text"];              

    } // end if
}


-(IBAction) clickD2F:(id)sender
{
    fraction * output;
    
    // toggle between decimal and float
    if (Dec2FracBtn == OFF)
    {
        Dec2FracBtn = ON;
    }
    else if (Dec2FracBtn == ON)
    {
        Dec2FracBtn = OFF;
    }
    
    // trigger flag On/Off
    if (Dec2FracBtn == ON)
    {
        // convert computation result to fraction 
        output = [self tofrac: globalresult];
        
        // clear second line display string
        [display2String setString: @""];
        
        // display fraction on second line
        [display2String appendString: [output convertToString]];
        [screen2 setValue: display2String forKey:@"text"];       
    }
    else if (Dec2FracBtn == OFF)
    {
        // clear second line display string
        [display2String setString: @""];
        
        // output floating point result on second line
        [display2String appendString:[[NSNumber numberWithDouble: globalresult] stringValue]];
        [screen2 setValue: display2String forKey:@"text"];       
    }
}


-(IBAction) clickClr: (id) sender
{
    // reset cstring array to empty string
    cstrlength = 0;
    for (int i = 0; i < 50; i++) {
        cstring[i] = '\0';
    }
    
    // reset equalPressed flag
    equalPressed = NO;
    
    // reset the decimal to fraction button
    Dec2FracBtn = OFF;
    
    // reset the global result
    globalresult = 0.0;
    
    // clear display array objects
    [displayArray removeAllObjects];
    
    // display empty string on first line
    [displayString setString: @""];
    [screen setValue: displayString forKey:@"text"];              

    // display empty string on second line
    [display2String setString: @""];    
    [screen2 setValue: display2String forKey:@"text"];            
}


// decimal point
-(IBAction) clickFloat: (id) sender
{
    // a space character is added to cstring to signal end of input.
    // remove space character from the cstring array
    if (equalPressed) {
        cstring[--cstrlength] = '\0';
        equalPressed = NO;
    }
    cstring[cstrlength++] = '.';
    [self processOp: '.'];
}


-(IBAction) clickNegative: (id) sender
{
    cstring[cstrlength++] = NEGATIVE;
    [self processOp: '_'];
}

// perform computation
-(IBAction) clickEqual:(id)sender
{
    // set equal pressed flag
    equalPressed = YES;
    
    // reset the decimal to fraction button
    Dec2FracBtn = OFF;
    
    // add a space to end of c-style string
    cstring[cstrlength++] = ' ';
    
    // set the second line display color
    [screen2 setValue:[UIColor blackColor] forKey:@"textColor"];     
 
    // calculate final value
    [self processInput];  
}

@end
