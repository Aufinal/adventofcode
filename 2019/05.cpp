#include "utils/intcode.hh"

int part_1(IntCode &ic) {
    ic.start(1);
    return ic.get_outputs().back();
}

int part_2(IntCode &ic) {
    ic.start(5);
    return ic.get_output();
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        throw invalid_argument("Must supply filename !");
    }
    string filename = argv[1];

    IntCode ic(filename);

    cout << "Part 1 : " << part_1(ic) << endl;
    cout << "Part 2 : " << part_2(ic) << endl;

    return 0;
}