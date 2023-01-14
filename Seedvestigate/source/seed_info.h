//
//  seed_info.hpp
//  Seedvestigate
//
//  Created by Joseph Ku on 1/7/23.
//

#ifdef __cplusplus
extern "C"
{
#endif

const char* parseData(const char* data, const char* supplier);

void deallocateJsonString(const char* json);

// Case-by-case seed companies
// Look at the seed packet format to determine

const char* bakerCreek(const char* data);
const char* migardener(const char* data);

#ifdef __cplusplus
}
#endif
