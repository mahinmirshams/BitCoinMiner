#include <iostream>
#include <sstream>
#include "stdio.h"
#include <string>
#include <bitset>
#include <type_traits>
#include <limits>
#include <vector>
#include <algorithm>
#include <cstring>

using namespace std;

string M_512[100] = {"0"};
string M_32[100] = {"0"};
string W[64]= {"0"};



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

string padding (string input){
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
   // cout <<char_binary << ' ';
    return char_binary;
}

//parsing to 512 blocks
int parsing (string input ){
    int i = 0;
    for (int index = 0; index < input.length(); index +=512) {
           // cout << input.substr(index, 512) << endl;
        M_512[i] = input.substr(index, 512);
        i++;
    }
    return  i ;

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



string right_shift(string s, int d){

    for (int i = d; i >= 0; i--) {

        s = '0' + s.substr(0, s.length() - 1);

    }
    return s;
}

string sum_32_bit(string str1 , string str2){
    string sum_str ;
    int sum[32] = {0} ;
    int size1 = str1.length() , size2 =  str2.length();

    char arr1[32] = {'0'}, arr2[32] = {'0'} , output[32];
    int int_arr1[32]={0} , int_arr2[32]={0};
    //turn string to char array
    reverse(str1.begin() , str1.end());
    reverse(str2.begin() , str2.end());
    strcpy(arr1 , str1.c_str());
    strcpy(arr2 , str2.c_str());
    for (int i=0 ; i < 32 ; i++) {
        //char array to int array
        int_arr1[i] = arr1[i] - '0';
        int_arr2[i] = arr2[i] - '0';
        if(int_arr1[i] == (-48) ){
            int_arr1[i] = 0;
        }
        if (int_arr2[i] == (-48)){
            int_arr2[i] = 0;
        }
    }
    // binary add (each digit)
    for(int j = 0 ; j < 32 ; j++){
      sum[j]+=int_arr1[j] + int_arr2[j];
        if(sum[j]>=2){
            sum[j] = 0;
            sum[j+1] = 1;
        }
    }
    //int to char array
    for (int k = 0; k <32 ; ++k) {
        output[k] = static_cast<char>(sum[k] + '0');
    }
    //char array to string
    string str(output);
    sum_str = str.substr(0 , 32);
    reverse(sum_str.begin(),sum_str.end());
    //cout<< sum_str<<endl;

    return sum_str ;
}


string sigma(string x , int num){
    string output;
    if(num == 0){
        string temp1 = sum_32_bit( right_rotate(x , 17) , right_rotate(x , 14));
        output = sum_32_bit( temp1 , right_shift(x , 12));
    }
    else if(num ==1){
        string temp1 = sum_32_bit( right_rotate(x , 9) , right_rotate(x , 19));
        output = sum_32_bit( temp1 , right_shift(x , 9));

    }
    return  output ;
}

void expansion(string input  ){
    int i = 0;
    // create 16 blocks(32 bits) from 512 bit
    for(int k = 0 ; k < 16 ; k+=32 ){
        M_32[i] = input.substr(k, 32);
        i++;
    }
    // create W
    for(int p = 0 ; p < 16 ; p++ ){
       W[p] = M_32[p];
    }
    for(int q = 16 ; q < 63 ; q++ ){
        W[q] = sum_32_bit(sum_32_bit(sigma(W[q-1] ,1) ,W[q-6]) , sum_32_bit(sigma(W[q-12], 0), W[q-15]));
    }

    //permutation
    string temp_arr[64] = {"0"};

    for(int n=0 ; n < 64 ; n++){
        reverse(W[n].begin(), W[n].end());
        temp_arr[64-n] = W[n];
    }

}


int main() {
    string input = "abc";
    string p = padding(input);
    //cout <<p<<endl;
   // parsing(p);
    //test of M
/*    for(int i=0 ; i<50 ; i++)
        cout<<M_512[1]<<endl;*/

/*    string r =right_rotate(p, 2);
    cout <<r << endl;
    string sh = right_shift("1100101",5);
    cout << sh;*/



    return 0;
}