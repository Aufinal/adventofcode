#include "utils/intcode.hh"

void run(string filename) {
    vector<IntCode> ics(50, filename);
    int nat_x = 0;
    int nat_y = 0;
    int prev_nat = -1;

    int idx = 0;
    for (auto& ic : ics) {
        ic.init();
        ic.add_input(idx++);
        ic.add_input(-1);
    }

    while (true) {
        int n_idle = 0;
        for (auto& ic : ics) {
            ic.advance();

            if (ic.state == need_input) n_idle++;

            if (ic.has_output(3)) {
                auto v = ic.get_outputs(3);
                if (v[0] == 255) {
                    if (nat_x == 0 && nat_y == 0) {
                        cout << "Part 1 : " << v[2] << endl;
                    }
                    nat_x = v[1];
                    nat_y = v[2];
                } else
                    ics[v[0]].add_input(v[1], v[2]);
            }
        }

        if (n_idle == 50) {
            if (nat_y == prev_nat) {
                cout << "Part 2 : " << nat_y << endl;
                break;
            }
            prev_nat = nat_y;
            ics[0].add_input(nat_x, nat_y);
        }
    }
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        throw invalid_argument("Must supply filename !");
    }
    string filename = argv[1];

    run(filename);

    return 0;
}