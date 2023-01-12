//
//  seed_info.cpp
//  Seedvestigate
//
//  Created by Joseph Ku on 1/7/23.
//

#include "seed_info.h"

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

string seedPacketToJson(seedpacket packet) {
    std::string json_str = "{";
    json_str += "\"company\":\"" + std::string(packet.company) + "\",";
    json_str += "\"plant\":\"" + std::string(packet.plant) + "\",";
    json_str += "\"variety\":\"" + std::string(packet.variety) + "\"";
    json_str += "}";
    return json_str;
}

vector<string> plants_list() {
    vector<string> list_ = {
        "Artichoke", "Asparagus", "Basil", "Beans", "Beets", "Broccoli", "Brussel Sprout", "Cabbage",
        "Carrots", "Cauliflower", "Celery", "Corn", "Cover Crop", "Cucumber", "Edible Flowers", "Eggplant",
        "Fennel", "Flowers", "Garlic", "Gourds", "Grains", "Herbs", "Kale", "Kohlrabi", "Leafy Greens",
        "Lettuce", "Melons", "Microgreens", "Mustard Greens", "Okra", "Onion", "Peas", "Peppers", "Pumpkins",
        "Radish", "Rhubarb", "Root Vegetables", "Spinach", "Squash", "Strawberry", "Sunflower", "Swiss Chard",
        "Tomatillo","Tomatoes", "Turnips", "Unique Greens", "Watermelon", "Zucchini"
      };
    return list_;
}

// Function to calculate the minimum of three values
int minimum(int a, int b, int c) {
  return std::min(std::min(a, b), c);
}

// Function to calculate the Levenshtein distance between two strings
int levenshteinDistance(std::string str1, std::string str2) {
  unsigned long m = str1.length();
  unsigned long n = str2.length();
  std::vector<std::vector<int>> d(m + 1, std::vector<int>(n + 1));

  for (int i = 0; i <= m; i++)
    d[i][0] = i;
  for (int j = 0; j <= n; j++)
    d[0][j] = j;

  for (int j = 1; j <= n; j++) {
    for (int i = 1; i <= m; i++) {
      if (str1[i - 1] == str2[j - 1])
        d[i][j] = d[i - 1][j - 1];
      else
        d[i][j] = minimum(d[i - 1][j], d[i][j - 1], d[i - 1][j - 1]) + 1;
    }
  }
  return d[m][n];
}

string closest_match(string target, vector<string> options) {
    int minDistance = INT_MAX;
    std::string closestMatch;
    for (const auto &s : options) {
        int distance = levenshteinDistance(target, s);
        if (distance < minDistance) {
          minDistance = distance;
          closestMatch = s;
        }
    }
    std::cout << "The closest match is: " << closestMatch << '\n';
    return closestMatch;
}

seedpacket parseData(const char* data, const char* supplier) {
    
    cout << "supplier is " << supplier << endl;
        
    if (strcmp(supplier, "Baker Creek Heirloom Seeds")) {
        
        
        
    } else if (strcmp(supplier, "MIgardener")) {
        
        
        
    }
        
    seedpacket default_ = {"--", "--", "--"};

    return default_;
}

//seedpacket* baker_creek_seeds(const char* data) {
//    
//    printf("Processing seed packet as Baker Creek");
//    
//    return seedpacket;
//}
//
//seedpacket* migardener_seeds(const char* data) {
//    
//    printf("Processing seed packet as MIgardener");
//    
//    return seedpacket;
//}
