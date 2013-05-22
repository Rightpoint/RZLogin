//
//  RZValidator.h
//  RZLogin
//
//  Created by Joshua Leibsly on 3/21/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

// these constants can be expanded upon to support additional types of validation
#define kFieldValidationRegexKey    @"regex"
#define kFieldValidationMinCharsKey @"minChars"
#define kFieldValidationMaxCharsKey @"maxChars"

// a validation block type that returns YES if given string is valid
typedef BOOL (^ValidationBlock)(NSString *str);

@interface RZValidator : NSObject

// initialize with either a validation-info dictionary or a block
- (id)initWithValidationInfo:(NSDictionary *)validationInfo;
- (id)initWithValidationBlock:(ValidationBlock)validationBlock;

// method to validate a string.
- (BOOL)validateWithString:(NSString *)str;

// convenience constructors
+ (RZValidator *)validatorWithInfo:(NSDictionary *)anyValidationInfo;
+ (RZValidator *)validatorWithBlock:(ValidationBlock)anyValidationBlock;
+ (RZValidator *)isValidEmailAddress;
+ (RZValidator *)isNotEmpty;

@end
