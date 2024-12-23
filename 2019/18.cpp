#include <algorithm>
#include <cctype>
#include <climits>
#include <map>
#include <queue>
#include <stack>
#include <unordered_map>

#include "utils/matrix.hh"
#include "utils/misc.hh"

using namespace std;

void explore(Matrix m, int& n_keys, vector<vector<int>>& distances,
             vector<int>& needed_keys, vector<int>& start) {
    vector<Coord> start_pos(26);

    for (int i = 0; i < m.size_x; i++) {
        for (int j = 0; j < m.size_y; j++) {
            if (m(i, j) == '@')
                start_pos.push_back(Coord(i, j));
            else if (islower(m(i, j))) {
                start_pos[m(i, j) - 'a'] = Coord(i, j);
                n_keys++;
            }
        }
    }

    int n_pos = start_pos.size();

    for (int i = 0; i < n_pos; i++) {
        distances.emplace_back(n_pos);
    }

    int index = -1;
    for (auto sp : start_pos) {
        index++;
        if (sp == Coord(0, 0)) continue;

        auto bfs = queue<pair<Coord, int>>();
        auto dist = unordered_map<Coord, int>();
        dist[sp] = 0;
        bfs.push(make_pair(sp, 0));

        while (!bfs.empty()) {
            auto [pos, keys] = bfs.front();
            char c = m[pos];
            bfs.pop();
            auto d = dist[pos];

            if (islower(c)) {
                if (index >= 26) {
                    needed_keys[c - 'a'] = keys;
                    start[c - 'a'] = index - 26;
                }

                distances[index][c - 'a'] = d;
            }
            if (isupper(c)) keys |= 1 << (c - 'A');

            for (auto dir : directions) {
                auto new_pos = pos + dir;
                if (m[new_pos] == '#') continue;

                if (!dist.count(new_pos)) {
                    dist[new_pos] = d + 1;
                    bfs.push(make_pair(new_pos, keys));
                }
            }
        }  // end BFS
    }
}

vector<int> available_moves(int n_keys, vector<int>& needed_keys, int keys) {
    vector<int> res;
    for (int key = 0; key < n_keys; key++) {
        if (!(needed_keys[key] & ~keys) && !(keys & (1 << key))) res.push_back(key);
    }

    return res;
}

using Triple = pair<int, pair<vector<int>, int>>;

int solve(Matrix& m) {
    int n_keys = 0;
    vector<int> needed_keys(26);
    vector<vector<int>> distances;
    vector<int> start(26);

    explore(m, n_keys, distances, needed_keys, start);

    priority_queue<Triple, vector<Triple>, greater<Triple>> dijkstra;
    unordered_map<pair<vector<int>, int>, int> dist;
    vector<int> start_pos;
    for (uint i = 26; i < distances.size(); i++) {
        start_pos.push_back(i);
    }
    dijkstra.push(make_pair(0, make_pair(start_pos, 0)));

    while (!dijkstra.empty()) {
        auto [d, val] = dijkstra.top();
        auto [pos, keys] = val;
        dijkstra.pop();

        if (keys == (1 << n_keys) - 1) return d;

        for (auto key : available_moves(n_keys, needed_keys, keys)) {
            vector<int> new_pos(pos);

            int new_keys = keys | (1 << key);
            int r_index = start[key];

            int new_dist = d + distances[pos[r_index]][key];
            new_pos[r_index] = key;

            auto new_pair = make_pair(new_pos, new_keys);
            auto new_triple = make_pair(new_dist, new_pair);

            if ((!dist.count(new_pair)) || (new_dist < dist[new_pair])) {
                dist[new_pair] = new_dist;
                dijkstra.push(new_triple);
            }
        }
    }

    return -1;
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        throw invalid_argument("Must supply filename !");
    }
    string filename = argv[1];
    Matrix m(filename);

    cout << "Result : " << solve(m) << endl;

    return 0;
}