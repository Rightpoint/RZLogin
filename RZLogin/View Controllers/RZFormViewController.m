//
//  RZFormViewController.m
//  RZLogin
//
//  Created by Joshua Leibsly on 3/21/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZFormViewController.h"
#import "RZValidationInfo.h"

#define kDefaultFormKeyType RZFormFieldKeyTypePlaceholderText

@interface RZFormViewController ()

@end

@implementation RZFormViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Initialize the validation info dictionary.
        self.fieldValidationInfo = [[NSMutableDictionary alloc] init];
        
        // Set the default form key type.
        self.formKeyType = kDefaultFormKeyType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

// add form validation info for a text-field with a given tag
- (void)addFormValidationInfo:(RZValidationInfo *)validationInfo forTag:(int)tag
{
    //Only add the info if it exists.
    if(validationInfo != nil)
    {
        [self.fieldValidationInfo setObject:validationInfo forKey:[NSNumber numberWithInt:tag]];
    }
}

// add form validation info for a text-field with given placeholder text
- (void)addFormValidationInfo:(RZValidationInfo *)validationInfo forPlaceholderText:(NSString *)text
{
    if(text != nil && validationInfo != nil)
    {
        [self.fieldValidationInfo setObject:validationInfo forKey:text];
    }
}

// Method to validate the entire form. If the form is valid, returns a key-value dictionary
// containing all form-field keys and their corresponding values. If the form is invalid, returns nil.
- (NSDictionary *)validateForm
{
    NSMutableDictionary *formDict = [[NSMutableDictionary alloc] init];
    
    // iterate through the text-fields...
    for (UITextField *field in self.formFields)
    {
        RZValidationInfo *validationInfo = nil;
        id key = nil;
        
        // get the key for the text-field
        if(self.formKeyType == RZFormFieldKeyTypeTag)
        {
            key = [NSNumber numberWithInt:field.tag];
        }
        else if(self.formKeyType == RZFormFieldKeyTypePlaceholderText)
        {
            key = field.placeholder;
        }
        
        // Look-up the validation info for this field. If the string is not valid, return nil.
        // If the validation info for this field does not exist, it does not need to be validated.
        validationInfo = [self.fieldValidationInfo objectForKey:key];
        if(validationInfo != nil && ![validationInfo validateWithString:field.text])
        {
            return nil; // invalid, we're done
        }
        else
        {
            [formDict setObject:field.text forKey:key];
        }
    }
    return formDict; // ok, everything's valid
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
