#include <algorithm>
#include <list>

#include "utils/intcode.hh"
#include "utils/matrix.hh"

int part_1(Matrix& m) {
    int res = 0;
    for (int x = 1; x < m.size_x - 1; x++) {
        for (int y = 1; y < m.size_y - 1; y++) {
            if (m(x, y) != 46 && m(x + 1, y) != 46 && m(x - 1, y) != 46 &&
                m(x, y + 1) != 46 && m(x, y - 1) != 46) {
                res += x * y;
            }
        }
    }

    return res;
}

string find_path(Matrix& m) {
    Coord pos;
    Coord dir(0, -1);
    Coord im(0, 1);
    string res = "";

    for (int i = 0; i < m.size_y; i++) {
        for (int j = 0; j < m.size_x; j++) {
            if (m(j, i) != 35 && m(j, i) != 46) pos = Coord(j, i);
        }
    }

    bool end_path = false;

    int run = 0;
    while (!end_path) {
        if (m.inbounds(pos + dir) && m[pos + dir] == 35) {
            run += 1;
            pos += dir;
        } else {
            if (run != 0) res += to_string(run) + ",";
            run = 0;

            if (m.inbounds(pos + im * dir) && m[pos + im * dir] == 35) {
                dir *= im;
                res += "R,";
            } else if (m.inbounds(pos - im * dir) && m[pos - im * dir] == 35) {
                dir *= -im;
                res += "L,";
            } else {
                end_path = true;
            }
        }
    }

    return res;
}

list<string> find_patterns(string path) {
    for (int l1 = 2;; l1++) {
        if (path[l1 - 1] != ',') continue;

        int off1 = l1;
        string p1 = path.substr(0, l1);

        while (path.substr(off1, l1) == p1) off1 += l1;

        for (int l2 = 2; l2 <= 20; l2++) {
            if (path[off1 + l2 - 1] != ',') continue;

            int off2 = off1 + l2;
            string p2 = path.substr(off1, l2);

            while (true) {
                if (path.substr(off2, l1) == p1)
                    off2 += l1;
                else if (path.substr(off2, l2) == p2)
                    off2 += l2;
                else
                    break;
            }

            for (int l3 = 2; l3 <= 20; l3++) {
                if (path[off2 + l3 - 1] != ',') continue;

                string p3 = path.substr(off2, l3);

                string tmp = replace(path, p1, ",");
                tmp = replace(tmp, p2, ",");
                tmp = replace(tmp, p3, ",");
                tmp = replace(tmp, ",", "");

                if (tmp == "") {
                    string main = replace(path, p1, "A,");
                    main = replace(main, p2, "B,");
                    main = replace(main, p3, "C,");

                    main.pop_back();
                    p1.pop_back();
                    p2.pop_back();
                    p3.pop_back();

                    return {main, p1, p2, p3};
                }
            }
        }
    }

    return {};
}

int part_2(IntCode& ic, Matrix& m) {
    auto path = find_path(m);
    auto patterns = find_patterns(path);
    patterns.push_back("n");

    ic.program[0] = 2;

    ic.init();
    ic.input_strlist(patterns);
    ic.run();

    auto v = ic.get_outputs();
    return v.back();
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        throw invalid_argument("Must supply filename !");
    }
    string filename = argv[1];

    IntCode ic(filename);
    ic.start();
    auto output = ic.get_outputs();
    auto m = Matrix(output);

    cout << "Part 1 : " << part_1(m) << endl;
    cout << "Part 2 : " << part_2(ic, m) << endl;

    return 0;
}