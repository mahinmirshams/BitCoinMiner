#include <iostream>
#include "stdio.h"
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

int padding_and_parsing (int l){
    int k = calculate_zero(l+1);

    int out = (l + 1 + );
}


int main() {
    cout << "Hello, World!" << std::endl;
    return 0;
}

