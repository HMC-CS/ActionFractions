//
//  Fraction.m
//  ActionFractions
//
//  Created by Admin on 10/23/12.
//
//

#import "Fraction.h"

#define LEVEL1DEN1 5
#define LEVEL1DEN2 10
#define LEVEL2MAXDEN 15
#define LEVEL3MAXVAL 100

@implementation Fraction

- (id) initWithNum:(short) n andDenom:(short) d
{
    if (self=[super init]) {
        numerator = n;
        denominator = d;
    }
    return self;
}

- (id) initWithLvl:(short)lvl
{
    if (self = [super init]){
        [self generateFraction:lvl];
    }
    return self;
}

- (short) getNumerator
{
    return numerator;
}

- (short) getDenominator
{
    return denominator;
}

- (void) setNumerator:(short)num
{   
    numerator = num;
}

- (void) setDenominator:(short)denom
{
    denominator = denom;
}

- (void) setFraction:(Fraction *)f
{
    denominator = [f getDenominator];
    numerator = [f getNumerator];
}


-(void) generateFraction:(short)lvl
{
    /*
     * We generate fractions in three difficulty classes. Fractions are always of 
     * the form a/b where 0 < a <= b. The fractions in level one are allowed b values 
     * 2,3,4,5, and 10. Fractions in level 2 are allowed b values less than or equal 
     * to 10. Level 3 includes b values up to 16. a and b values are generated randomly 
     * within the allowed ranges.
     */
    
    if (lvl == 1)
    {
        short rand = 0;
        while (rand != 2 && rand != 3 && rand != 4 && rand != 5 && rand != 10) {
            rand = (short) (arc4random() % 10) + 1;
        }
        
        denominator = rand;
        numerator = (short) (arc4random() % rand) + 1;
    }
    
    if (lvl == 2)
    {
        short rand = 0;
        while (rand == 0) {
            rand = (short) (arc4random() % 10) + 1;
        }
        
        denominator = rand;
        numerator = (short) (arc4random() % rand) + 1;
    }
    
    if (lvl == 3)
    {
        short rand = 0;
        while (rand == 0) {
            rand = (short) (arc4random() % 16) + 1;
        }
        
        denominator = rand;
        numerator = (short) (arc4random() % rand) + 1;
    }
}

- (double) decimalValue
{
    double decimal = numerator/denominator;
    return decimal;
}

- (bool) exactlyEquals:(Fraction*)fraction
{
    /*
     * Tests whether two fractions have identical representation, ie. 1/2 == 1/2 != 2/4.
     */
    
    if([fraction getNumerator] == numerator)
    {
        if([fraction getDenominator] == denominator)
        {
            return true;
        }
    }
    return false;
}

- (bool) equals:(Fraction*)fraction
{
    /*
     * Fraction equality is determined by numerator-denomenator comparison. If
     * both the numerators and denominators are identical, we shortcut and return
     * true. Otherwise, we multiply the top and bottom of each fraction by the other
     * fraction's denominator and compare.
     */
    
    if([fraction getNumerator] == numerator)
    {
        if([fraction getDenominator] == denominator)
        {
            return true;
        }
    }
    else {
        short newNumCurr = numerator * [fraction getDenominator];
        short newDenCurr = denominator * [fraction getDenominator];
        short newNumInput =[fraction getNumerator] * denominator;
        short newDenInput = [fraction getDenominator] * denominator;
        
        if (newNumCurr == newNumInput){
            if (newDenCurr == newDenInput){
                return true;
            }
        }
    }
    
     
    return false;
}
@end
