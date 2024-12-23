#pragma once
#include <fstream>
#include <sstream>
#include <vector>

#include "coords.hh"

class Matrix {
    vector<char> data;

    int index(int x, int y) { return y * (size_x + 1) + x; }

   public:
    int size_x;
    int size_y;
    char& operator()(int x, int y) { return data[index(x, y)]; }
    char& operator[](Coord p) { return data[index(p.x, p.y)]; }

    Matrix(vector<long> v) : data(v.begin(), v.end()) {
        size_x = find(v.begin(), v.end(), 10) - v.begin();
        size_y = v.size() / (size_x + 1);
    }

    Matrix(string filename) {
        fstream file(filename);
        std::stringstream buffer;

        if (file.is_open()) {
            buffer << file.rdbuf();
            file.close();
        }
        string s = buffer.str();
        data = vector<char>(s.begin(), s.end());
        size_x = find(data.begin(), data.end(), 10) - data.begin();
        size_y = data.size() / (size_x + 1);
    }

    void print() {
        for (auto elt : data) {
            cout << char(elt);
        }
    }

    bool inbounds(Coord p) {
        return !(p.x < 0 || p.x > size_x || p.y < 0 || p.y > size_y);
    }
};