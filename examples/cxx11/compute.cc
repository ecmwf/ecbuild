#include <iostream>

#if __cplusplus > 199711L

#pragma message "C++11 enabled"
#include <unordered_set>
#define __set std::unordered_set<int>

#else

#pragma message "C++11 disabled"
#include <set>
#define __set std::set<int>

#endif

int main() {

  __set s;

  s.insert(7);
  s.insert(5);
  s.insert(3);

  for(__set::const_iterator it = s.begin(); it != s.end(); ++it)
    std::cout << *it << std::endl;

  return 0;
}
