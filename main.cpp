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
#include <math.h>

using namespace std;

string M_512[100] = {"0"};
string M_32[100] = {"0"};
string W[64] = {"0"};

string A, B, C, D, E, F, G, H;
string H0[100];
string H1[100];
string H2[100];
string H3[100];
string H4[100];
string H5[100];
string H6[100];
string H7[100];

string K[64] = {
        "428a2f98", "71374491", "b5c0fbcf", "e9b5dba5", "3956c25b", "59f111f1", "923f82a4", "ab1c5ed5",
        "d807aa98", "12835b01", "243185be", "550c7dc3", "72be5d74", "80deb1fe", "9bdc06a7", "c19bf174",
        "e49b69c1", "efbe4786", "0fc19dc6", "240ca1cc", "2de92c6f", "4a7484aa", "5cb0a9dc", "76f988da",
        "983e5152", "a831c66d", "b00327c8", "bf597fc7", "c6e00bf3", "d5a79147", "06ca6351", "14292967",
        "27b70a85", "2e1b2138", "4d2c6dfc", "53380d13", "650a7354", "766a0abb", "81c2c92e", "92722c85",
        "a2bfe8a1", "a81a664b", "c24b8b70", "c76c51a3", "d192e819", "d6990624", "f40e3585", "106aa070",
        "19a4c116", "1e376c08", "2748774c", "34b0bcb5", "391c0cb3", "4ed8aa4a", "5b9cca4f", "682e6ff3",
        "748f82ee", "78a5636f", "84c87814", "8cc70208", "90befffa", "a4506ceb", "bef9a3f7", "c67178f2"
};


int calculate_expand(const string &input) {
    int m = (int) input.length() * 8;
    int l = m % 512;
    if (l <= 448)
        return 448 - l;
    else
        return 448 + 512 - l;

}

string decimal_to_binary(int decimal) {
    std::string binary = std::bitset<8>(decimal).to_string();
    return binary;
}

char binary_to_decimal(string binary) {
    std::bitset<4> bs = std::bitset<4>(binary);
    auto decimal = bs.to_ulong();
    char res;
    if (decimal < 10) {
        res = (char)('0' + decimal);
    } else {
        res = (char)('a' + (decimal - 10));
    }
    return res;
}

string bin2hex(string input) {
    string result;
    for (unsigned long i = 0; i < input.length() / 4; i++) {
        result += binary_to_decimal(input.substr(i*4, (i+1)*4));
    }
    return result;
}
string hex2bin(string input) {
    string result;
    for (auto c : input) {
        int decimal;
        if (c >= '0' && c <= '9') {
            decimal = c - '0';
        } else {
            decimal = c - 'a' + 10;
        }
        result += decimal_to_binary(decimal).substr(4, 8);
    }
    return result;
}

string msg_length_decimal_to_binary(const string &input) {
    int decimal = (int) input.length() * 8;
    std::string binary = std::bitset<64>(decimal).to_string();
    return binary;
}

string padding(string input) {
    //msg to binary
    string char_binary;
    for (char i : input) {
        string d2b = decimal_to_binary((int) i);
        char_binary += d2b;
    }

    //msg length
    if (calculate_expand(input) > 0)
        char_binary += '1';
    for (int i = 0; i < calculate_expand(input) - 1; i++)
        char_binary += '0';


    string l_binary = msg_length_decimal_to_binary(input);
    char_binary += l_binary;

    //test
    // cout <<char_binary << ' ';
    return char_binary;
}

//parsing to 512 blocks
int parsing(const string &input) {
    int i = 0;
    for (unsigned long index = 0; index < input.length(); index += 512) {
        // cout << input.substr(index, 512) << endl;
        M_512[i] = input.substr(index, 512);
        i++;
    }
    return i;

}

string left_rotate(string s, int d) {
    s = hex2bin(s);
    reverse(s.begin(), s.begin() + d);
    reverse(s.begin() + d, s.end());
    reverse(s.begin(), s.end());
    s = bin2hex(s);
    return s;
}

// In-place rotates s towards right by d
string right_rotate(string s, int d) {
    s = hex2bin(s);
    auto theD = (int) s.length() - d;
    s = bin2hex(s);
    left_rotate(s, theD);
    return s;
}


string right_shift(string s, int d) {
    s = hex2bin(s);
    for (int i = d; i >= 0; i--) {
        s = '0' + s.substr(0, s.length() - 1);
    }
    s = bin2hex(s);
    return s;
}

string sum_32_bit(string str1, string str2) {
    string sum_str;
    int sum[32] = {0};
    int size1 = str1.length(), size2 = str2.length();

    char arr1[32] = {'0'}, arr2[32] = {'0'}, output[32];
    int int_arr1[32] = {0}, int_arr2[32] = {0};
    //turn string to char array
    reverse(str1.begin(), str1.end());
    reverse(str2.begin(), str2.end());
    strcpy(arr1, str1.c_str());
    strcpy(arr2, str2.c_str());
    for (int i = 0; i < 32; i++) {
        //char array to int array
        int_arr1[i] = arr1[i] - '0';
        int_arr2[i] = arr2[i] - '0';
        if (int_arr1[i] == (-48)) {
            int_arr1[i] = 0;
        }
        if (int_arr2[i] == (-48)) {
            int_arr2[i] = 0;
        }
    }
    // binary add (each digit)
    for (int j = 0; j < 32; j++) {
        sum[j] += int_arr1[j] + int_arr2[j];
        if (sum[j] >= 2) {
            sum[j] = 0;
            sum[j + 1] = 1;
        }
    }
    //int to char array
    for (int k = 0; k < 32; ++k) {
        output[k] = static_cast<char>(sum[k] + '0');
    }
    //char array to string
    string str(output);
    sum_str = str.substr(0, 32);
    reverse(sum_str.begin(), sum_str.end());
    //cout<< sum_str<<endl;

    return sum_str;
}


string sigma(string x, int num) {
    string output;
    if (num == 0) {
        string temp1 = sum_32_bit(right_rotate(x, 17), right_rotate(x, 14));
        output = sum_32_bit(temp1, right_shift(x, 12));
    } else if (num == 1) {
        string temp1 = sum_32_bit(right_rotate(x, 9), right_rotate(x, 19));
        output = sum_32_bit(temp1, right_shift(x, 9));

    }
    return output;
}

void expansion(const string input) {
    int i = 0;
    // create 16 blocks(32 bits) from 512 bit
    for (unsigned long k = 0; k < 16; k += 32) {
        M_32[i] = input.substr(k, 32);
        i++;
    }
    // create W
    for (int p = 0; p < 16; p++) {
        W[p] = M_32[p];
    }
    for (int q = 16; q < 63; q++) {
        W[q] = sum_32_bit(sum_32_bit(sigma(W[q - 1], 1), W[q - 6]), sum_32_bit(sigma(W[q - 12], 0), W[q - 15]));
    }

    //permutation
//    string temp_arr[64] = {"0"};
//
//    for (int n = 0; n < 64; n++) {
//        reverse(W[n].begin(), W[n].end());
//        temp_arr[64 - n] = W[n];
//    }
}


void init() {
    A = "6a09e667";
    B = "bb67ae85";
    C = "3c6ef372";
    D = "a54ff53a";
    E = "510e527f";
    F = "9b05688c";
    G = "1f83d9ab";
    H = "5be0cd19";

    H0[0] = A;
    H1[0] = B;
    H2[0] = C;
    H3[0] = D;
    H4[0] = E;
    H5[0] = F;
    H6[0] = G;
    H7[0] = H;


}

string my_xor(string a, string b) {
    string final_key;
    for (int i = 0; i < a.length(); i++) {
        final_key[i] = ((a[i] - '0') ^ (b[i] - '0')) + '0';
    }
    return final_key;
}

string my_and(string a, string b) {
    string final_key;
    for (int i = 0; i < a.length(); i++) {
        final_key[i] = (a[i] & b[i]);
    }
    return final_key;
}

string my_not(string a) {
    string final_key;
    for (int i = 0; i < a.length(); i++) {
        final_key[i] = not a[i];
    }
    return final_key;
}


string ch(string x, string y, string z) {
    string a = my_and(x, y);
    string b = my_and(x, my_not(y));
    string c = my_and(my_not(x), y);
    a = my_xor(a, b);
    return my_xor(a, c);
}

string maj(string x, string y, string z) {
    string a = my_and(x, y);
    string b = my_and(x, y);
    string c = my_and(x, y);
    a = my_xor(a, b);
    return my_xor(a, c);
}

string SIGMA0(const string &x) {
    string a = right_rotate(x, 2);
    string b = right_rotate(x, 13);
    string c = right_rotate(x, 22);
    string d = right_shift(x, 7);
    a = my_xor(a, b);
    a = my_xor(a, c);
    return my_xor(a, d);
}

string SIGMA1(string x) {
    string a = right_rotate(x, 6);
    string b = right_rotate(x, 11);
    string c = right_rotate(x, 25);
    a = my_xor(a, b);
    return my_xor(a, c);
}

string SIGMA2(string x) {
    string a = right_rotate(x, 2);
    string b = right_rotate(x, 3);
    string c = right_rotate(x, 15);
    string d = right_shift(x, 5);
    a = my_xor(a, b);
    a = my_xor(a, c);
    return my_xor(a, d);
}

string multiply(string s, int d) {
    string final_key;
    for (int i = 0; i < s.length(); i++) {
        final_key[i] = d * s[i];
    }
    return final_key;

}

string add(string a, string b) {
    string final_key;
    for (int i = 0; i < a.length(); i++) {
        final_key[i] = a[i] + b[i];
    }
    return final_key;

}

string subtract(string a, string b) {
    string final_key;
    for (int i = 0; i < a.length(); i++) {
        final_key[i] = a[i] - b[i];
    }
    return final_key;

}

void myhash(int i) {
    string temp1 = add(H, SIGMA1(E));
    string temp2 = add(temp1, ch(E, F, G));
    string temp3 = add(temp2, K[i]);
    string t2 = add(temp3, W[i]);

    string temp4 = add(SIGMA0(A), maj(A, B, C));
    string t1 = add(temp4, SIGMA2(C + D));
    H = G;
    F = E;
    D = C;
    B = A;
    G = F;
    E = add(D, t1);
    C = B;
    A = subtract(multiply(t1, 3), t2);
}

void concatination(string *h, int N) {
    h[N] = H0[N] + H1[N] + H2[N] + H3[N] + H4[N] + H5[N] + H6[N] + H7[N];
}

void hash_computation(int i, string *res) {


    for (int t = 0; t < 64; t++) {
        myhash(t);
    }

    H0[i] = A + H0[i - 1];
    H1[i] = B + H1[i - 1];
    H2[i] = C + H2[i - 1];
    H3[i] = D + H3[i - 1];
    H4[i] = E + H4[i - 1];
    H5[i] = F + H5[i - 1];
    H6[i] = G + H6[i - 1];
    H7[i] = H + H7[i - 1];
    concatination(res, i);
}


void sha_header(string s, string prevHash, string rootHash) {
    int i;
    //version 02000000: 0000 0010
    for (i = 0; i < 32; i++) {
        s[i] = 0;
    }
    s[6] = 1;
    for (i = 0; i < 256; i++) {
        s[i + 32] = prevHash[i];
    }
    for (i = 0; i < 256; i++) {
        s[i + 288] = rootHash[i];
    }
    //end
    for (i = 0; i < 128; i++) {
        s[i + 544] = 0;
    }
    //timestamp : 00110101100010110000010101010011
    s[544] = static_cast<char>(898303315);
    //difficulty
    s[576] = static_cast<char>(1397813529);

}


string pseudo_SHA256(string input) {
    string hash_values[512];

    input = padding(input);
    int blocks = parsing(input);

    for (int block_number = 0; block_number < blocks; block_number++) {
        expansion(M_512[block_number]);


        //init
        init();
        //hash
        hash_computation(block_number, hash_values);
    }

    return hash_values[0];

}


int main() {
    string input = "abc";
    string p = padding(input);
    cout << p << endl;
    // parsing(p);
    //test of M
/*    for(int i=0 ; i<50 ; i++)
        cout<<M_512[1]<<endl;*/

/*    string r =right_rotate(p, 2);
    cout <<r << endl;
    string sh = right_shift("1100101",5);
    cout << sh;*/

    string header_values;
    string hash_values;

    string target = "0.00000000000002816E0000000000000000000000000000000000000000000000";
    int nonce = 0;
    string hash = "1";
    string block_header_l = header_values;
    char str[100];

    while (hash > target) {

        hash = pseudo_SHA256(
                pseudo_SHA256(str + block_header_l)
        );
        nonce++;
    }
    sha_header(header_values, hash_values, hash);
    cout << "\n" << hash;
    return 0;
}