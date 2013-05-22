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
        //Initialize the validation info dictionary.
        self.fieldValidationInfo = [[NSMutableDictionary alloc] init];
        
        //Set the default form key type.
        self.formKeyType = kDefaultFormKeyType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

//Function to add form validation info for a text field with a given tag.
- (void)addFormValidationInfo:(RZValidationInfo *)validationInfo forTag:(int)tag
{
    //Only add the info if it exists.
    if(validationInfo != nil)
    {
        [self.fieldValidationInfo setObject:validationInfo forKey:[NSNumber numberWithInt:tag]];
    }
}

//Function to add form validation info for a text field with given placeholder text.
- (void)addFormValidationInfo:(RZValidationInfo *)validationInfo forPlaceholderText:(NSString *)text
{
    if(text != nil && validationInfo != nil)
    {
        [self.fieldValidationInfo setObject:validationInfo forKey:text];
    }
}

//Function to validate the entire form. Returns the key-value dictionary of form keys and their corresponding
//text field text if the form is valid. If the form is invalid, it returns nil.
- (NSDictionary *)validateForm
{
    NSMutableDictionary *formDict = [[NSMutableDictionary alloc] init];
    
    //Iterate through the text fields.
    for (UITextField *field in self.formFields)
    {
        RZValidationInfo *validationInfo = nil;
        id key = nil;
        
        //Get the text field key.
        if(self.formKeyType == RZFormFieldKeyTypeTag)
        {
            key = [NSNumber numberWithInt:field.tag];
        }
        else if(self.formKeyType == RZFormFieldKeyTypePlaceholderText)
        {
            key = field.placeholder;
        }
        
        //Look up the validation info. If the string is not valid, return nil.
        //If the validation info for this field does not exist, it does not need to be validated.
        validationInfo = [self.fieldValidationInfo objectForKey:key];
        if(validationInfo != nil && ![validationInfo validateWithString:field.text])
        {
            return nil;
        }
        else
        {
            [formDict setObject:field.text forKey:key];
        }
    }
    
    return formDict;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
