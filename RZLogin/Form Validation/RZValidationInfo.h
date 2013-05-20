//
//  RZValidationInfo.h
//  RZLogin
//
//  Created by Joshua Leibsly on 3/21/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import <Foundation/Foundation.h>

//These constants can be expanded upon to support more types of validation.
#define kFieldValidationRegexKey    @"regex"
#define kFieldValidationMinCharsKey @"minChars"
#define kFieldValidationMaxCharsKey @"maxChars"

//Validation block that returns whether or not a string is valid.
typedef BOOL (^ValidationBlock)(NSString *str);

@interface RZValidationInfo : NSObject

//Constructors to initialize with either a validation dictionary or a block.
- (id)initWithValidationInfo:(NSDictionary *)anyValidationInfo;
- (id)initWithValidationBlock:(ValidationBlock)anyValidationBlock;

//Function to validate a string.
- (BOOL)validateWithString:(NSString *)str;

//Convenience constructors.
+ (RZValidationInfo *)validationInfoWithDict:(NSDictionary *)anyValidationInfo;
+ (RZValidationInfo *)validationInfoWithBlock:(ValidationBlock)anyValidationBlock;
+ (RZValidationInfo *)emailValidationInfo;

@end
