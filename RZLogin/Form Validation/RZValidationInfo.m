//
//  RZValidationInfo.m
//  RZLogin
//
//  Created by Joshua Leibsly on 3/21/13.
//  Copyright (c) 2013 Raizlabs. All rights reserved.
//

#import "RZValidationInfo.h"

//Typedef to identify whether we are validation with a dictionary or a block.
typedef enum {
    RZValidationTypeBlock,
    RZValidationTypeDictionary
} RZValidationType;

@interface RZValidationInfo ()

//Store the validation type and the info dictionary or block.
@property (nonatomic, assign) RZValidationType validationType;
@property (nonatomic, strong) NSDictionary *validationInfo;
@property (strong) ValidationBlock validationBlock;

@end

@implementation RZValidationInfo

//Constructor with a dictionary of validation information.
- (id)initWithValidationInfo:(NSDictionary *)anyValidationInfo
{
    if(self = [super init])
    {
        self.validationType = RZValidationTypeDictionary;
        self.validationInfo = anyValidationInfo;
    }
    
    return self;
}

//Constructor with a validation block.
- (id)initWithValidationBlock:(ValidationBlock)anyValidationBlock
{
    if(self = [super init])
    {
        self.validationType = RZValidationTypeBlock;
        self.validationBlock = anyValidationBlock;
    }
    
    return self;
}

//Function to validate a given string.
- (BOOL)validateWithString:(NSString *)str
{
    //If the validation type is a dictionary, iterate through the keys and validate appropriately..
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
    }
    else if(self.validationType == RZValidationTypeBlock) //If the validation uses a block, pass the string to the block and return the result.
    {
        return self.validationBlock(str);
    }
    
    return YES;
}

#pragma mark - Convenience constructors

+ (RZValidationInfo *)validationInfoWithDict:(NSDictionary *)anyValidationInfo
{
    return [[self alloc] initWithValidationInfo:anyValidationInfo];
}

+ (RZValidationInfo *)validationInfoWithBlock:(ValidationBlock)anyValidationBlock
{
    return [[self alloc] initWithValidationBlock:anyValidationBlock];
}


+ (RZValidationInfo *)emailValidationInfo
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

@end
