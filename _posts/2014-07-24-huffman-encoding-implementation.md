---
layout: post
title: Huffman Encoding Implementation
categories:
- C++
tags:
- algorithm
- C++
- encoding
- huffman
---

There was a fun little challenge on Reddit that I decided to partake in. I'm going to copy the challenge from [there](http://www.reddit.com/r/dailyprogrammer/comments/2b21mp/7182014_challenge_171_hard_intergalatic_bitstream/" target="_blank") for completion.
<!--more-->

> It is 2114. We have colonized the Galaxy. To communicate we send 140 character max messages using [A-Z0-9 ]. The technology to do this requires faster than light pulses to beam the messages to relay stations.
>
> Your challenge is to implement the compression for these messages. The design is very open and the solutions will vary.
>
> Your goals:
>
> * Compact 140 Bytes down to a stream of bits to send and then decompact the message and verify 100% data contained.
>
> * The goal is bit reduction. 140 bytes or less at 8 bits per byte so thats 1120 bits max. If you take a message of 140 bytes and compress it to 900 bits you have 220 less bits for 20% reduction.


I decided to take this as an excuse to implement the <a href="http://en.wikipedia.org/wiki/Huffman_coding" target="_blank">Huffman Encoding</a> technique that we learned about in school. 


This was the first time I had a chance to work with the map data structure in C++, so that was fun. Essentially, what I did was supply the program with a sample text from which it could extract frequency data of each of the characters. I realized after that I could have just wiki'd this, since frequency data for letters is <a href="http://en.wikipedia.org/wiki/Letter_frequency" target="_blank">available</a> online. Ah well...
<!--more-->


Once I generated the frequency list, I went ahead and created the tree using nodes. Each node contain a few things - frequency of that particular character (or parent), the value of the character if it was a leaf node, and the pointers to the left and right nodes (null upon initialization, and it remains null if they are leaf nodes).


{% highlight c++ %}
void generateTree()
    {
        vector<HuffEncNode*> TreeNodes;
        for (map<char, int>::iterator it = frequencyChart.begin(); it != frequencyChart.end(); it++)
        {
            HuffEncNode* leafNode = new HuffEncNode((it)->first, (it)->second);
            TreeNodes.push_back(leafNode);
        }
        sort(TreeNodes.begin(), TreeNodes.end(), HuffEncNode::compare);
        while (TreeNodes.size() > 1)
        {
            //Pop last two elements
            HuffEncNode* RightNode = TreeNodes.back();
            TreeNodes.pop_back();
            HuffEncNode* LeftNode = TreeNodes.back();
            TreeNodes.pop_back();


            HuffEncNode* parentNode = new HuffEncNode(RightNode->frequency + LeftNode->frequency, LeftNode, RightNode);
            TreeNodes.push_back(parentNode);
            sort(TreeNodes.begin(), TreeNodes.end(), HuffEncNode::compare);
        }
        parentNode = TreeNodes.front();


        //Generate the encoding map
        parentNode->generateCodes("", &encodedMap);
    }
{% endhighlight %}


The algorithm itself is described on the wikipedia page for Huffman encoding. The last bit of the code which says Generate the encoding map, essentially traverses down the tree and saves the codes for each character in a map for easier access during the encoding process. 


During the decoding process, the program would simply traverse down the tree based on the bit (1 or 0) until it hit a character. That's the beauty of Huffman Encoding.


{% highlight c++ %}
char deCode(string input, int* characterLocation)
{
    if (leftNode == NULL && rightNode == NULL)
    {
        //leaf node
        return ASCIIVal;
    }

    if (input[*characterLocation] == '0')
    {
        //go into the right node
        (*characterLocation)++;
        return rightNode->deCode(input, characterLocation);
    }
    else
    {
        //go into the left node
        (*characterLocation)++;
        return leftNode->deCode(input, characterLocation);
    }
}
{% endhighlight %}


The sample that the challenge wanted us to use was as follows:

<ol>
<li>REMEMBER TO DRINK YOUR OVALTINE</li>
<li>GIANTS BEAT DODGERS 10 TO 9 AND PLAY TOMORROW AT 1300</li>
<li>SPACE THE FINAL FRONTIER THESE ARE THE VOYAGES OF THE BIT STREAM DAILY PROGRAMMER TO SEEK OUT NEW COMPRESSION</li>
</ol>

Using the test set above to train the Huffman encoding would defeat the purpose of the challenge, but I figured it would be a good benchmark to use. So developing the encoding tree with the test set above resulted in this:

<pre>
<em><strong>The coding is as follows:</strong></em>
  - 11
0 - 101010
1 - 0001011
2 - 00011111111111110
3 - 000111110
4 - 000111111111110
5 - 00011111111110
6 - 000111111110
7 - 00011111110
8 - 0001111110
9 - 00011110
A - 0110
B - 011110
C - 101011
D - 10100
E - 100
F - 011111
G - 000011
H - 000010
I - 01001
J - 0001111111110
K - 0001010
L - 000000
M - 01110
N - 01000
O - 0011
P - 000001
Q - 0001111111111110
R - 0101
S - 1011
T - 0010
U - 0001000
V - 0001001
W - 0001110
X - 000111111111111110
Y - 000110
Z - 000111111111111111

<em><strong>Results are as follows:</strong></em>
Read Message of 31 Bytes.
Compressing 248 Bits into 134 Bits. (45.9677% compression)
Sending Message
Decompressing Message into 31 Bytes.
Message Matches!

Read Message of 53 Bytes.
Compressing 424 Bits into 233 Bits. (45.0472% compression)
Sending Message
Decompressing Message into 53 Bytes.
Message Matches!

Read Message of 109 Bytes.
Compressing 872 Bits into 449 Bits. (48.5092% compression)
Sending Message
Decompressing Message into 109 Bytes.
Message Matches!
Program ended with exit code: 0
</pre>

Training the Huffman Tree with an ebook I found on <a href="http://gutenberg.org" target="_blank">Project Gutenberg</a> worked fairly well for me. Here are the results:

<pre>
<em><strong>The coding is as follows:</strong></em>
  - 000
0 - 111010101
1 - 11101011
2 - 111010001
3 - 111010100
4 - 0100011101
5 - 0100011111
6 - 1110100111
7 - 1110100100
8 - 1110100101
9 - 01000111000
A - 0101
B - 100111
C - 10010
D - 11100
E - 110
F - 001101
G - 010000
H - 1111
I - 0111
J - 0100011110
K - 01000110
L - 01001
M - 001111
N - 1000
O - 0110
P - 001110
Q - 1110100110
R - 1011
S - 1010
T - 0010
U - 001100
V - 0100010
W - 100110
X - 111010000
Y - 111011
Z - 01000111001

<em><strong>Results are as follows:</strong></em>
Read Message of 31 Bytes.
Compressing 248 Bits into 135 Bits. (45.5645% compression)
Sending Message
Decompressing Message into 31 Bytes.
Message Matches!

Read Message of 53 Bytes.
Compressing 424 Bits into 253 Bits. (40.3302% compression)
Sending Message
Decompressing Message into 53 Bytes.
Message Matches!

Read Message of 109 Bytes.
Compressing 872 Bits into 449 Bits. (48.5092% compression)
Sending Message
Decompressing Message into 109 Bytes.
Message Matches!
</pre>

Not bad! The bench mark gives 46%, 45% and 48.5%. On the other side, I get compression rates of 45.6%, 40.33% and 48.5%. Not bad! Seems like the main issue with the ebook text I used was with the numbers. 


Anyway, I'm gonna head to sleep, but that was fun! Gotta refine the project files up. <del datetime="2014-07-24T21:09:48+00:00">I'll do that later</del>. <ins datetime="2014-07-24T21:09:48+00:00"><a href="https://github.com/healthycola/HuffmanEncode" target="_blank">They're up now</a>.</ins>

