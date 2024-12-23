#pragma once
#include <fstream>
#include <iterator>
#include <vector>

using namespace std;

namespace std {

// Hashing function for generic pairs
template <class T, class U>
struct hash<pair<T, U>> {
    size_t operator()(pair<T, U> const &p) const noexcept {
        size_t h1 = hash<T>{}(p.first);
        size_t h2 = hash<U>{}(p.second);
        return h1 ^ (h2 << 1);
    }
};

// Boost hash::combine function for hashing vectors
template <>
struct hash<vector<int>> {
    size_t operator()(vector<int> const &vec) const noexcept {
        size_t seed = vec.size();
        for (auto &i : vec) {
            seed ^= i + 0x9e3779b9 + (seed << 6) + (seed >> 2);
        }
        return seed;
    }
};
}  // namespace std

// Computes the sign of x - y
template <typename T>
int sgn(T x, T y = T(0)) {
    return (y < x) - (x < y);
}

vector<string> split(const string &str, const string &delim = ",") {
    vector<string> tokens;
    size_t prev = 0, pos = 0;

    do {
        pos = str.find(delim, prev);
        tokens.push_back(str.substr(prev, pos - prev));
        prev = pos + delim.length();
    } while (pos != string::npos);

    return tokens;
}

string replace(string str, const string &from, const string &to) {
    size_t start_pos = 0;

    while ((start_pos = str.find(from, start_pos)) != string::npos) {
        str.replace(start_pos, from.length(), to);
        start_pos += to.length();
    }
    return str;
}

// Parses string into sequence of ints
vector<int> parseint(string filename) {
    ifstream file(filename);
    string line;

    if (file.is_open()) {
        getline(file, line);
        file.close();
    }

    vector<int> res;
    for (auto c : line) res.push_back(c - '0');

    return res;
}

// Printing vectors as [a, b, c]
template <class T>
ostream &operator<<(ostream &os, const vector<T> &c) {
    os << '[';
    if (!c.empty()) {
        copy(c.begin(), --c.end(), ostream_iterator<T>(os, ","));
        cout << c.back();
    }
    os << ']';
    return os;
}
