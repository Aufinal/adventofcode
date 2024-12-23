#include <stack>

#include "utils/coords.hh"
#include "utils/intcode.hh"

using Plane = unordered_map<Coord, int>;

inline int inv_dir(int i) { return i + 1 - 2 * (i % 2); }

void explore(IntCode &ic) {
    Plane map;
    Coord pos(0, 0);
    Coord oxygen;

    // We start on a valid tile
    int out = 1;
    stack<int> exploration;

    ic.init();

    do {
        if (map.count(pos)) {
            // Returning/staying on a known tile : use stack to determine next move
            auto i = exploration.top();
            exploration.pop();
            auto dir = directions[i];
            ic.add_input(i + 1);
            ic.run();
            out = ic.get_output();

            if (out) {
                // Nonzero output: we move !
                pos += dir;
                if (map.count(pos)) {
                } else {
                    exploration.push(inv_dir(i));
                }
            } else {
                // We remember that there's a wall there
                map[pos + dir] = 0;
            }
        } else {
            // New tile, we need to explore the surroundings
            map[pos] = out;
            if (out == 2) {
                oxygen = pos;
            }

            for (int i = 0; i < 4; i++) {
                auto dir = directions[i];

                // If neighbour already explored : skip
                if (!map.count(pos + dir)) {
                    exploration.push(i);
                }
            }
        }
    } while (!exploration.empty());

    // Now, we have explored everything : classic DFS
    Plane distances;
    distances[oxygen] = 0;
    queue<Coord> bfs;
    int max_distance = 0;
    bfs.push(oxygen);

    while (!bfs.empty()) {
        auto pos = bfs.front();
        bfs.pop();
        auto d = distances[pos];

        for (auto dir : directions) {
            if (map[pos + dir] && !distances.count(pos + dir)) {
                distances[pos + dir] = d + 1;
                bfs.push(pos + dir);
                max_distance = max(max_distance, d + 1);
            }
        }
    }

    cout << "Part 1 : " << distances[Coord(0, 0)] << endl;
    cout << "Part 2 : " << max_distance << endl;
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        throw invalid_argument("Must supply filename !");
    }
    string filename = argv[1];

    IntCode ic(filename);
    explore(ic);

    return 0;
}