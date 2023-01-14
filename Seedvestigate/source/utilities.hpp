//
//  utilities.hpp
//  Seedvestigate
//
//  Created by Joseph Ku on 1/14/23.
//

#ifndef utilities_hpp
#define utilities_hpp

#include <stdio.h>
#include <string>

using namespace std;

/*
 struct to store seed packet data within c++ code. Keeps these fields in the same location
 */
typedef struct seed_packet {
    std::string company;
    std::string plant;
    std::string variety;
    seed_packet() : company("None"), plant("None"), variety("None") {}
} seed_packet;

/*
 Helper function to capitalize the first letter of each word and lowercase everything else
 */
std::string capitalize(std::string& s);

/*
 converts seed_packet struct to json data to be sent off to frontend
 */
const char* seedPacketToJson(seed_packet packet);

/*
 stores the potential plants a seed packet might contain seeds of
 */
vector<string> plants_list();

/*
 uses Levenshtein distance to calculate the closest match of a target to elements in a vector
 */
string closest_match(string target, vector<string> options);

#endif /* utilities_hpp */
