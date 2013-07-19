//
//  RZFormViewController.h
//  RZLogin
//
//  Created by Joshua Leibsly on 3/21/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//
//  This class is subclassed by RZLoginEmailViewController and RZSignUpViewController

#import <UIKit/UIKit.h>

// the type of key we are using to uniquely identify text fields in the form
typedef enum {
    RZFormFieldKeyTypeTag,
    RZFormFieldKeyTypePlaceholderText
} RZFormFieldKeyType;

@class RZValidator;

@interface RZFormViewController : UIViewController

// the type of key we are using to identify text fields.
@property (nonatomic, assign) RZFormFieldKeyType formKeyType;

// The validation information for each field.
// Note the keys are the unique text-field keys and the objects are RZValidator objects.
@property (nonatomic, strong) NSMutableDictionary *fieldValidators;

// an outlet-collection of all the text fields in the form
@property (nonatomic, strong) IBOutletCollection(UITextField) NSArray *formFields;

// methods to add form validation info for the different types of keys
- (void)addValidator:(RZValidator *)validator forFieldWithTag:(int)tag;
- (void)addValidator:(RZValidator *)validator forFieldWithPlaceholderText:(NSString *)text;

// Method to validate the entire form. If the form is valid, returns null.
// If any fields are invalid, returns the first validator that failed.
- (RZValidator *)validateForm;

// returns a dictionary of all form-field keys and their corresponding values
- (NSDictionary *)formKeysAndValues;

// methods to return UITextField for a given placeholder text or tag, should one exist
- (UITextField *)fieldForPlaceholderText:(NSString *)text;
- (UITextField *)fieldForTag:(int)tag;

@end
