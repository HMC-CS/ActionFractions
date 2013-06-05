//
//  Fraction.h
//  ActionFractions
//
//  Created by Admin on 10/23/12.
//
//

#import <Foundation/Foundation.h>

@interface Fraction : NSObject {
    short numerator;
    short denominator;
}

-(id) initWithNum:(short) n andDenom:(short) d;
-(id) initWithLvl:(short) lvl;

// get functions returns num/denum
-(short) getNumerator;
-(short) getDenominator;

// generate functions randomly generate numerator and denominator
-(void) generateFraction:(short)lvl;

// set functions sets num/denum to some other number
-(void) setNumerator:(short) n;
-(void) setDenominator:(short) n;
-(void) setFraction:(Fraction*)f;

-(double) decimalValue;
-(bool) exactlyEquals:(Fraction*)fraction;
-(bool) equals:(Fraction *) f;

@end
