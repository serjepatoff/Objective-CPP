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
 * @header      Map.h
 * @copyright   (c) 2015 - Jean-David Gadina - www.xs-labs.com / www.digidna.net
 */

#include <map>

namespace ObjectiveCPP
{
    template < typename TK, typename TV, typename ObjCClassK, typename ObjCClassV >
    NSDictionary * DictionaryFromMap( const std::map< TK, TV > & map, SEL initMethodK, SEL initMethodV )
    {
        NSMutableDictionary * d;
        id ( * iK )( id, SEL, TK );
        id ( * iV )( id, SEL, TV );
        
        d = [ NSMutableDictionary dictionaryWithCapacity: map.size() ];
        
        for( auto p: map )
        {
            {
                id oK;
                id oV;
                
                oK = [ ObjCClassK alloc ];
                oV = [ ObjCClassV alloc ];
                iK = reinterpret_cast< id ( * )( id, SEL, TK ) >( [ oK methodForSelector: initMethodK ] );
                iV = reinterpret_cast< id ( * )( id, SEL, TV ) >( [ oV methodForSelector: initMethodV ] );
                oK = iK( oK, initMethodK, p.first );
                oV = iV( oV, initMethodV, p.second );
                
                if( oK != nil && oV != nil )
                {
                    [ d setObject: oV forKey: oK ];
                }
                
                #if !defined( __clang__ ) || !defined( __has_feature ) || !__has_feature( objc_arc )
                [ oK release ];
                [ oV release ];
                #endif
            }
        }
        
        return [ NSDictionary dictionaryWithDictionary: d ];
    }
}
