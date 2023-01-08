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

const char* test();
const char* parseData(const char* data);

struct {
    const char* company;
    const char* crop;
    const char* variety;
} seedpacket;

#ifdef __cplusplus
}
#endif
