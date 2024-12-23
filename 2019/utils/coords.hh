#include <cmath>
#include <cstdlib>
#include <functional>
#include <iostream>

using namespace std;

// Complex coordinates for 2d plane
class Coord {
   public:
    int x;
    int y;

    Coord(int x, int y) : x(x), y(y) {}
    Coord() : x(0), y(0) {}

    int norm1() const { return abs(x) + abs(y); }
    int normsq() const { return x * x + y * y; }
    float arg() const { return atan2(y, x); }

    Coord& operator=(const Coord& rhs) {
        x = rhs.x;
        y = rhs.y;
        return *this;
    }

    Coord& operator+=(const Coord& rhs) {
        x += rhs.x;
        y += rhs.y;
        return *this;
    }
    Coord operator-=(const Coord& rhs) { return *(this) += -rhs; }

    Coord& operator*=(const int& rhs) {
        x *= rhs;
        y *= rhs;
        return *this;
    }
    Coord& operator*=(const Coord& rhs) {
        int new_x = x * rhs.x - y * rhs.y;
        y = y * rhs.x + x * rhs.y;
        x = new_x;
        return *this;
    }

    Coord& operator/=(const int& n) {
        x /= n;
        y /= n;
        return *this;
    }

    Coord operator-() const { return Coord(-x, -y); }
};

Coord operator+(Coord lhs, const Coord& rhs) { return lhs += rhs; }
Coord operator-(Coord lhs, const Coord& rhs) { return lhs -= rhs; }
Coord operator*(Coord lhs, const int& rhs) { return lhs *= rhs; }
Coord operator*(const int& lhs, Coord rhs) { return rhs *= lhs; }
Coord operator*(Coord lhs, const Coord& rhs) { return lhs *= rhs; }
Coord operator/(Coord lhs, const int& rhs) { return lhs /= rhs; }

bool operator<(const Coord& lhs, const Coord& rhs) {
    return tie(lhs.x, lhs.y) < tie(rhs.x, rhs.y);
}
bool operator>(const Coord& lhs, const Coord& rhs) { return rhs < lhs; }

bool operator==(const Coord& lhs, const Coord& rhs) {
    return tie(lhs.x, lhs.y) == tie(rhs.x, rhs.y);
}
bool operator!=(const Coord& lhs, const Coord& rhs) { return !(lhs == rhs); }

ostream& operator<<(ostream& os, const Coord& obj) {
    os << '(' << obj.x << ',' << obj.y << ')';
    return os;
}

namespace std {
template <>
struct hash<Coord> {
    size_t operator()(Coord const& coord) const noexcept {
        size_t h1 = hash<int>{}(coord.x);
        size_t h2 = hash<int>{}(coord.y);
        return h1 ^ (h2 << 1);
    }
};
}  // namespace std

const vector<Coord> directions = {Coord(0, 1), Coord(0, -1), Coord(-1, 0), Coord(1, 0)};
