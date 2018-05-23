#include <iostream>
#include <sstream>
#include "stdio.h"
#include <string>
#include <bitset>
#include <type_traits>
#include <limits>

using namespace std;


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





constexpr std::size_t ULONGLONG_BITS = std::numeric_limits<unsigned long long>::digits ;

/*
template< std::size_t N1, std::size_t N2 >
typename std::enable_if< (N1+N2) <= ULONGLONG_BITS, std::bitset<N1+N2> >::type // efficient for small sizes
cat( const std::bitset<N1>& a, const std::bitset<N2>& b ) { return ( a.to_ullong() << N2 ) + b.to_ullong() ; }
*/

template< std::size_t N1, std::size_t N2 >
typename std::enable_if< ( (N1+N2) > ULONGLONG_BITS ), std::bitset<N1+N2> >::type
cat( const std::bitset<N1>& a, const std::bitset<N2>& b ) { return std::bitset<N1+N2>( a.to_string() + b.to_string() ) ; }



int main() {
    string input = "abc";

    return 0;
}

bitset string_to_binary (string input){

    bitset msg_bin ;

    for (std::size_t i = 0; i < input.size(); ++i)
    {
        msg_bin = cat( msg_bin, (bitset<8>(input.c_str()[i])) );
    }

    return msg_bin;

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


int padding_and_parsing (string input){
    int l = message_length(input);
    int k = calculate_zero(l+1);
    bitset<k> zeros;
    bitset<1> one(1);

    bitset l_binary = bitset<64>(l);

    //int zeroes [k] = {0};

   // int zero = array_to_int(zeroes);

    bitset message_binary = string_to_binary(input);
    bitset temp = cat(message_binary , one);
    bitset temp2 = cat(temp , zeros);
    bitset out = cat(temp2 , l_binary);
}




