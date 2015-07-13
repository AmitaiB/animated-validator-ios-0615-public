//  ValidatorViewController.m
//  AnimatedValidator
//
//  Created by Al Tyus on 5/12/14.
//  Copyright (c) 2014 al-tyus.com. All rights reserved.
//

    //#import <QuartzCore/QuartzCore.h>

    /// pod 'NSString+email' (caveat: uses an overly strict regex)
    /// In real life, follow this advice:
    /// http://davidcel.is/posts/stop-validating-email-addresses-with-regex/
#import "NSString+Email.h"
#import "ValidatorViewController.h"
#import "Constants.h"


@interface ValidatorViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailConfirmTextField;
@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordConfirmTextField;
@property (weak, nonatomic) IBOutlet UIButton    *submitButton;
- (IBAction)submitButtonTapped:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *emailConfirmWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passwordConfirmWidthConstraint;



@end



@implementation ValidatorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.submitButton.accessibilityLabel             = SUBMITBUTTON;
    self.emailTextField.accessibilityLabel           = EMAILTEXTFIELD;
    self.emailConfirmTextField.accessibilityLabel    = EMAILCONFIRMTEXTFIELD;
    self.phoneTextField.accessibilityLabel           = PHONETEXTFIELD;
    self.passwordTextField.accessibilityLabel        = PASSWORDTEXTFIELD;
    self.passwordConfirmTextField.accessibilityLabel = PASSWORDCONFIRMTEXTFIELD;
    
        ///Submit button appears when all are valid entries.
    self.submitButton.hidden = YES;
    [self assignDelegates];
    
}


-(void)assignDelegates {
    self.emailTextField.delegate           = self;
    self.emailConfirmTextField.delegate    = self;
    self.phoneTextField.delegate           = self;
    self.passwordTextField.delegate        = self;
    self.passwordConfirmTextField.delegate = self;
    
}

-(BOOL)animatedNO:(NSArray *)constraints {
        
    [self.view layoutIfNeeded];
    return NO;
}

-(void)submitButtonGrandEntranceAnimation {
    
}

-(BOOL)isValidInput:(UITextField *)textField {
    if ([textField.text length] < 1)
        {return NO;}
    
        //         Email:  Should be a valid email
    if ([textField isEqual:self.emailTextField])
        {return [self.emailTextField.text isEmail];}
    
        //         Email confirm: should be the same as Email
    if ([textField isEqual:self.emailConfirmTextField]) {
        BOOL isTheSameEmailAddress = [[self.emailConfirmTextField.text lowercaseString] isEqualToString:[self.emailTextField.text lowercaseString]];
        return isTheSameEmailAddress;
    }

        
    if ([textField isEqual:self.phoneTextField]) {

            ///I used a regular expression, and then solved [both of]
            ///the problem[s].
        NSError *error = NULL;
        
            //RegEx: may have a +prefix, may have an area code, may format with
            //various metachars. Cannot have a 0 or 1 to start area code or
            //#. Must be 7 (or 10) digits. ObjC 2x '\' escape chars.
        NSString *regexPattern = @"(\\+1)?((\\([2-9]\\d{2}\\))|([2-9]\\d{2}))[. -]?([2-9]\\d{2})[. -]?\\d{4}"; 
        NSRegularExpression *phoneRegex = [NSRegularExpression regularExpressionWithPattern:regexPattern
                                                                                    options:NSRegularExpressionIgnoreMetacharacters
                                                                                      error:&error];
        
        NSUInteger numberOfMatches = [phoneRegex numberOfMatchesInString:textField.text 
                                                                 options:0
                                                                   range:NSMakeRange(0, [textField.text length])];
            
        return numberOfMatches == 1;
    }
            
//Regex replaces this ugliness:
//      ********************
//        NSUInteger digitCount = 0;
//        for (NSInteger i = 0; i < [self.phoneTextField.text length]; i++) {
//            unichar myChar = [self.phoneTextField.text characterAtIndex:i];
//            if ((myChar >= '0'  &&  myChar <= '9') || myChar == '+') {
//                if (myChar != '+') {
//                    digitCount++;
//                }
//            } else {
//                NSLog(@"%@ is NOT valid!", textField.text);
//                
//                return;
//            }
//        } 
//        return digitCount >= 7;
//        ****************

            
        //         Password: at least 6 characters
    if ([textField isEqual:self.passwordTextField]) {
        return [self.passwordTextField.text length] >= 7;
    }
    
            //    Password Confirm:  should be the same as Password
    if ([textField isEqual:self.passwordConfirmTextField]) {
        BOOL isTheSamePassword = [self.passwordConfirmTextField.text isEqualToString:self.passwordTextField.text];
        
        return isTheSamePassword;
    }
    
    NSLog(@"Warning! No specific Textfield detected.");
    return YES;
}

-(BOOL)allFieldsValid {
    BOOL allFieldsAreValid = ([self isValidInput:self.emailTextField]
                            && [self isValidInput:self.emailConfirmTextField]
                            && [self isValidInput:self.phoneTextField]
                            && [self isValidInput:self.passwordTextField]
                            && [self isValidInput:self.passwordConfirmTextField]
                              );
    if (allFieldsAreValid) {
        [self.submitButton setEnabled:YES]
        [self submitButtonGrandEntranceAnimation];
    }
    return allFieldsAreValid;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
//    if ([textField isEqual:self.phoneTextField]) {
//            //good things happen
//        if ([self isValidInput:textField]) {
//            NSLog(@"%@ is valid!", textField.accessibilityLabel);
//        }
//    } else {
//            //get angry
//    }
    if ([self isValidInput:textField]) {
        
        NSLog(@"%@ is valid!", textField.accessibilityLabel);
        
        if ([textField isEqual:self.emailTextField]) {
            [self.emailConfirmTextField setEnabled:YES];
            [self.emailConfirmTextField becomeFirstResponder];
        }
        if ([textField isEqual:self.emailConfirmTextField]) {
            [self.phoneTextField becomeFirstResponder];
        }
        if ([textField isEqual:self.phoneTextField]) {
            [self.passwordTextField becomeFirstResponder];
        }
        if ([textField isEqual:self.passwordTextField]) {
            [self.passwordConfirmTextField setEnabled:YES];
            [self.passwordConfirmTextField becomeFirstResponder];
        }
        if ([textField isEqual:self.passwordConfirmTextField]) {
            
        }
    }
    
    if ([self allFieldsValid]) {
        [self.submitButton setHidden:NO];
        [self.submitButton setEnabled:YES];
        [self submitButtonGrandEntranceAnimation];
    }
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];    
        ///one field at a time. if valid, unlock the next field. if tries to leave behind invalid input, pulse red (and prevent). if all are valid, cue the Submit button.
    
    
    return YES;
}

- (IBAction)submitButtonTapped:(id)sender {
    NSLog(@"Submit button tapped!");
}

@end
