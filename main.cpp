#include <iostream>
#include <sstream>
#include "stdio.h"
#include <string>
#include <bitset>
#include <type_traits>
#include <limits>
//#include <dynamic_bitset.hpp>
#include <vector>

using namespace std;


int message_length (string input){
    return static_cast<int>(input.length() * 8);
}


int calculate_zero(int m){

    int i = 0;

    while(i+1 +m % 512 != 448 ){
        i++;

    }
    return i;

}


int array_to_int(int arr[])
{


    int number = 0;

    for (int i = 0; i < sizeof(arr) ; i++) {
        number *= 10;
        number += arr[i];
    }

    return number;
}

//vector<int> decimal_to_binary(int decimal){
//    vector<int> binary;
//
//    while (decimal>0){
//        binary.push_back(decimal%2);
//        decimal = decimal/2;
//
//    }
//    return binary;
//}

vector<int> decimal_to_binary(int decimal){

        vector<int> binary;

        unsigned long i = 0;
        while (decimal>0){
            binary.push_back(decimal%2);
            decimal = decimal/2;
            i++;
        }
        unsigned long padding = 8-(i%8);
        while (padding > 0) {
            binary.push_back(0);
            padding--;
        }
        binary.reserve(i);
        return binary;
    }


//constexpr std::size_t ULONGLONG_BITS = std::numeric_limits<unsigned long long>::digits ;
//
///*
//template< std::size_t N1, std::size_t N2 >
//typename std::enable_if< (N1+N2) <= ULONGLONG_BITS, std::bitset<N1+N2> >::type // efficient for small sizes
//cat( const std::bitset<N1>& a, const std::bitset<N2>& b ) { return ( a.to_ullong() << N2 ) + b.to_ullong() ; }
//*/
//
//template< std::size_t N1, std::size_t N2 >
//typename std::enable_if< ( (N1+N2) > ULONGLONG_BITS ), std::bitset<N1+N2> >::type
//cat( const std::bitset<N1>& a, const std::bitset<N2>& b ) { return std::bitset<N1+N2>( a.to_string() + b.to_string() ) ; }
//
//bitset string_to_binary (string input){
//
//    bitset msg_bin ;
//
//    for (std::size_t i = 0; i < input.size(); ++i)
//    {
//        msg_bin = cat( msg_bin, (bitset<8>(input.c_str()[i])) );
//    }
//
//    return msg_bin;
//
//}

void padding_and_parsing (string input){


    int l = message_length(input);
    int k = calculate_zero(l);
    vector<int> zeros (k,0);
    // boost::dynamic_bitset<> test1;
    // bitset<1> one(1);
    vector<int> one (1,1);
    vector<int> d2b;

    // int zero = array_to_int(zeroes);
    vector<int> l_binary = decimal_to_binary(l);
    vector<int> char_binary;
    for (int i  = 0; i <input.length() ; i++) {
     d2b = decimal_to_binary((int)input.at(i)) ;
        char_binary.insert(char_binary.end()  ,d2b.begin(), d2b.end());
    }

    vector<int> block;
    block.insert(block.end(), char_binary.begin(),char_binary.end());
    block.insert(block.end(),one.begin(), one.end());
    block.insert(block.end(), zeros.begin(),zeros.end());
    block.insert(block.end(), l_binary.begin(),l_binary.end());

//    vector <int> :: iterator j = block.begin();
//    for (vector<char>::const_iterator j ; j != block.end(); ++j) {
//        cout << *j << ' ';
//    }

    for (auto i = block.begin(); i != block.end(); ++i)
         cout << *i << ' ';

//    for(int j=block.begin(); j!= block.end(); ++j)
//        cout<< *j << '\t';


//    bitset message_binary = string_to_binary(input);
//    bitset temp = cat(message_binary , one);
//    bitset temp2 = cat(temp , zeros);
//    bitset out = cat(temp2 , l_binary);
}

int main() {
    string input = "abc";
    padding_and_parsing(input);
    return 0;
}


//bitset convert(int x) {
//    bitset ret;
//    while(x) {
//        if (x&1)
//            ret.push_back(1);
//        else
//            ret.push_back(0);
//        x>>=1;
//    }
//    reverse(ret.begin(),ret.end());
//    return ret;
//}




