#include "utils/intcode.hh"

int chain(vector<IntCode> &ics, vector<int> inputs) {
    int out = 0;
    int idx = 0;

    for (auto &ic : ics) {
        ic.start(inputs[idx++], out);
        out = ic.get_output();
    }

    return out;
}

int chain_rec(vector<IntCode> &ics, vector<int> inputs) {
    int out = 0;
    int idx = 0;

    for (auto &ic : ics) {
        ic.init();
        ic.add_input(inputs[idx++]);
    }

    idx = 0;
    while (ics[idx].state != done) {
        ics[idx].add_input(out);
        ics[idx].run();
        out = ics[idx].get_output();
        idx = (idx + 1) % 5;
    }

    return out;
}

int part_1(vector<IntCode> &ics) {
    vector<int> inputs = {0, 1, 2, 3, 4};
    int max_out = 0;

    do {
        max_out = max(max_out, chain(ics, inputs));
    } while (next_permutation(inputs.begin(), inputs.end()));

    return max_out;
}

int part_2(vector<IntCode> &ics) {
    vector<int> inputs = {5, 6, 7, 8, 9};
    int max_out = 0;

    do {
        max_out = max(max_out, chain_rec(ics, inputs));
    } while (next_permutation(inputs.begin(), inputs.end()));

    return max_out;
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        throw invalid_argument("Must supply filename !");
    }
    string filename = argv[1];
    vector<IntCode> ics(5, filename);

    cout << "Part 1 : " << part_1(ics) << endl;
    cout << "Part 2 : " << part_2(ics) << endl;

    return 0;
}