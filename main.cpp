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

string A, B,C,D,E,F,G,H;
string *H0;
string *H1;
string *H2;
string *H3;
string *H4;
string *H5;
string *H6;
string *H7;

uint k[64] = {
        0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
        0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
        0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
        0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
        0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
        0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
        0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
        0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2
};


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

void expansion(string input){
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


void init(){
    A = 0x6a09e667;
    B = 0xbb67ae85;
    C = 0x3c6ef372;
    D = 0xa54ff53a;
    E = 0x510e527f;
    F = 0x9b05688c;
    G = 0x1f83d9ab;
    H = 0x5be0cd19;

    H0[0] = A;
    H1[0] = B;
    H2[0] = C;
    H3[0] = D;
    H4[0] = E;
    H5[0] = F;
    H6[0] = G;
    H7[0] = H;





}

string my_xor (string a , string b){
    string final_key;
    for(int i = 0; i<a.length(); i++) {
        final_key[i] = ((a[i] - '0') ^ (b[i] - '0')) + '0';
    }
    return final_key;
}

string my_and (string a , string b){
    string final_key;
    for(int i = 0; i<a.length(); i++) {
        final_key[i] = (a[i] & b[i]);
    }
    return final_key;
}

string my_not (string a){
    string final_key;
    for(int i = 0; i<a.length(); i++) {
        final_key[i] = not a[i];
    }
    return final_key;
}


string ch(string x, string y, string z){
    string a = my_and (x,y);
    string b = my_and (x,my_not(y);
    string c = my_and (my_not(x),y);
    a = my_xor(a, b);
    return my_xor(a, c);
}

string maj(string x, string y, string z){
    string a =  my_and (x,y);
    string b =  my_and (x,y);
    string c =  my_and (x,y);
    a = my_xor(a, b);
    return my_xor(a, c);
}

string SIGMA0(string x){
    string a = right_rotate(x, 2);
    string b = right_rotate(x, 13);
    string c = right_rotate(x, 22);
    string d = right_shift(x,7);
    a = my_xor(a, b);
    a = my_xor(a, c);
    return my_xor(a, d);
}

string SIGMA1(string x){
    string a = right_rotate(x, 6);
    string b = right_rotate(x, 11);
    string c = right_rotate(x, 25);
    a = my_xor(a, b);
    return my_xor(a, c);
}

string SIGMA2(string x){
    string a = right_rotate(x, 2);
    string b = right_rotate(x, 3);
    string c = right_rotate(x, 15);
    string d = right_shift(x,5);
    a = my_xor(a, b);
    a = my_xor(a, c);
    return my_xor(a, d);
}

string multiply(string s, int d){
    string final_key;
    for(int i = 0; i<s.length(); i++) {
        final_key[i] = d * s[i];
    }
    return final_key;

}
string add(string a, string b){
    string final_key;
    for(int i = 0; i<a.length(); i++) {
        final_key[i] =  a[i] + b[i];
    }
    return final_key;

}

string subtract(string a, string b){
    string final_key;
    for(int i = 0; i<a.length(); i++) {
        final_key[i] =  a[i] - b[i];
    }
    return final_key;

}

void  hash(string w, string k){
    string temp1 =add(H,SIGMA1(E));
    string temp2 =add(temp1,ch(E, F, G));
    string temp3 =add(temp2,k);
    string t2 = add(temp3, w);

    string temp4 =add(SIGMA0(A), maj(A, B, C));
    string t1 = add(temp4,SIGMA2(C+D) );
    H = G;
    F = E;
    D = C;
    B = A;
    G = F;
    E = add(D , t1);
    C = B;
    A = subtract(multiply(t1,3), t2);
}

void concatination(string *h, int N){
    h[N] = H0[N] + H1[N] + H2[N] + H3[N] + H4[N] + H5[N] + H6[N] + H7[N];
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