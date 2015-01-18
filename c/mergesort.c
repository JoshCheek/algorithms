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

int * merge(int *arr_one, int *arr_two){
  int arr_one_len = sizeof(arr_one) / sizeof(int)
  int arr_two_len = sizeof(arr_two) / sizeof(int)
  int i, j = 0;
  int sorted[arr_one_len + arr_two_len];
  while (i < arr_one_len && j < arr_two_len) {
    if (arr_one[i] < arr_two[j]) {
      *sorted = arr_one[i]
        i += 1;
    } else {
      *sorted = arr_two[j]
        j += 1;
    }
    sorted += 1;
  }

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
