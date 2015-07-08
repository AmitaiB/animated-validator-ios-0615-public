//
//  ValidatorViewController.m
//  AnimatedValidator
//
//  Created by Al Tyus on 5/12/14.
//  Copyright (c) 2014 al-tyus.com. All rights reserved.
//

#import "ValidatorViewController.h"
#import "Constants.h"

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
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
        ///one field at a time. if valid, unlock the next field. if tries to leave behind invalid input, pulse red (and prevent). if all are valid, cue the Submit button.
    

        ///These two lines get us our textField as a primitive...
    NSArray *signupTextFieldsArray = @[self.emailTextField,
                                       self.emailConfirmTextField,
                                       self.passwordConfirmTextField,
                                       self.passwordTextField,
                                       self.passwordConfirmTextField];
    NSUInteger currentTextField = [signupTextFieldsArray indexOfObjectIdenticalTo:textField];

    BOOL isValidInput = [self isValidInput:textField];
    BOOL isNotValidInput = !isValidInput;
    
        ///...which can then be used with this macro for...
    typedef NS_ENUM(NSInteger, signupTextFields) {
        emailTextField,
        emailConfirmTextField,
        phoneTextField,
        passwordTextField,
        passwordConfirmTextField
    };
    
        ///...a plain-English switch-case.
    if (isValidInput) {
        switch (currentTextField) {
            case emailTextField:
                <#statements#>
                break;
            case emailConfirmTextField:
                <#statements#>
                break;
            case phoneTextField:
                <#statements#>
                break;
            case passwordTextField:
                <#statements#>
                break;
            case passwordConfirmTextField:
                <#statements#>
                break;
                
            default:
                break;
        }
    }
    
    else if (isNotValidInput) {
        switch (currentTextField) {
            case <#constant#>:
                <#statements#>
                break;
            case <#constant#>:
                <#statements#>
                break;
            case <#constant#>:
                <#statements#>
                break;
            case <#constant#>:
                <#statements#>
                break;
            case <#constant#>:
                <#statements#>
                break;
                
            default:
                break;
        }
    }
    

}

@end
