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


int array_to_string(int arr[])
{


    std::ostringstream os;
    for (int i: arr) {
        os << i;
    }

    std::string str(os.str());
    std::cout << str;

    return 0;
}


int padding_and_parsing (int l){
    int k = calculate_zero(l+1);
    int zeroes [k] = {0};

    array_to_string(zeroes);
    int out = reinterpret_cast<int>(l + 1 + zeroes);
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
    string input = "Hello World";
    bitset output ;

    for (std::size_t i = 0; i < input.size(); ++i)
    {
         output = cat( output, (bitset<8>(input.c_str()[i])) );
    }
    return 0;
}



