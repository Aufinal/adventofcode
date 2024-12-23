#include <iostream>
#include <unordered_map>

#include "utils/misc.hh"

// oriented tree by parent/list of children
typedef unordered_map<string, string> PTree;
typedef unordered_map<string, vector<string>> CTree;

tuple<PTree, CTree> parse(string filename) {
    CTree children;
    PTree parent;
    ifstream file(filename);
    string line;
    if (file.is_open()) {
        while (getline(file, line)) {
            auto v = split(line, ")");
            children[v[0]].push_back(v[1]);
            parent[v[1]] = v[0];
        }

        file.close();
    }

    return make_tuple(parent, children);
}

int sum_orbits(CTree &tree, string node, int cur_sum) {
    int res = cur_sum;
    if (!tree.count(node)) {
        return res;
    }
    for (auto child : tree[node]) {
        res += sum_orbits(tree, child, cur_sum + 1);
    }

    return res;
}

vector<string> path_to_root(PTree &tree, string node) {
    vector<string> res;
    while (tree.count(node)) {
        node = tree[node];
        res.push_back(node);
    }

    return res;
}

int part_1(CTree &tree) { return sum_orbits(tree, "COM", 0); }
int part_2(PTree &tree, string a, string b) {
    auto path_a = path_to_root(tree, a);
    auto path_b = path_to_root(tree, b);
    auto s = path_a.size();
    auto t = path_b.size();
    auto c = 0;
    while (path_a[s - c - 1] == path_b[t - c - 1]) c++;
    return s + t - 2 * c;
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        throw invalid_argument("Must supply filename !");
    }
    string filename = argv[1];

    auto [ptree, ctree] = parse(filename);
    cout << "Part 1 : " << part_1(ctree) << endl;
    cout << "Part 2 : " << part_2(ptree, "YOU", "SAN") << endl;

    return 0;
}