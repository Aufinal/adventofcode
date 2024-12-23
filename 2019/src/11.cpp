#include "utils/coords.hh"
#include "utils/intcode.hh"

using Hull = unordered_map<Coord, int>;

Hull paint(IntCode &ic, int start) {
    Coord pos(0, 0);
    Coord dir(0, 1);
    const Coord im(0, 1);
    Hull hull;
    ic.init();
    hull[pos] = start;

    while (ic.state != done) {
        ic.add_input(hull[pos]);
        ic.run();
        auto out = ic.get_outputs(2);
        hull[pos] = out[0];
        dir *= int(1 - 2 * out[1]) * im;
        pos += dir;
    }

    return hull;
}

int part_1(IntCode &ic) {
    auto board = paint(ic, 0);
    return board.size();
}

void part_2(IntCode &ic) {
    int min_x = 0, min_y = 0, max_x = 0, max_y = 0;
    auto board = paint(ic, 1);

    for (auto [key, val] : board) {
        min_x = min(min_x, key.x);
        max_x = max(max_x, key.x);
        min_y = min(min_y, key.y);
        max_y = max(max_y, key.y);
    }

    for (int i = max_y; i >= min_y; i--) {
        for (int j = min_x; j <= max_x; j++) {
            cout << (board[Coord(j, i)] ? "  " : "\u2588\u2588");
        }
        cout << endl;
    }
}

int main(int argc, char *argv[]) {
    if (argc < 2) {
        throw invalid_argument("Must supply filename !");
    }
    string filename = argv[1];

    IntCode ic(filename);

    cout << "Part 1 : " << part_1(ic) << endl << endl;
    part_2(ic);

    return 0;
}