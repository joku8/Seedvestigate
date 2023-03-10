//
//  utilities.cpp
//  Seedvestigate
//
//  Created by Joseph Ku on 1/14/23.
//

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

/**
 Capitalizes the first word of each word in a string (space delimited)
 @param s the reference to the string to capitalize
 */
std::string capitalize(std::string& s) {
    bool is_start_of_word = true;
    for (int i = 0; i < s.length(); i++) {
        if (is_start_of_word) {
            s[i] = std::toupper(s[i]);
            is_start_of_word = false;
        }
        else {
            s[i] = std::tolower(s[i]);
        }
        if (s[i] == ' ') {
            is_start_of_word = true;
        }
    }
    return s;
}

/**
 Converts a seed packet struct to json string
 @param packet the seed packet struct to jsonify
 
 @return a pointer to the jsonified seed packet
 */
const char* seedPacketToJson(seed_packet packet) {
    std::string json_str = "{";
    json_str += "\"company\":\"" + packet.company + "\",";
    json_str += "\"plant\":\"" + packet.plant + "\",";
    json_str += "\"variety\":\"" + packet.variety + "\"";
    json_str += "}";
    char* buffer = new char[json_str.size() + 1];
    strcpy(buffer, json_str.c_str());
    return buffer;
}

/**
 @return A vector containing possible plants that the seed packet could contain seeds for
 */
vector<string> plants_list() {
    return {
        "Artichoke", "Asparagus", "Basil", "Beans", "Beets", "Broccoli", "Brussel Sprout", "Cabbage",
        "Carrots", "Cauliflower", "Celery", "Corn", "Cover Crop", "Cucumber", "Edible Flowers", "Eggplant",
        "Fennel", "Flowers", "Garlic", "Gourds", "Grains", "Herbs", "Kale", "Kohlrabi", "Leafy Greens",
        "Lettuce", "Melons", "Microgreens", "Mustard Greens", "Okra", "Onion", "Peas", "Peppers", "Pumpkins",
        "Radish", "Rhubarb", "Root Vegetables", "Spinach", "Squash", "Strawberry", "Sunflower", "Swiss Chard",
        "Tomatillo","Tomatoes", "Turnips", "Unique Greens", "Watermelon", "Zucchini", "Bok Choy"
      };
//    return list_;
}

/**
 Function to calculate the minimum of three integers
 @param a an integer
 @param b an integer
 @param c an integer
 */
int minimum(int a, int b, int c) {
  return std::min(std::min(a, b), c);
}

/**
 Function to calculate the Levenshtein distance between two strings
 @param str1 The first comparison string
 @param str2 The second comparison string
 
 @return an integer representing the Levenshtein distance between the two input strings. In other words, this integer represents the minimum number of single-character edits (insertions, deletions or substitutions) required to change the first string into the second.
 */
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

/**
 Calculates the closest match of a string to elements of a string vector using levenshtein distance
 @param target the string to find a closest match for
 @param options a vector of strings to choose the closest match from
 
 @return The closest string match for the target found in options
 */
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
