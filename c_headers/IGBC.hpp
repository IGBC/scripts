/*** IGBC.hpp ***/
/** Custom header file of IGBC (SEGFAULT)
 * [will not actually cause segfaults]
 * 
 * This file contains various macros used by the author
 * to make every day C++ hacking easier. (C++ is hard OK?)
 * 
 * This file should only depend on the standard lib, however is written for C++14
 *
 * This file is liecenced under the GNU Public Licence Version 3 (GPLv3)
 */

#ifndef IGBC_H
#define IGBC_H

#include <iomanip>
#include <iostream>

/** HEXIFY
 * Converts given value into an apropriate length hex string.
 * Arguments: val: value to be converted (including type)
 * Usage:
 *     std::cout << "value = " << HEXIFY(int); 
 */
#define HEXIFY(val) "0x" << std::setfill ('0') << std::setw (sizeof(val)*2) << std::hex << static_cast<unsigned long>(val)

#endif //IGBC_H