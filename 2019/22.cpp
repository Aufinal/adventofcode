#include <iostream>

#include "utils/misc.hh"

using ll = long long;
using ull = unsigned long long;

ll mulmod(ll a, ll b, ll m) {
    ll res = 0;

    while (b > 0) {
        if (b & 1) res = (res + a) % m;

        b = b >> 1;
        a = (a + a) % m;
    }

    return res;
}

ll powmod(ll a, ull b, ll m) {
    ll res = 1LL;

    while (b > 0) {
        if (b & 1) res = mulmod(res, a, m);

        b = b >> 1;
        a = mulmod(a, a, m);
    }

    return res;
}

void shuffle_once(string instr, ll& n, ll n_cards) {
    auto v = split(instr, " ");
    if (v.back() == "stack") {
        n = n_cards - n - 1;
    } else if (v.front() == "deal") {
        auto inc = stoll(v.back());
        n = mulmod(n, inc, n_cards);
    } else {
        auto cut = stoi(v.back());
        n = (n - cut + n_cards) % n_cards;
    }
}

ll shuffle(string filename, ll card, ll n_cards) {
    ifstream file(filename);
    string line;
    if (file.is_open()) {
        while (getline(file, line)) {
            shuffle_once(line, card, n_cards);
        }
    }

    return card;
}

ll part_2(string filename, ll card, ll n_cards, ll n_repeats) {
    // The transformation is necessarily of the form ax + b % n_cards
    ll zero = shuffle(filename, 0LL, n_cards);  // b
    ll one = shuffle(filename, 1LL, n_cards);   // a + b
    ll a = (one - zero + n_cards) % n_cards;

    // Inverse iteration : x -> (x - b) / a
    ll inva = powmod(a, n_cards - 2, n_cards);

    // Fixed point of both iterations : f = b / (1 - a)
    ll inv_1ma = powmod(1 - a + n_cards, n_cards - 2, n_cards);
    ll fixed_point = mulmod(zero, inv_1ma, n_cards);

    // n-th iterate is a^n(x - f) + f
    ll translated = (card - fixed_point + n_cards) % n_cards;
    ll res = mulmod(powmod(inva, n_repeats, n_cards), translated, n_cards);
    res = (res + fixed_point) % n_cards;

    return res;
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        throw invalid_argument("Must supply filename !");
    }
    string filename = argv[1];

    cout << "Part 1 : " << shuffle(filename, 2019, 10007) << endl;
    cout << "Part 2 : "
         << part_2(filename, 2020LL, 119315717514047LL, 101741582076661LL) << endl;

    return 0;
}