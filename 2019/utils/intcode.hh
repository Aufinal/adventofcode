#pragma once
#include <iostream>
#include <list>
#include <queue>
#include <tuple>
#include <unordered_map>

#include "misc.hh"

enum State {
    ok,
    done,
    need_input,
};
class IntCode {
    unordered_map<long, long> memory;
    queue<long> inputs;
    deque<long> outputs;

    long cursor;
    long offset;

    tuple<short, short, short, short> _parse(int instr) {
        int t = instr % 100;
        instr /= 100;

        return make_tuple(t, instr % 10, (instr / 10) % 10, (instr / 100) % 10);
    }

    long read(short mode) {
        if (mode == 1) {
            return memory[cursor++];
        } else {
            long address = (mode / 2) * offset + memory[cursor++];
            return memory[address];
        }
    }

    void write(long value, short mode) {
        long address = (mode / 2) * offset + memory[cursor++];
        memory[address] = value;
    }

   public:
    vector<long> program;
    State state;

    // Constructors

    IntCode(string filename) {
        ifstream file(filename);
        string line;
        if (file.is_open()) {
            getline(file, line);
            file.close();
        }

        for (auto s : split(line)) {
            program.push_back(stol(s));
        }
    }

    // Input management

    void add_input() {}

    template <typename... Args>
    void add_input(long i, Args... args) {
        inputs.push(i);
        add_input(args...);
    }

    void input_string(string str) {
        for (auto c : str) {
            add_input(c);
        }

        add_input('\n');
    }

    void input_strlist(list<string> str_list) {
        for (auto str : str_list) {
            input_string(str);
        }
    }

    // Output management

    bool has_output() { return !outputs.empty(); }

    bool has_output(uint n) { return outputs.size() >= n; }

    long get_output() {
        long res = outputs.front();
        outputs.pop_front();
        return res;
    }

    vector<long> get_outputs() {
        vector<long> res(outputs.begin(), outputs.end());
        outputs.clear();
        return res;
    }

    vector<long> get_outputs(short n) {
        vector<long> res(n, 0);
        for (int i = 0; i < n; i++) {
            res[i] = outputs.front();
            outputs.pop_front();
        }
        return res;
    }

    long output_mem(long address) { return memory[address]; }

    // Running the computer

    void advance() {
        state = ok;
        auto [opcode, m1, m2, m3] = _parse(memory[cursor++]);
        switch (opcode) {
            case 1: {
                write(read(m1) + read(m2), m3);
                break;
            }
            case 2: {
                write(read(m1) * read(m2), m3);
                break;
            }
            case 3: {
                if (inputs.empty()) {
                    cursor--;
                    state = need_input;
                } else {
                    write(inputs.front(), m1);
                    inputs.pop();
                }
                break;
            }
            case 4:
                outputs.push_back(read(m1));
                break;
            case 5: {
                if (read(m1) != 0) {
                    long new_cursor = read(m2);
                    cursor = new_cursor;
                } else {
                    cursor++;
                }
                break;
            }
            case 6: {
                if (read(m1) == 0) {
                    long new_cursor = read(m2);
                    cursor = new_cursor;
                } else {
                    cursor++;
                }
                break;
            }
            case 7: {
                long lhs = read(m1);
                write(lhs < read(m2), m3);
                break;
            }
            case 8: {
                write(read(m1) == read(m2), m3);
                break;
            }
            case 9: {
                offset += read(m1);
                break;
            }
            case 99:
                state = done;
                break;
        }
    }

    void run() {
        do {
            advance();
        } while (state == ok);
    }

    void init() {
        memory.clear();
        int idx = 0;
        for (auto elt : program) memory[idx++] = elt;
        cursor = 0;
        offset = 0;
        inputs = queue<long>();
        outputs.clear();
        state = ok;
    }

    template <typename... Args>
    void start(Args... args) {
        init();
        add_input(args...);
        run();
    }
};