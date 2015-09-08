/*******************************************************************************
 * Copyright (c) 2015, Jean-David Gadina - www.xs-labs.com / www.digidna.net
 * Distributed under the Boost Software License, Version 1.0.
 * 
 * Boost Software License - Version 1.0 - August 17th, 2003
 * 
 * Permission is hereby granted, free of charge, to any person or organization
 * obtaining a copy of the software and accompanying documentation covered by
 * this license (the "Software") to use, reproduce, display, distribute,
 * execute, and transmit the Software, and to prepare derivative works of the
 * Software, and to permit third-parties to whom the Software is furnished to
 * do so, all subject to the following:
 * 
 * The copyright notices in the Software and this entire statement, including
 * the above license grant, this restriction and the following disclaimer,
 * must be included in all copies of the Software, in whole or in part, and
 * all derivative works of the Software, unless such copies or derivative
 * works are solely in the form of machine-executable object code generated by
 * a source language processor.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
 * SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
 * FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
 * DEALINGS IN THE SOFTWARE.
 ******************************************************************************/

/*!
 * @file        Test-Map.mm
 * @copyright   (c) 2015 - Jean-David Gadina - www.xs-labs.com / www.digidna.net
 * @abstract    Unit tests for map functions
 */

#import <ObjectiveCPP.hpp>
#import <GoogleMock/GoogleMock.h>

/* Not wanted for Objective-C */
#pragma clang diagnostic ignored "-Wobjc-missing-property-synthesis"
#pragma clang diagnostic ignored "-Wselector"

@interface ObjectiveCPP_Map_Test_K: NSObject

@property( atomic, readwrite, assign ) std::string string;

- ( instancetype )initWithSTDString: ( std::string )s;

@end

@implementation ObjectiveCPP_Map_Test_K

- ( instancetype )initWithSTDString: ( std::string )s
{
    if( ( self = [ super init ] ) )
    {
        self.string = s;
    }
    
    return self;
}

@end

@interface ObjectiveCPP_Map_Test_V: NSObject

@property( atomic, readwrite, assign ) std::string string;

- ( instancetype )initWithSTDString: ( std::string )s;

@end

@implementation ObjectiveCPP_Map_Test_V

- ( instancetype )initWithSTDString: ( std::string )s
{
    if( ( self = [ super init ] ) )
    {
        self.string = s;
    }
    
    return self;
}

@end

using namespace testing;

TEST( ObjectiveCPP_Map, DictionaryFromMap_Int_Int )
{
    std::map< int, int > m = { { 0, 1 }, { 2, 3 }, { 42, 43 } };
    NSDictionary       * d;
    
    d = ObjectiveCPP::DictionaryFromMap< int, NSNumber >( m, @selector( initWithInt: ) );
    
    ASSERT_TRUE( d.count == m.size() );
    
    ASSERT_TRUE( [ d objectForKey: @0  ] != nil );
    ASSERT_TRUE( [ d objectForKey: @2  ] != nil );
    ASSERT_TRUE( [ d objectForKey: @42 ] != nil );
    
    ASSERT_TRUE( [ [ d objectForKey: @0  ] isKindOfClass: [ NSNumber class ] ] );
    ASSERT_TRUE( [ [ d objectForKey: @2  ] isKindOfClass: [ NSNumber class ] ] );
    ASSERT_TRUE( [ [ d objectForKey: @42 ] isKindOfClass: [ NSNumber class ] ] );
    
    ASSERT_TRUE( [ [ d objectForKey: @0  ] isEqual: @1 ] );
    ASSERT_TRUE( [ [ d objectForKey: @2  ] isEqual: @3 ] );
    ASSERT_TRUE( [ [ d objectForKey: @42 ] isEqual: @43 ] );
}

TEST( ObjectiveCPP_Map, DictionaryFromMap_String_String )
{
    std::map< std::string, std::string > m = { { "hello", "world" }, { "foo", "bar" } };
    NSDictionary                       * d;
    
    d = ObjectiveCPP::DictionaryFromMap( m );
    
    ASSERT_TRUE( d.count == m.size() );
    
    ASSERT_TRUE( [ d objectForKey: @"hello" ] != nil );
    ASSERT_TRUE( [ d objectForKey: @"foo"   ] != nil );
    
    ASSERT_TRUE( [ [ d objectForKey: @"hello" ] isKindOfClass: [ NSString class ] ] );
    ASSERT_TRUE( [ [ d objectForKey: @"foo"   ] isKindOfClass: [ NSString class ] ] );
    
    ASSERT_TRUE( [ [ d objectForKey: @"hello" ] isEqualToString: @"world" ] );
    ASSERT_TRUE( [ [ d objectForKey: @"foo"   ] isEqualToString: @"bar" ] );
}

TEST( ObjectiveCPP_Map, ArrayFromVector_String_Custom )
{
    std::map< std::string, std::string > m = { { "hello", "world" }, { "foo", "bar" } };
    NSDictionary                       * d;
    
    d = ObjectiveCPP::DictionaryFromMap< std::string, std::string, NSString, ObjectiveCPP_Map_Test_V >( m, @selector( initWithCPPString: ), @selector( initWithSTDString: ) );
    
    ASSERT_TRUE( d.count == m.size() );
    
    ASSERT_TRUE( [ d objectForKey: @"hello" ] != nil );
    ASSERT_TRUE( [ d objectForKey: @"foo"   ] != nil );
    
    ASSERT_TRUE( [ [ d objectForKey: @"hello" ] isKindOfClass: [ ObjectiveCPP_Map_Test_V class ] ] );
    ASSERT_TRUE( [ [ d objectForKey: @"foo"   ] isKindOfClass: [ ObjectiveCPP_Map_Test_V class ] ] );
    
    ASSERT_TRUE( ( ( ObjectiveCPP_Map_Test_K * )[ d objectForKey: @"hello" ] ).string == "world" );
    ASSERT_TRUE( ( ( ObjectiveCPP_Map_Test_V * )[ d objectForKey: @"foo"   ] ).string == "bar" );
}

TEST( ObjectiveCPP_Map, MapFromDictionary_String_String )
{
    NSDictionary                       * d;
    std::map< std::string, std::string > m;
    
    d = @{ @"hello": @"world", @"foo": @"bar" };
    m = ObjectiveCPP::MapFromDictionary< std::string, NSString >( d, @selector( cppString ) );
    
    ASSERT_TRUE( d.count == m.size() );
    
    ASSERT_TRUE( m.find( "hello" ) != m.end() );
    ASSERT_TRUE( m.find( "foo" )   != m.end() );
    
    ASSERT_TRUE( m[ "hello" ] == "world" );
    ASSERT_TRUE( m[ "foo" ]   == "bar" );
}

TEST( ObjectiveCPP_Map, MapFromDictionary_String_Int )
{
    NSDictionary               * d;
    std::map< std::string, int > m;
    
    d = @{ @"hello": @1, @"foo": @42 };
    m = ObjectiveCPP::MapFromDictionary< std::string, int, NSString, NSNumber >( d, @selector( cppString ), @selector( intValue ) );
    
    ASSERT_TRUE( d.count == m.size() );
    
    ASSERT_TRUE( m.find( "hello" ) != m.end() );
    ASSERT_TRUE( m.find( "foo" )   != m.end() );
    
    ASSERT_TRUE( m[ "hello" ] == 1 );
    ASSERT_TRUE( m[ "foo" ]   == 42 );
}
