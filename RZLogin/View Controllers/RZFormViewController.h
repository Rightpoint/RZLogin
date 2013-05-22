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

@class RZValidationInfo;

@interface RZFormViewController : UIViewController

// the type of key we are using to identify text fields.
@property (nonatomic, assign) RZFormFieldKeyType formKeyType;

// The validation information for each field.
// Note the keys are the unique text-field keys and the objects are RZValidationInfo objects.
@property (nonatomic, strong) NSMutableDictionary *fieldValidationInfo;

// an outlet-collection of all the text fields in the form
@property (nonatomic, strong) IBOutletCollection(UITextField) NSArray *formFields;

// methods to add form validation info for the different types of keys; and to validate the form
- (void)addFormValidationInfo:(RZValidationInfo *)validationInfo forTag:(int)tag;
- (void)addFormValidationInfo:(RZValidationInfo *)validationInfo forPlaceholderText:(NSString *)text;
- (NSDictionary *)validateForm;

@end
