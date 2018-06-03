#include <iostream>
#include <sstream>
#include "stdio.h"
#include <string>
#include <bitset>
#include <type_traits>
#include <limits>
#include <vector>
using namespace std;

int calculate_expand(string input){
    int m=input.length()*8;
    int l = m%512;
    if(l<=448)
        return 448-l;
    else
        return 448+ 512-l;

}

string decimal_to_binary(int decimal){
    std::string binary = std::bitset<8>(decimal).to_string();
    return binary;
}

string msg_length_decimal_to_binary(string input){
    int decimal=input.length()*8;
    std::string binary = std::bitset<64>(decimal).to_string();
    return binary;
}

string padding_and_parsing (string input){
    //msg to binary
    string char_binary;
    for (int i  = 0; i <input.length() ; i++) {
        string d2b = decimal_to_binary((int)input.at(i)) ;
        char_binary+=d2b;
    }

    //msg length
    if(calculate_expand(input)>0)
        char_binary+='1';
    for (int i  = 0; i <calculate_expand(input)-1 ; i++)
        char_binary+='0';


    string l_binary = msg_length_decimal_to_binary(input);
    char_binary+=l_binary;

    //test
    cout <<char_binary << ' ';
    return char_binary;
}


string left_rotate(string s, int d)
{
    reverse(s.begin(), s.begin()+d);
    reverse(s.begin()+d, s.end());
    reverse(s.begin(), s.end());
}

// In-place rotates s towards right by d
string right_rotate(string s, int d)
{
    left_rotate(s, s.length()-d);
    return s;
}



//string right_shift(string s, int d){
//    string
//    for (int i = 7; i >= 0; i++)
//    {
//
//        s[i] = s[i-d];
//
//    }
//
//    return s;
//}


int main() {
    string input = "abc";
    string p = padding_and_parsing(input);
    cout << endl;
    string r =right_rotate(p, 2);
    cout <<r << endl;
//    string sh = right_shift("1100101",2);
//    cout <<endl << sh;



    return 0;
}