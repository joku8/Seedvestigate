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

/*
 Takes raw data read from the front end and processes seed packet data from it, specifically
 retrieving the following: Seed company, Plant, and Variety. These three fields are returned
 as a json
 */
const char* parseData(const char* data, const char* supplier);

/*
 Takes the plant and variety and finds an image of it to display on frontend
 */

/*
 Function to deallocate the memory associated with the json data returned by parseData
 */
void deallocateJsonString(const char* json);

/*
 Seed company packets are all formated differently, so each of the following functions parse the data
 accordingly.
 */
const char* bakerCreek(const char* data);
const char* migardener(const char* data);

#ifdef __cplusplus
}
#endif
