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
int  binary[1024];

int message_length (string input){
    return static_cast<int>(input.length() * 8);
}


int calculate_zero(int m){

    int i = 0;

    while(!(m+1 % 448 == 0)){
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

int* decimal_to_binary(int decimal){
    int i = 0;
    while (decimal>0){
        binary[i] = decimal%2;
       decimal = decimal/2;
        i++;
    }
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

int padding_and_parsing (string input){

    vector <int> :: iterator j;

    int l = message_length(input);
    int k = calculate_zero(l+1);
    int zeros[k]={0};
   // boost::dynamic_bitset<> test1;
   // bitset<1> one(1);

   // int zero = array_to_int(zeroes);
     int l_binary[] = decimal_to_binary(l);
    vector<int> char_binary;
    for (int i  = 0; i <input.length() ; i++) {
     char_binary = decimal_to_binary((int)input.at(i));
    }

    vector<int> block;
    block.insert(block.end(), char_binary.begin(),char_binary.end());
    block.insert(block.end(),one.begin(), one.end());
    block.insert(block.end(), zeros.begin(),zeros.end());
    block.insert(block.end(), l_binary.begin(),l_binary.end());

    for (vector<char>::const_iterator j = block.begin(); j != block.end(); ++j)
        cout << *j << ' ';

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




