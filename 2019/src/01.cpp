#include <fstream>
#include <iostream>
#include <list>
#include <unordered_set>

using namespace std;

list<int> parse_modules(string filename) {
    list<int> modules;
    ifstream file(filename);
    string line;
    if (file.is_open()) {
        while (getline(file, line)) {
            modules.push_back(stoi(line));
        }
    }
    file.close();
    return modules;
}

int part_1(list<int> &modules) {
    int sum = 0;
    for (auto elt : modules) {
        sum += elt / 3 - 2;
    }

    return sum;
}

int part_2(list<int> &modules) {
    int sum = 0;
    for (auto elt : modules) {
        while (elt > 5) {
            elt = elt / 3 - 2;
            sum += elt;
        }
    }
    return sum;
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        throw invalid_argument("Must supply filename !");
    }
    string filename = argv[1];
    auto modules = parse_modules(filename);

    cout << "Part 1 : " << part_1(modules) << endl;
    cout << "Part 2 : " << part_2(modules) << endl;

    return 0;
}