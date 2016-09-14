//
//  ATMacros.h
//  ATFoundation
//
//  Created by Aesir Titan on 2016-09-02.
//  Copyright © 2016 Titan Studio. All rights reserved.
//

#ifndef ATMacros_h
#define ATMacros_h

#if !defined(AT_INITIALIZER)
# if __has_attribute(objc_method_family)
#  define AT_INITIALIZER __attribute__((objc_method_family(init)))
# else
#  define AT_INITIALIZER
# endif
#endif

#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000) || (defined(__MAC_OS_X_VERSION_MAX_ALLOWED) && __MAC_OS_X_VERSION_MAX_ALLOWED >= 1010)
#define DISPATCH_CANCELLATION_SUPPORTED 1
#else
#define DISPATCH_CANCELLATION_SUPPORTED 1
#endif


#endif /* ATMacros_h */
