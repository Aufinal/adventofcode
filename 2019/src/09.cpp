#include "utils/intcode.hh"

int main(int argc, char *argv[]) {
    if (argc < 2) {
        throw invalid_argument("Must supply filename !");
    }
    string filename = argv[1];

    IntCode ic(filename);

    ic.start(1);
    cout << "Part 1 : " << ic.get_output() << endl;

    ic.start(2);
    cout << "Part 2 : " << ic.get_output() << endl;

    return 0;
}