#include "utils/intcode.hh"

void next_line(IntCode& ic, int y, int& begin, int& end) {
    do {
        ic.start(begin, y);
    } while (!ic.get_output() && ++begin);

    end = max(end, begin);
    do {
        ic.start(end, y);
    } while (ic.get_output() && ++end);
}

int part_1(IntCode& ic, int limit) {
    int begin = 0, end = 0;
    int res = 2;  // Isolated points

    for (int y = 7; y < limit; y++) {
        next_line(ic, y, begin, end);
        res += end - begin;
    }

    return res;
}

int part_2(IntCode& ic, int square_size) {
    int begin = 0, end = 0;
    vector<int> bv, ev;
    int y_min = 7;  // magic number
    int y = 0;
    for (;; y++) {
        next_line(ic, y + y_min, begin, end);
        bv.push_back(begin);
        ev.push_back(end);

        if ((y >= square_size) && (ev[y - square_size + 1] - bv[y] >= square_size)) {
            return 10000 * bv[y] + y - square_size + y_min + 1;
        }
    }
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        throw invalid_argument("Must supply filename !");
    }
    string filename = argv[1];

    IntCode ic(filename);

    cout << "Part 1 : " << part_1(ic, 50) << endl;
    cout << "Part 2 : " << part_2(ic, 100) << endl;

    return 0;
}