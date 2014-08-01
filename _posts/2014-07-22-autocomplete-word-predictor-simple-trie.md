---
layout: post
title: Autocomplete / Word Predictor / Simple Trie
categories:
- C++
tags:
- C++
- algorithm
- Trie
---

Decided to code up a Simple Trie for kicks. The code is still in the works, but can be accessed on git <a href="https://github.com/healthycola/SimpleWordPredictor/" target="_blank">here</a>.

I had never coded something of nature before, so this was a fun exercise in recursion. A description of a Trie was on <a href="http://en.wikipedia.org/wiki/Trie" target="_blank">wiki</a>, but I found the description described in <a href="http://www.csse.monash.edu.au/~lloyd/tildeAlgDS/Tree/Trie/" target="_blank">this</a> site more comprehensible.
<!--more-->
<blockquote>
A trie (from retrieval), is a multi-way tree structure useful for storing strings over an alphabet. It has been used to store large dictionaries of English (say) words in spelling-checking programs and in natural-language "understanding" programs.
</blockquote>

<!--more-->

For reference, the insert method was fairly simple. It included simply advancing a pointer to the current character of the word that we'd like to add by one. If the node for the next letter was in the tree then we would just go down the tree. Otherwise, we'd add it to the tree and continue until the end of the word, where we would have an end node.

{% highlight c++ %}
        void insert(string word, int charLocation)
        {
            //cout << word << "\n";
            if (charLocation == word.length())
            {
                //last letter
                node* EndNode = new node('&#092;&#048;');
                children.push_back(EndNode);
                return;
            }
            else
            {
                vector<node*>::iterator child;
                for (child = children.begin(); child != children.end(); child++)
                {
                    if ((*child)->val == word[charLocation])
                        break;
                }

                if (child == children.end())
                {
                    node* middleNode = new node(word[charLocation]);
                    children.push_back(middleNode);
                    totalNodes++;
                    return middleNode->insert(word, charLocation + 1);
                }
                else
                {
                    return (*child)->insert(word, charLocation + 1);
                }
            }
        }
{% endhighlight %}

Retrieval was a bit more of a challenge. Given a small input string, the challenge was to find out all the possible words. This, I'm sure can be implemented in a better way than I have. What I do is, basically traverse the tree until I get to the last character of the input string. Then I want to retrieve all the words that branch from that character. It sounds okay in theory, but I think my implementation can be improved.

{% highlight c++ %}
string retrieve(string input, int charLocation)
        {
            string output = "";
            if (charLocation <= input.length() - 1)
            {
                //Get to correct branch
                vector<node*>::iterator child;
                for (child = children.begin(); child != children.end(); child++)
                {
                    if ((*child)->val == input[charLocation])
                        break;
                }
                if (child == children.end())
                    return "";
                else
                {
                    return (*child)->retrieve(input, charLocation + 1);
                }
            }
            else if (val == '&#092;&#048;')
            {
                return input + "\n";
            }
            else if (charLocation == input.length())
            {
                for (vector<node*>::iterator child = children.begin(); child != children.end(); child++)
                {
                    output += (*child)->retrieve(input, charLocation + 1);
                }
                return output;
            }
            else
            {
                //All the subsequent strings will be recommendations
                for (vector<node*>::iterator child = children.begin(); child != children.end(); child++)
                {
                    output += (*child)->retrieve(input + val, charLocation + 1);
                }
                return output;
            }
        }
{% endhighlight %}

A sample run of the program for a list of 200 words (which is up on the Git page) is shown below.
{% highlight c++ %}
Enter the filePath: wordList.txt
Trie was populated. Total notes created were 613
Enter a stream and we will tell you what words are possible. Enter quit to exit.
ga
Next Word: lo
Next Word: li
little
live
line
light
life
list
Next Word: ab
above
Next Word: tr
try
tree
Next Word: quit
Program ended with exit code: 0
{% endhighlight %}

All in all this was a fun exercise. I think I'll include weights to the words so that they are sorted in a smarter order than this. Still a WIP!
