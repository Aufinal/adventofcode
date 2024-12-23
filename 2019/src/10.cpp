#include <map>
#include <numeric>
#include <queue>
#include <unordered_set>

#include "utils/matrix.hh"

using AstField = vector<Coord>;

AstField parse(string filename) {
    AstField field;
    Matrix m(filename);

    for (int x = 0; x < m.size_x; x++) {
        for (int y = 0; y < m.size_y; y++) {
            if (m(x, y) == '#') field.push_back(Coord(y, x));
        }
    }

    return field;
}

int can_see(AstField& asteroids, Coord origin) {
    unordered_set<Coord> directions;

    for (auto ast : asteroids) {
        if (ast == origin) continue;
        auto diff = ast - origin;
        int d = gcd(diff.x, diff.y);
        directions.insert(diff / d);
    }

    return directions.size();
}

struct argcomp {
    bool operator()(const Coord& lhs, const Coord& rhs) const {
        return lhs.arg() > rhs.arg();
    }
};

struct abscomp {
    bool operator()(const Coord& lhs, const Coord& rhs) const {
        return lhs.normsq() > rhs.normsq();
    }
};

AstField laser(AstField& asteroids, Coord origin) {
    map<Coord, priority_queue<Coord, AstField, abscomp>, argcomp> order;
    for (auto ast : asteroids) {
        if (ast == origin) continue;
        auto diff = ast - origin;
        int d = gcd(diff.x, diff.y);
        order[diff / d].push(ast - origin);
    }

    AstField res;
    int n_remaining = asteroids.size() - 1;

    while (n_remaining) {
        for (auto& [key, val] : order) {
            if (!val.empty()) {
                res.push_back(val.top() + origin);
                val.pop();
                n_remaining--;
            }
        }
    }

    return res;
}

void part_12(AstField& asteroids) {
    int max = 0;
    Coord argmax;
    for (auto ast : asteroids) {
        auto cs = can_see(asteroids, ast);
        if (cs > max) {
            argmax = ast;
            max = cs;
        }
    }

    cout << "Part 1 : " << max << endl;

    auto res = laser(asteroids, argmax)[199];
    cout << "Part 2 : " << 100 * res.y + res.x << endl;
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        throw invalid_argument("Must supply filename !");
    }
    string filename = argv[1];

    auto asteroids = parse(filename);
    part_12(asteroids);
}