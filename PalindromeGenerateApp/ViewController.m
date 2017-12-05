//
//  ViewController.m
//  PalindromeGenerateApp
//
//  Created by Kostya on 04.12.2017.
//  Copyright © 2017 SKS. All rights reserved.
//

//Напишите программу, которая возвращает наибольшее число палиндром, которое является произведением двух простых пятизначных чисел, а также возвращает сами сомножители.
//Простое число - это натуральное число, которое делится нацело только на 1 и на себя само (2, 3, 5, 7, 11, …)
//Палиндром – строка, которая читается одинаково в обоих направлениях (например ABBA)

//LOG

//2017-12-05 03:59:03.752541+0200 PalindromeGenerateApp[38516:2599065] Start Algrthm = 5
//2017-12-05 03:59:04.741739+0200 PalindromeGenerateApp[38516:2599065] Recalculation = 4
//2017-12-05 03:59:04.741897+0200 PalindromeGenerateApp[38516:2599065] Start Algrthm = 4
//2017-12-05 03:59:05.773042+0200 PalindromeGenerateApp[38516:2599065] Recalculation = 3
//2017-12-05 03:59:05.773225+0200 PalindromeGenerateApp[38516:2599065] Start Algrthm = 3
//2017-12-05 03:59:06.589900+0200 PalindromeGenerateApp[38516:2599065] Final Palindrome = 999949999
//2017-12-05 03:59:06.590096+0200 PalindromeGenerateApp[38516:2599065] First multiplier = 33211
//2017-12-05 03:59:06.590189+0200 PalindromeGenerateApp[38516:2599065] Second multiplier = 30109
//2017-12-05 03:59:06.590300+0200 PalindromeGenerateApp[38516:2599065] executionTime = 2.837806

#import "ViewController.h"
#import "PolyModell.h"

@interface ViewController ()
@property (assign, nonatomic) long NDigit;
@property (assign, nonatomic) long parametr;
@property NSDate *methodStart;
@property NSDate *methodFinish;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.NDigit = 5;
    self.methodStart = [NSDate date];
    [self getMaxPalindromeWithNDigitNumbers:self.NDigit];
}

- (void)getMaxPalindromeWithNDigitNumbers:(long)n_DigitNumbers
{
    NSLog(@"Start Algrthm = %ld",self.NDigit);
    NSArray *palindromes = [self findPalindrome:[self multiplePrimes:[self generatePrimesFromOptimalParam:n_DigitNumbers toLimit:n_DigitNumbers]]];

    if(palindromes.count>1)
    {
        long poly = [[palindromes valueForKeyPath:@"@max.resultObject"] longValue];
        NSLog(@"Final Palindrome = %ld", poly);
        for(PolyModell *model in palindromes)
        {
            if(model.resultObject == poly)
            {
                NSLog(@"First multiplier = %ld", model.firstObject);
                NSLog(@"Second multiplier = %ld", model.secondObject);
            }
        }
        self.methodFinish = [NSDate date];
        NSTimeInterval executionTime = [self.methodFinish timeIntervalSinceDate:self.methodStart];
        NSLog(@"executionTime = %f", executionTime);
    }
    else
    {
        self.NDigit--;
        NSLog(@"Recalculation = %ld",self.NDigit);
        [self getMaxPalindromeWithNDigitNumbers:n_DigitNumbers];
    }
}

//0 find optimal start parametr for generation primes

-(long)findOptimalParametrWithNDigitNumbers:(long)n_DigitNumbers
{
    long limit = 20000 * n_DigitNumbers;
    for (long i=2; i<limit; i++)
    {
        bool prime = true;
        for (long j=2; j*j<=i; j++)
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
                return i;break;
            }
        }
    }
    return 0;
}

//1 generate Primes From Optimal Parametr to n Digit Numbers (five-digit)

-(NSArray*)generatePrimesFromOptimalParam:(long)parametr toLimit:(long)upperLimit
{
    NSMutableArray *primes  = [[NSMutableArray alloc]init];
    long limit = 20000*upperLimit;
    for (long i = parametr; i<limit; i++)
    {
        bool prime = true;
        for (long j=2; j*j<=i; j++)
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
    for(long i=1; i<Primes.count; i++)
    {
        for(long j=0; j<i;j++)
        {
            PolyModell *model = [PolyModell new];
            long aObject =  [[Primes objectAtIndex:i] longValue];
            long bObject =  [[Primes objectAtIndex:j] longValue];
            long resultObject = aObject*bObject;
            model.firstObject = aObject;
            model.secondObject = bObject;
            model.resultObject = resultObject;
            [multiple addObject:model];
        }
    }
    return multiple;
}

- (NSArray*)findPalindrome:(NSArray*)multiplePrimes
{
    NSMutableArray *array = [NSMutableArray new];
    for(PolyModell *model in multiplePrimes)
    {
        NSString *inStr = [NSString stringWithFormat: @"%ld", (long)model.resultObject];
        if([self isPalindrome:inStr])
        {
            [array addObject:model];
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
