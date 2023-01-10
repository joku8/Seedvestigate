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

struct seedpacket{
    const char* company;
    const char* plant;
    const char* variety;
} seedpacket;

const char* parseData(const char* data, const char* supplier);


#ifdef __cplusplus
}
#endif
