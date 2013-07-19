//
//  RZFormViewController.m
//  RZLogin
//
//  Created by Joshua Leibsly on 3/21/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZFormViewController.h"
#import "RZValidator.h"

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
        self.fieldValidators = [[NSMutableDictionary alloc] init];
        
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
- (void)addValidator:(RZValidator *)validator forFieldWithTag:(int)tag
{
    //Only add the info if it exists.
    if(validator != nil)
    {
        [self.fieldValidators setObject:validator forKey:[NSNumber numberWithInt:tag]];
    }
}

// add form validation info for a text-field with given placeholder text
- (void)addValidator:(RZValidator *)validator forFieldWithPlaceholderText:(NSString *)text
{
    if(text != nil && validator != nil)
    {
        [self.fieldValidators setObject:validator forKey:text];
    }
}

// Method to validate the entire form. If the form is valid, returns null.
// If any fields are invalid, returns the first validator that failed.
- (RZValidator *)validateForm
{    
    // iterate through the text-fields...
    for (UITextField *field in self.formFields)
    {
        RZValidator *validator = nil;
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
        validator = [self.fieldValidators objectForKey:key];
        if(validator != nil && ![validator isValidForString:field.text])
        {
            return validator; // invalid, we're done
        }
    }
    return nil; // ok, everything's valid
}

// returns a dictionary of all form-field keys and their corresponding values
- (NSDictionary *)formKeysAndValues
{
    // iterate through the text-fields and build a dictionary
    NSMutableDictionary *formDict = [[NSMutableDictionary alloc] init];
    for (UITextField *field in self.formFields) {
        [formDict setObject:field.text forKey:field.placeholder];
    }
    return formDict;
}

- (UITextField *)fieldForPlaceholderText:(NSString *)text
{
    // iterate through the text-fields...
    for (UITextField *field in self.formFields)
    {
        if ([field.placeholder isEqualToString:text])
        {
            return field;
        }
    }
    
    return nil; //search was unsuccessful
}

- (UITextField *)fieldForTag:(int)tag
{
    // iterate through the text-fields...
    for (UITextField *field in self.formFields)
    {
        if (field.tag == tag)
        {
            return field;
        }
    }
    
    return nil; //search was unsuccessful
}

@end
