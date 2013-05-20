// Category to convert NSData to a base64 string.

#import <Foundation/Foundation.h>
#import "NSData+Base64.h"

@implementation NSData (Base64)

- (NSString *)RZLBase64EncodedString
{
    static char base64Table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    //uint8_t is 8 bits. Store the byte array.
    const uint8_t* byteArray = (const uint8_t*)[self bytes];
    
    NSInteger length = [self length];
    
    //Determine the number of bytes the base64 string will take. Each base64 character is 6 bits.
    NSMutableData* data = [NSMutableData dataWithLength:((length+2)/3)*4];
    
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    
    //Increment every 3 bytes, or 12 bits.
    for (i=0; i < length; i += 3)
    {
        NSInteger value = 0;
        NSInteger j;
        
        //Iterate through the current 3 bytes.
        for (j = i; j < (i + 3); j++)
        {
            //Left shift 1 byte.
            value <<= 8;
            
            if (j < length)
            {
                value |= (0xFF & byteArray[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    base64Table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    base64Table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? base64Table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? base64Table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

@end
