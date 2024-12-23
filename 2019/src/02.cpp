#include <algorithm>
#include <iostream>

#include "utils/intcode.hh"

int replace_and_run(IntCode &ic, int a, int b) {
    ic.program[1] = a;
    ic.program[2] = b;
    ic.start();

    return ic.output_mem(0);
}

int part_1(IntCode &ic) { return replace_and_run(ic, 12, 2); }

int part_2(IntCode &ic, int target) {
    for (int i = 0; i < 100; i++) {
        for (int j = 0; j < 100; j++) {
            if (replace_and_run(ic, i, j) == target) {
                return 100 * i + j;
            }
        }
    }

    return -1;
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        throw invalid_argument("Must supply filename !");
    }
    string filename = argv[1];

    IntCode ic(filename);

    cout << "Part 1 : " << part_1(ic) << endl;
    cout << "Part 2 : " << part_2(ic, 19690720) << endl;

    return 0;
}