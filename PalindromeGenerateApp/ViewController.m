//
//  ViewController.m
//  PalindromeGenerateApp
//
//  Created by Kostya on 04.12.2017.
//  Copyright © 2017 SKS. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (assign, nonatomic) int NDigit;
@property (assign, nonatomic) int parametr;
@property NSDate *methodStart;
@property NSDate *methodFinish;
@end

@implementation ViewController

//Напишите программу, которая возвращает наибольшее число палиндром, которое является произведением двух простых пятизначных чисел, а также возвращает сами сомножители.
//Простое число - это натуральное число, которое делится нацело только на 1 и на себя само (2, 3, 5, 7, 11, …)
//Палиндром – строка, которая читается одинаково в обоих направлениях (например ABBA)

- (void)viewDidLoad
{
    self.NDigit = 5;
    [super viewDidLoad];
    self.methodStart = [NSDate date];
    [self getMaxPalindromeWithNDigitNumbers:self.NDigit];
}

- (void)getMaxPalindromeWithNDigitNumbers:(int)n_DigitNumbers
{
    NSLog(@"Start Algrthm = %d",self.NDigit);
    NSArray *palindromes = [self findPalindrome:[self multiplePrimes:[self generatePrimesFromOptimalParam:n_DigitNumbers toLimit:n_DigitNumbers]]];

    if(palindromes.count>1)
    {
        NSLog(@"Final Palindrome = %@", [palindromes valueForKeyPath:@"@max.self"]);
        self.methodFinish = [NSDate date];
        NSTimeInterval executionTime = [self.methodFinish timeIntervalSinceDate:self.methodStart];
        NSLog(@"executionTime = %f", executionTime);
    }
    else
    {
        self.NDigit--;
        NSLog(@"Recalculation = %d",self.NDigit);
        [self getMaxPalindromeWithNDigitNumbers:n_DigitNumbers];
    }
}

//0 find optimal start parametr for generation primes

-(int)findOptimalParametrWithNDigitNumbers:(int)n_DigitNumbers
{
    int limit = 20000 * n_DigitNumbers;
    for (int i=2; i<limit; i++)
    {
        bool prime = true;
        for (int j=2; j*j<=i; j++)
        {
            if (i % j == 0)
            {
                prime = false;
                break;
            }
        }
        if(prime)
        {
            NSString *inStr = [NSString stringWithFormat: @"%ld", (long)i];
            if(inStr.length == n_DigitNumbers)
            {
                    return i;
                    break;
            }
        }
    }
    return 0;
}

//1 generate Primes From Optimal Parametr to n Digit Numbers (five-digit)

-(NSArray*)generatePrimesFromOptimalParam:(int)parametr toLimit:(int)upperLimit
{
    NSMutableArray *primes  = [[NSMutableArray alloc]init];
    int limit = 20000*upperLimit;
    for (int i = parametr; i<limit; i++)
    {
        bool prime = true;
        for (int j=2; j*j<=i; j++)
        {
            if (i % j == 0)
            {
                prime = false;
                break;
            }
        }
        if(prime)
        {
            NSString *inStr = [NSString stringWithFormat: @"%ld", (long)i];
            if(inStr.length==upperLimit)
            {
                if([[inStr substringToIndex:1] isEqualToString:[NSString stringWithFormat:@"%ld",(long)self.NDigit]])
                {
                    [primes addObject:[NSDecimalNumber numberWithInteger:i]];
                }
            }
        }
    }
    return primes;
}

//1 multiple Primes generate Primes From Optimal Parametr to n Digit Numbers (five-digit)

-(NSArray*)multiplePrimes:(NSArray*)Primes
{
    NSMutableArray *multiple = [NSMutableArray new];
    for(int i=1; i<Primes.count; i++)
    {
        for(int j=0; j<i;j++)
        {
            int aObject =  [[Primes objectAtIndex:i] intValue];
            int bObject =  [[Primes objectAtIndex:j] intValue];
            int resultObject =  aObject*bObject;
            NSString *inStr = [NSString stringWithFormat: @"%ld", (long)resultObject];
            [multiple addObject:inStr];
        }
    }
    return multiple;
}

- (NSArray*)findPalindrome:(NSArray*)multiplePrimes
{
    NSMutableArray *array = [NSMutableArray new];
    for(NSString *string in multiplePrimes)
    {
        if([self isPalindrome:string])
        {
            [array addObject:string];
        }
    }
    return array;
}

-(BOOL)isPalindrome:(NSString *)string
{
    NSUInteger length = [string length];
    for(int i=0; i<length/2; i++){
        if ([string characterAtIndex:i] != [string characterAtIndex:(length - 1 - i)])
        {
            return NO;
        }
    }
    return YES;
}

@end
