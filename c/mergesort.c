#include <stdio.h>

int * mergesort(int *arr){
  int * sorted;
  int length = sizeof(arr) / sizeof(int)
    if (length <= 1){
      return arr;
    } else {
      int * first_half = mergesort(arr + (length / 2) - 1);
      int * second_half = mergesort(arr + ());
      for (int = i; i < length / 2; i++){
        first = first_half[i];
        second = second_half[i];
        if (first < second){
          sorted[i] = first;
          sorted[i + 1] = second;
        } else {
          sorted[i] = second;
          sorted[i + 1] = first;
        }
      }

    }
  return sorted;
}

int main(int argc, char** argv){
  int nums[4];
  for (int i = 0; i < 4; i++){
    int arg;
    printf("Give me a number:\n");
    scanf("%d", &arg);
    nums[i] = arg;
  }
  return 0;
}
