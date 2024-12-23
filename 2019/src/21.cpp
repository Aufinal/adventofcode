#include "utils/intcode.hh"
#include "utils/matrix.hh"

int launch(IntCode& ic, list<string> prog, int part) {
    string launch_command = (part == 1) ? "WALK" : "RUN";
    prog.push_back(launch_command);

    ic.init();
    ic.input_strlist(prog);
    ic.run();

    auto v = ic.get_outputs();
    if (v.back() < 256) {
        Matrix(v).print();
    }
    return v.back();
}

int part_1(IntCode& ic) {
    list<string> prog = {"NOT A J", "NOT C T", "AND D T", "OR T J"};

    return launch(ic, prog, 1);
}

int part_2(IntCode& ic) {
    list<string> prog = {"NOT B J", "NOT C T", "OR T J", "AND D J",
                         "AND H J", "NOT A T", "OR T J"};

    return launch(ic, prog, 2);
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        throw invalid_argument("Must supply filename !");
    }
    string filename = argv[1];

    IntCode ic(filename);

    cout << "Part 1 : " << part_1(ic) << endl;
    cout << "Part 2 : " << part_2(ic) << endl;

    return 0;
}