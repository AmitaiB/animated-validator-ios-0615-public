//
//  ValidatorViewController.m
//  AnimatedValidator
//
//  Created by Al Tyus on 5/12/14.
//  Copyright (c) 2014 al-tyus.com. All rights reserved.
//

#import "ValidatorViewController.h"
#import "Constants.h"

/**
 pod 'NSString+email' (caveat: uses an overly strict regex)
 
 In real life, follow this advice:
 http://davidcel.is/posts/stop-validating-email-addresses-with-regex/
 */
#import "NSString+Email.h"


@interface ValidatorViewController ()<UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet UITextField *emailTextField;
@property (nonatomic, weak) IBOutlet UITextField *emailConfirmTextField;
@property (nonatomic, weak) IBOutlet UITextField *phoneTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordTextField;
@property (nonatomic, weak) IBOutlet UITextField *passwordConfirmTextField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@end

@implementation ValidatorViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.submitButton.accessibilityLabel = SUBMITBUTTON;
    self.emailTextField.accessibilityLabel = EMAILTEXTFIELD;
    self.emailConfirmTextField.accessibilityLabel = EMAILCONFIRMTEXTFIELD;
    self.phoneTextField.accessibilityLabel = PHONETEXTFIELD;
    self.passwordTextField.accessibilityLabel = PASSWORDTEXTFIELD;
    self.passwordConfirmTextField.accessibilityLabel = PASSWORDCONFIRMTEXTFIELD;
      
        ///Submit button appears when all are valid entries.
    self.submitButton.hidden = YES;
    [self assignDelegates];
    
}


-(void)assignDelegates {
    self.emailTextField.delegate = self;
    self.emailConfirmTextField.delegate = self;
    self.phoneTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.passwordConfirmTextField.delegate = self;
    
}

-(void)errorPulseFieldAnimation {
    
}

-(void)submitButtonGrandEntranceAnimation {
    
}

-(BOOL)isValidInput:(UITextField *)textField {
        /**
         Email:  Should be a valid email
         Email confirm: should be the same as Email
         Phone: only digits or a +, at least 7 digits
         Password: at least 6 characters
    Password Confirm
    should be the same as Password
    */
        //#1 good. #2 good. #3 good. #4 good. #5 good.
    if ([textField isEqual:self.emailTextField]) {
        return [self.emailTextField.text isEmail];
    }
    
    if ([textField isEqual:self.emailConfirmTextField]) {
        BOOL isTheSameEmail = [self.emailConfirmTextField.text isEqualToString:self.emailTextField.text];
        return isTheSameEmail;
    }
    
    if ([textField isEqual:self.phoneTextField]) {
        
            //Count the digits in the string.
        NSUInteger digitCount = 0;
        for (NSInteger i = 0; i < [self.phoneTextField.text length]; i++) {
            unichar myChar = [self.phoneTextField.text characterAtIndex:i];
            if (myChar >= '0'  &&  myChar <= '9') {
                digitCount++;
            }
        } 

        BOOL hasLessThan7digits = digitCount < 7;
        
        NSCharacterSet *invalidCharacters = [[NSCharacterSet characterSetWithCharactersInString:@"+1234567890.-()"] invertedSet];
        BOOL hasInvalidChars = !([self.phoneTextField.text rangeOfCharacterFromSet:invalidCharacters].location != NSNotFound);
        
            //Phone #s are at least 7 digits, and only contain digits 
        return (hasLessThan7digits || hasInvalidChars); 
    }
    
    if ([textField isEqual:self.passwordTextField]) {
        return [self.passwordTextField.text length] < 6;
    }
    
    if ([textField isEqual:self.passwordConfirmTextField]) {
        BOOL isTheSamePassword = [self.passwordConfirmTextField.text isEqualToString:self.passwordTextField.text];
        return isTheSamePassword;
    }
    
    NSLog(@"Warning! No specific Textfield detected.");
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
        ///one field at a time. if valid, unlock the next field. if tries to leave behind invalid input, pulse red (and prevent). if all are valid, cue the Submit button.
    
    
    if ([self isValidInput:textField]) {
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
    
    return YES;
}

@end
