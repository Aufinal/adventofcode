#include "utils/intcode.hh"

int part_1(IntCode &ic) {
    ic.start();
    int res = 0;
    while (ic.has_output()) {
        auto out = ic.get_outputs(3);
        res += (out[2] == 2);
    }

    return res;
}

int part_2(IntCode &ic) {
    ic.program[0] = 2;
    ic.init();
    int paddle, ball, score;

    while (ic.state != done) {
        ic.run();
        while (ic.has_output()) {
            auto out = ic.get_outputs(3);
            if (out[2] == 3) paddle = out[0];
            if (out[2] == 4) ball = out[0];
            if (out[0] == -1) score = out[2];
        }
        ic.add_input(sgn(ball, paddle));
    }

    return score;
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