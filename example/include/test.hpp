#include <stdio.h>
#include <stdlib.h>

class T {
public:
  T() { A = (int *)malloc(1); }
  ~T() { free(this->A); }
  int *A;
};
