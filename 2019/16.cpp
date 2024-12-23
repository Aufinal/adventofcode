#include <iostream>

#include "utils/misc.hh"

inline int sign(int i, int n) {
    int k = (i % (4 * n)) / n;
    return (2 - k) * (k % 2);
}

void fft(vector<int>& input) {
    for (uint n = 1; n <= input.size(); n++) {
        int res = 0;

        for (uint i = n; i <= input.size(); i++) {
            res += input[i - 1] * sign(i, n);
        }
        input[n - 1] = abs(res % 10);
    }
}

int prefix(vector<int> v, uint n) {
    int res = 0;
    for (uint i = 0; i < n; i++) {
        res = 10 * res + v[i];
    }

    return res;
}

void cumsum(vector<int>& input, uint n_iter) {
    for (uint i = 0; i < n_iter; i++) {
        for (int j = input.size() - 1; j >= 0; j--) {
            input[j] += input[j + 1];
            input[j] %= 10;
        }
    }
}

int part_1(vector<int> input, uint n_iter) {
    for (uint i = 0; i < n_iter; i++) {
        fft(input);
    }

    return prefix(input, 8);
}

int part_2(vector<int> input, uint n_iter) {
    uint offset = prefix(input, 7);
    vector<int> trunc(input.size() * 10000 - offset, 0);
    for (uint i = 0; i < trunc.size(); i++) {
        trunc[i] = input[(offset + i) % input.size()];
    }

    cumsum(trunc, n_iter);

    return prefix(trunc, 8);
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        throw invalid_argument("Must supply filename !");
    }
    string filename = argv[1];

    auto input = parseint(filename);

    cout << "Part 1 : " << part_1(input, 100) << endl;

    cout << "Part 2 : " << part_2(input, 100) << endl;

    return 0;
}