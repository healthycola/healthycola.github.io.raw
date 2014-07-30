---
layout: post
title: 2D Matrix Rotator
categories:
- C++
tags:
- C++
---

Simple challenge was <a href="http://www.reddit.com/r/dailyprogrammer/comments/29i9jw/6302014_challenge_169_easy_90_degree_2d_array/">posted</a> up on reddit.

There was a really simple solution to it which would perform the task with O(n<sup>2</sup>) space and O(n<sup>2</sup>) time. It would involve creating a new array with the same dimensions as the original matrix, and copying the values into their new spots.
<!--more-->

I wanted to do better than this solution and thought of an onion-method to do it. It would include starting with the outside layer of the matrix, and switching the numbers with their new spots for the four sides. For instance, if the following was the matrix:

~~~~
|  1  |  2  |  3  |  4  |
|  5  |  6  |  7  |  8  |
|  9  |  10 |  11 |  12 |
|  13 |  14 |  15 |  16 |
~~~~~

In the first layer, for the first iteration, 1 would move to 4s position, 4 would move to 16, 16 would move to 13s position, and 13 would move to 1s position. Iterating through all n - 1 numbers of the layer, (i.e. 1 to 3), the outer layer would have been rotated. Moving down inwards in similar fashion will have switched the entire matrix.
<!--more-->

Let's get to the code:
{% highlight c++ %}
#include <iostream>
#include <string>
#include <vector>
#include <math.h>
using namespace std;

// Slightly modified from the original tokenizeString in RummyChecker. This version converts the strings directly into integers
static const vector<int> tokenizeStrings(string input, string delimiter, int NumberOfSpacesAfterDelimiter)
{
    vector<int> output;
    size_t start;
    size_t found = -1 - NumberOfSpacesAfterDelimiter;  //Two because of spaces after delimiter
    string temp;
    do {
        start = found + 1 + NumberOfSpacesAfterDelimiter;  //Two because of spaces
        found = input.find_first_of(delimiter, start);
        temp = input.substr(start, found - start);
        output.push_back(atoi(&amp;temp[0]));
    } while(found != string::npos);
    return output;
}

void printMatrix(int* matrix, int N)
{
    cout << "\n";
    for (int r = 0; r < N; r++)
    {
        for (int c = 0; c < N; c++)
        {
            cout << matrix[r*N + c] << " ";
        }
        cout << "\n";
    }
}
void rotateMatrix(int* matrix, int N)
{
    //Work from outside, and rotate inwards
    double layerLimit = (double)N/2.0;
    for (int layer = 1; layer <= ceil(layerLimit); layer++)
    {
        int tempSource, tempTarget, tempIndex1, tempIndex2;
        for (int i = 0; i < N - 2*layer + 1; i++)
        {
            tempIndex1 = (layer - 1)*N - 1 + layer + i;
            tempIndex2 = (layer - 1)*N + N*(i + 1) -layer;
            tempTarget = matrix[tempIndex2];
            matrix[tempIndex2] = matrix[tempIndex1];
            tempSource = tempTarget;
            tempIndex2 = N*N - (layer - 1)*N - layer - i;
            tempTarget = matrix[tempIndex2];
            matrix[tempIndex2] = tempSource;
            tempSource = tempTarget;
            tempIndex2 = N*(N - i - 1) - (layer - 1)*N + layer - 1;
            tempTarget = matrix[tempIndex2];
            matrix[tempIndex2] = tempSource;
            matrix[tempIndex1] = tempTarget;
        }
    }
}

int main(int argc, char** argv)
{
    int* TwoDArr = nullptr;
    int N = 0;
    string input;
    cout << "N = ";
    getline(cin, input);
    N = atoi(&amp;input[0]);
    TwoDArr = new int[N*N];
    cout << "What is the array?:\n";
    for (int i = 0; i < N; i++)
    {
        getline(cin, input);
        memcpy(&amp;TwoDArr[i*N], &amp;(tokenizeStrings(input, " ", 0))[0], sizeof(int) * N);
    }
    cout << "rotate? y/n: \n";
    getline(cin, input);
    while (input == "y")
    {
        rotateMatrix(TwoDArr, N);

        printMatrix(TwoDArr, N);
        cout << "rotate? y/n: \n";
        getline(cin, input);
    }
    //cleanup
    delete[] TwoDArr;
    return 0;
}
{% endhighlight %}

Looking at the code above, the main loop runs for `N/2` times while the inner loop runs for `N - 2*N/2 + 1` times. Total time is then `O(N/2*(N-N+1))` which is `O(N)`. And the space requirement is O(1). I guess mission accomplished! :)

Here is a sample of the output:

~~~~~~~~
N = 10
What is the array?:
1 2 3 4 5 6 7 8 9 0
0 9 8 7 6 5 4 3 2 1
1 3 5 7 9 2 4 6 8 0
0 8 6 4 2 9 7 5 3 1
0 1 2 3 4 5 4 3 2 1
9 8 7 6 5 6 7 8 9 0
1 1 1 1 1 1 1 1 1 1
2 2 2 2 2 2 2 2 2 2
9 8 7 6 7 8 9 8 7 6
0 0 0 0 0 0 0 0 0 0
rotate? y/n:
y

0 9 2 1 9 0 0 1 0 1
0 8 2 1 8 1 8 3 9 2
0 7 2 1 7 2 6 5 8 3
0 6 2 1 6 3 4 7 7 4
0 7 2 1 5 4 2 9 6 5
0 8 2 1 6 5 9 2 5 6
0 9 2 1 7 4 7 4 4 7
0 8 2 1 8 3 5 6 3 8
0 7 2 1 9 2 3 8 2 9
0 6 2 1 0 1 1 0 1 0
rotate? y/n:
y

0 0 0 0 0 0 0 0 0 0
6 7 8 9 8 7 6 7 8 9
2 2 2 2 2 2 2 2 2 2
1 1 1 1 1 1 1 1 1 1
0 9 8 7 6 5 6 7 8 9
1 2 3 4 5 4 3 2 1 0
1 3 5 7 9 2 4 6 8 0
0 8 6 4 2 9 7 5 3 1
1 2 3 4 5 6 7 8 9 0
0 9 8 7 6 5 4 3 2 1
rotate? y/n:
y

0 1 0 1 1 0 1 2 6 0
9 2 8 3 2 9 1 2 7 0
8 3 6 5 3 8 1 2 8 0
7 4 4 7 4 7 1 2 9 0
6 5 2 9 5 6 1 2 8 0
5 6 9 2 4 5 1 2 7 0
4 7 7 4 3 6 1 2 6 0
3 8 5 6 2 7 1 2 7 0
2 9 3 8 1 8 1 2 8 0
1 0 1 0 0 9 1 2 9 0
rotate? y/n:
y

1 2 3 4 5 6 7 8 9 0
0 9 8 7 6 5 4 3 2 1
1 3 5 7 9 2 4 6 8 0
0 8 6 4 2 9 7 5 3 1
0 1 2 3 4 5 4 3 2 1
9 8 7 6 5 6 7 8 9 0
1 1 1 1 1 1 1 1 1 1
2 2 2 2 2 2 2 2 2 2
9 8 7 6 7 8 9 8 7 6
0 0 0 0 0 0 0 0 0 0
rotate? y/n: n

Program exited with code 0.
~~~~~~~~~