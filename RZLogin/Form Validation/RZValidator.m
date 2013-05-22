//
//  RZValidator.m
//  RZLogin
//
//  Created by Joshua Leibsly on 3/21/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZValidator.h"

//Typedef to identify whether we are validation with a dictionary or a block.
typedef enum {
    RZValidationTypeBlock,
    RZValidationTypeDictionary
} RZValidationType;

@interface RZValidator ()

//Store the validation type and the info dictionary or block.
@property (nonatomic, assign) RZValidationType validationType;
@property (nonatomic, strong) NSDictionary *validationInfo;
@property (strong) ValidationBlock validationBlock;

@end

@implementation RZValidator

// constructor that accepts a dictionary of validation information
- (id)initWithValidationInfo:(NSDictionary *)validationInfo
{
    if(self = [super init])
    {
        self.validationType = RZValidationTypeDictionary;
        self.validationInfo = validationInfo;
    }
    
    return self;
}

// constructor that accepts a validation block
- (id)initWithValidationBlock:(ValidationBlock)validationBlock
{
    if(self = [super init])
    {
        self.validationType = RZValidationTypeBlock;
        self.validationBlock = validationBlock;
    }
    
    return self;
}

// validates a given string against the receiver (validator)
- (BOOL)validateWithString:(NSString *)str
{
    // if validation type is a dictionary, iterate through the keys and validate appropriately...
    if(self.validationType == RZValidationTypeDictionary)
    {
        NSArray *allKeys = [self.validationInfo allKeys];
        for(NSString *key in allKeys)
        {
            if([key isEqualToString:kFieldValidationRegexKey]) //Regex case. Use NSPredicate to validate.
            {
                NSPredicate *regexPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", [self.validationInfo objectForKey:key]];
                if(![regexPredicate evaluateWithObject:str])
                {
                    return NO;
                }
            }
            else if([key isEqualToString:kFieldValidationMinCharsKey]) //Min chars case. Check length of string.
            {
                int minChars = [[self.validationInfo objectForKey:key] intValue];
                if(str.length < minChars)
                {
                    return NO;
                }
            }
            else if([key isEqualToString:kFieldValidationMaxCharsKey]) //Max chars case. Check length of string.
            {
                int maxChars = [[self.validationInfo objectForKey:key] intValue];
                if(str.length > maxChars)
                {
                    return NO;
                }
            }
        }
        
    } else if(self.validationType == RZValidationTypeBlock)  {
        
        // if the validator uses a block, pass the string to the block and return the result
        return self.validationBlock(str);
    }
    return YES;
}

#pragma mark - Convenience constructors

+ (RZValidator *)validatorWithInfo:(NSDictionary *)validationInfo
{
    return [[self alloc] initWithValidationInfo:validationInfo];
}

+ (RZValidator *)validatorWithBlock:(ValidationBlock)validationBlock
{
    return [[self alloc] initWithValidationBlock:validationBlock];
}

+ (RZValidator *)isValidEmailAddress
{
    //Regex expression from: http://www.cocoawithlove.com/2009/06/verifying-that-string-is-email-address.html
    NSString *emailRegEx =  @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
                            @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
                            @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
                            @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
                            @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
                            @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
                            @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    
    return [[self alloc] initWithValidationInfo:@{kFieldValidationRegexKey : emailRegEx}];
}

+ (RZValidator *)isNotEmpty
{
    return [[self alloc] initWithValidationInfo:@{kFieldValidationMinCharsKey : @"1"}];
}

@end
