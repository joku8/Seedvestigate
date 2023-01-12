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

typedef struct {
    const char* company;
    const char* plant;
    const char* variety;
} seedpacket;

seedpacket parseData(const char* data, const char* supplier);

//seedpacket* baker_creek_seeds(const char* data);
//seedpacket* migardener_seeds(const char* data);

void destroy(seedpacket* packet);

#ifdef __cplusplus
}
#endif
