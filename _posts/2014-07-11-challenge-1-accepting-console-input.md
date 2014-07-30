---
layout: post
title: 'Challenge 1: Accepting console input'
categories:
- C++
tags:
- C++
- practice
---


Lets read in strings. we will give n the number of strings then the strings.
<!--more-->
Example:
`5
Huey
Dewey
Louie
Donald
Scrooge`


Seemed like a fairly simple first challenge on my road to recovery back to C++. Here is my first attempt:
{% highlight c++ %}
#include <iostream>
using namespace std;
int main(int argc, const char * argv[])
{
    int NumberOfStrings = 0;
    cin >> NumberOfStrings;
    string* AllStrings = new string[NumberOfStrings];
    
    for (int i = 0; i < NumberOfStrings; i++)
        cin >> AllStrings[i];
    cout << "The strings inputted were:\n";
    for (int i = 0; i < NumberOfStrings; i++)
        cout << AllStrings[i] + "\n";
    delete[] AllStrings;
    return 0;
}
{% endhighlight %}

Although this is okay, especially for the example in question, it is not really the best solution. First of all it uses arrays, which are looked down upon for scalability. Secondly, I need to remember to delete the array to prevent memory leaks. Second of all, <code>cin</code> considers spaces as end of lines, which is not good for more complex phrases such as:

<blockquote>

<code>Hello how are you?
I'm fine thanks!
And yourself?</code>
</blockquote>


Here is a more revised version of the same program:
{% highlight c++ %}
#include <iostream>
#include <vector>
using namespace std;
int main(int argc, const char * argv[])
{
   // Vector is a more powerful data structure
   vector<string> myStrings;
   int n = 0;
   string temp;
   getline(cin, temp);
   n = atoi(&temp[0]);
   //cin.ignore();   //needed to clear the buffer it seems.
   for (int i = 0; i < n; ++i)
   {
       getline(cin, temp);
       myStrings.push_back(temp);
   }
   cout << "The strings inputted were: \n";
   for (vector<string>::iterator iter = myStrings.begin(); iter != myStrings.end(); ++iter)
   {
       cout << *iter + "\n";
   }
   
}

{% endhighlight %}
The main changes include the usage of vectors which are more scalable and the use of getline to get the strings which include spaces and such. This solution seems more elegant.

