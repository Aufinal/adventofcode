#include <cctype>
#include <forward_list>
#include <queue>
#include <unordered_map>
#include <unordered_set>

#include "utils/matrix.hh"
#include "utils/misc.hh"

void parse(Matrix& m, Coord& start_pos, Coord& end_pos,
           unordered_map<Coord, Coord>& portals,
           unordered_map<Coord, vector<pair<Coord, int>>>& distances) {
    unordered_map<string, vector<Coord>> portal_names;
    forward_list<Coord> portal_list;

    for (int x = 1; x < m.size_x - 1; x++) {
        for (int y = 1; y < m.size_y - 1; y++) {
            if (isupper(m(x, y))) {
                Coord pos(x, y);

                for (auto dir : directions) {
                    if (isupper(m[pos - dir]) && m[pos + dir] == '.') {
                        string pname;
                        pname += min(m[pos], m[pos - dir]);
                        pname += max(m[pos], m[pos - dir]);
                        if (pname == "AA")
                            start_pos = pos + dir;
                        else if (pname == "ZZ")
                            end_pos = pos + dir;
                        else
                            portal_names[pname].push_back(pos + dir);

                        portal_list.push_front(pos + dir);
                    }
                }
            }
        }
    }

    for (auto p : portal_list) {
        queue<Coord> dijkstra;
        unordered_map<Coord, int> dist;
        dijkstra.push(p);
        dist[p] = 0;

        while (!dijkstra.empty()) {
            auto pos = dijkstra.front();
            auto d = dist[pos];
            dijkstra.pop();
            for (auto dir : directions) {
                auto new_pos = pos + dir;
                if (m[new_pos] == '#') continue;

                if (isupper(m[new_pos])) {
                    if (pos != start_pos && pos != p) {
                        distances[p].push_back(make_pair(pos, d));
                    }
                    continue;
                }

                if (!dist.count(new_pos)) {
                    dist[new_pos] = d + 1;
                    dijkstra.push(new_pos);
                }
            }
        }
    }

    for (auto [pname, v] : portal_names) {
        portals[v[0]] = v[1];
        portals[v[1]] = v[0];
    }
}

using DistCoord = pair<int, Coord>;

int part_1(Matrix& m) {
    Coord start_pos, end_pos;
    unordered_map<Coord, Coord> portals;
    unordered_map<Coord, vector<pair<Coord, int>>> portal_dist;

    parse(m, start_pos, end_pos, portals, portal_dist);
    priority_queue<DistCoord, vector<DistCoord>, greater<DistCoord>> dijkstra;
    unordered_set<Coord> visited;
    dijkstra.push(make_pair(0, start_pos));
    visited.insert(start_pos);

    while (!dijkstra.empty()) {
        auto [dist, pos] = dijkstra.top();
        dijkstra.pop();

        for (auto [portal, d] : portal_dist[pos]) {
            if (portal == end_pos) return dist + d;

            auto new_pos = portals[portal];

            if (!visited.count(new_pos)) {
                visited.insert(new_pos);
                dijkstra.push(make_pair(dist + d + 1, new_pos));
            }
        }
    }

    return -1;
}

bool is_outer(Coord p, Matrix& m) {
    return p.x == 2 || p.x == m.size_x - 3 || p.y == 2 || p.y == m.size_y - 3;
}

using DistDepCoord = tuple<int, int, Coord>;

int part_2(Matrix& m) {
    Coord start_pos, end_pos;
    unordered_map<Coord, Coord> portals;
    unordered_map<Coord, vector<pair<Coord, int>>> portal_dist;

    parse(m, start_pos, end_pos, portals, portal_dist);
    priority_queue<DistDepCoord, vector<DistDepCoord>, greater<DistDepCoord>> dijkstra;
    unordered_map<pair<int, Coord>, int> distances;
    distances[make_pair(0, start_pos)] = 0;
    dijkstra.push(make_tuple(0, 0, start_pos));

    while (!dijkstra.empty()) {
        auto [dist, depth, pos] = dijkstra.top();
        dijkstra.pop();

        for (auto [portal, d] : portal_dist[pos]) {
            if (!depth) {
                if (portal == end_pos) return dist + d;
                if (is_outer(portal, m)) continue;
            } else {
                if (portal == end_pos) continue;
            }

            auto new_pos = portals[portal];
            int new_depth = depth + (is_outer(portal, m) ? -1 : 1);
            auto new_pair = make_pair(new_depth, new_pos);

            if (!distances.count(new_pair) || distances[new_pair] > dist + d + 1) {
                distances[new_pair] = dist + d + 1;
                dijkstra.push(make_tuple(dist + d + 1, new_depth, new_pos));
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
    cout << part_1(m) << endl;
    cout << part_2(m) << endl;

    return 0;
}