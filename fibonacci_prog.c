#include <stdio.h>
#include <stdint.h>

/* 
   fibonacci(0) = 0
   fibonacci(1) = 1
   for n > 1: fibonacci(n) = fibonacci(n-1) + fibonacci(n-2)
*/

uint32_t fibonacci(uint32_t n) {
   if (n == 0)
      return 0;

   if (n == 1)
      return 1;

   return fibonacci(n - 1) + fibonacci(n - 2);
}
#include <stdio.h>
#include <stdint.h>

extern uint32_t fib(uint32_t n);

int main() {
  uint32_t inputs[] = { 1, 2, 3, 4, 10, 11, 12, 13, 14, 16, 18, 20, 24, 0 };
  uint32_t i;

  for(i = 0; inputs[i]; i++) {
    /*  printf("%d -> %d\n", inputs[i], fibonacci(inputs[i])); */
  printf("%d\n", fibonacci(inputs[i]));
  }
}

