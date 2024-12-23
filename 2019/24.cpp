#include <unordered_set>

#include "utils/matrix.hh"

int step1(Matrix& m) {
    // We have to hardcode grid size
    int neighbors[5][5]{};

    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            Coord p(i, j);
            for (auto d : directions) {
                if (m.inbounds(p + d) && m[p + d] == '#') neighbors[i][j]++;
            }
        }
    }

    int result;
    for (int i = 0; i < 5; i++) {
        for (int j = 0; j < 5; j++) {
            if (neighbors[i][j] == 1)
                m(i, j) = '#';
            else if (neighbors[i][j] == 2 && m(i, j) == '.')
                m(i, j) = '#';
            else
                m(i, j) = '.';

            if (m(i, j) == '#') result += 1 << (5 * j + i);
        }
    }

    return result;
}

int part_1(Matrix m) {
    unordered_set<int> scores;
    int score;
    do {
        score = step1(m);
        scores.insert(score);
    } while (!scores.contains(score));

    return score;
}

int step2(int bugs[][5][5], int max_depth, int offset) {
    int n_neighbors[2 * max_depth + 1][5][5];

    for (int depth = offset - max_depth; depth <= offset + max_depth; depth++) {
        int d_index = depth - offset + max_depth;
        for (int x = 0; x < 5; x++) {
            for (int y = 0; y < 5; y++) {
                if (x == 2 && y == 2) continue;
                n_neighbors[d_index][x][y] = 0;

                for (auto d : directions) {
                    if ((x + d.x == 2) && (y + d.y == 2)) {
                        for (int i = -2; i <= 2; i++) {
                            n_neighbors[d_index][x][y] +=
                                bugs[depth + 1][2 - 2 * d.x + i * d.y]
                                    [2 - 2 * d.y + i * d.x];
                        }
                    } else if (x + d.x < 0 || x + d.x >= 5 || y + d.y < 0 ||
                               y + d.y >= 5) {
                        n_neighbors[d_index][x][y] += bugs[depth - 1][2 + d.x][2 + d.y];
                    } else {
                        n_neighbors[d_index][x][y] += bugs[depth][x + d.x][y + d.y];
                    }
                }
            }
        }
    }

    int n_bugs = 0;
    for (int depth = offset - max_depth; depth <= offset + max_depth; depth++) {
        int d_index = depth - offset + max_depth;
        for (int x = 0; x < 5; x++) {
            for (int y = 0; y < 5; y++) {
                if (x == 2 && y == 2) continue;

                if (n_neighbors[d_index][x][y] == 1)
                    bugs[depth][x][y] = 1;
                else if (n_neighbors[d_index][x][y] == 2 && !bugs[depth][x][y])
                    bugs[depth][x][y] = 1;
                else
                    bugs[depth][x][y] = 0;

                n_bugs += bugs[depth][x][y];
            }
        }
    }

    return n_bugs;
}

int part_2(Matrix m, uint n_iter) {
    int max_depth = (n_iter + 3) / 2;
    int bugs[2 * max_depth + 1][5][5];

    for (int depth = -max_depth; depth <= max_depth; depth++) {
        for (int x = 0; x < 5; x++) {
            for (int y = 0; y < 5; y++) {
                bugs[depth + max_depth][x][y] = depth ? 0 : (int)(m(x, y) == '#');
            }
        }
    }
    int res;
    for (uint n = 0; n < n_iter; n++) {
        res = step2(bugs, n / 2 + 1, max_depth);
    }

    return res;
}

int main(int argc, char* argv[]) {
    if (argc < 2) {
        throw invalid_argument("Must supply filename !");
    }
    string filename = argv[1];
    Matrix m(filename);
    cout << part_1(m) << endl;
    cout << part_2(m, 200) << endl;

    return 0;
}