#include <iostream>
#include <numeric>
#include <tuple>

#include "utils/misc.hh"

tuple<vector<int>, vector<int>, vector<int>> parse(string filename) {
    ifstream file(filename);
    string line;

    vector<int> pos_x, pos_y, pos_z;
    int x, y, z;
    if (file.is_open()) {
        while (getline(file, line)) {
            sscanf(line.c_str(), "<x=%d, y=%d, z=%d>", &x, &y, &z);
            pos_x.push_back(x);
            pos_y.push_back(y);
            pos_z.push_back(z);
        }
        file.close();
    }

    return make_tuple(pos_x, pos_y, pos_z);
}

void update(vector<int> &pos, vector<int> &vel, int n_iter = 1) {
    while (n_iter--) {
        int idx = 0;
        for (auto &v : vel) {
            for (auto x : pos) {
                v += sgn(x, pos[idx]);
            }
            idx += 1;
        }

        idx = 0;
        for (auto &x : pos) {
            x += vel[idx++];
        }
    }
}

int part_1(vector<int> pos_x, vector<int> pos_y, vector<int> pos_z) {
    vector<int> vel_x(4, 0), vel_y(4, 0), vel_z(4, 0);
    update(pos_x, vel_x, 1000);
    update(pos_y, vel_y, 1000);
    update(pos_z, vel_z, 1000);

    int res = 0;
    for (int i = 0; i < 4; i++) {
        int pot = abs(pos_x[i]) + abs(pos_y[i]) + abs(pos_z[i]);
        int kin = abs(vel_x[i]) + abs(vel_y[i]) + abs(vel_z[i]);
        res += pot * kin;
    }

    return res;
}

int find_cycle(vector<int> &pos) {
    vector<int> vel(4, 0), zero(4, 0), pos_copy(pos);
    int iter = 0;

    do {
        update(pos, vel);
        iter += 1;
    } while (pos != pos_copy || vel != zero);

    return iter;
}

long part_2(vector<int> pos_x, vector<int> pos_y, vector<int> pos_z) {
    long cx = find_cycle(pos_x);
    long cy = find_cycle(pos_y);
    long cz = find_cycle(pos_z);

    return lcm(lcm(cx, cy), cz);
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        throw invalid_argument("Must supply filename !");
    }
    string filename = argv[1];

    auto [pos_x, pos_y, pos_z] = parse(filename);

    cout << "Part 1 : " << part_1(pos_x, pos_y, pos_z) << endl;
    cout << "Part 2 : " << part_2(pos_x, pos_y, pos_z) << endl;

    return 0;
}