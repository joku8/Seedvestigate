//
//  seed_info.cpp
//  Seedvestigate
//
//  Created by Joseph Ku on 1/7/23.
//

#include "seed_info.h"
#include "utilities.hpp"

#include <stdio.h>
#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <filesystem>
#include <algorithm>
#include <cstring>
#include <stdexcept>

using namespace std;
namespace fs = std::filesystem;



const char* parseData(const char* data, const char* supplier) {
    
    cout << "supplier is " << supplier << endl;
    
    string supplier_(supplier);
        
    if (supplier_ == "Baker Creek Heirloom Seeds") {

        return bakerCreek(data);

    }
    
    if (supplier_ == "MIgardener") {

        return migardener(data);

    }
    
    seed_packet default_ = seed_packet();

    return seedPacketToJson(default_);
}

const char* bakerCreek(const char* data) {
    cout << "Process this as Baker Creek Seed Packet Data: \n" << data << endl;
    seed_packet bc = seed_packet();
    bc.company = "Baker Creek Heirloom Seeds";
    
    string string_data(data);
    
    std::vector<std::string> text_areas;
    std::size_t pos = 0, found;
    while ((found = string_data.find(",", pos)) != std::string::npos) {
        text_areas.push_back(string_data.substr(pos, found - pos));
        pos = found + 1;
    }
    text_areas.push_back(string_data.substr(pos));
    
    bc.plant = closest_match(text_areas[0], plants_list());
    
    bc.variety = capitalize(text_areas[1]);
    
    return seedPacketToJson(bc);
}

const char* migardener(const char* data) {
    cout << "Process this as MIgardener Seed Packet Data: \n" << data << endl;
    seed_packet mi = seed_packet();
    mi.company = "MIgardener";
    
    
    
    return seedPacketToJson(mi);
}

void deallocateJsonString(const char* json) {
    cout << "DEALLOCATING" << endl;
    delete[] json;
}
