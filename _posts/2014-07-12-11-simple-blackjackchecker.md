---
layout: post
title: Simple BlackJackChecker
categories:
- C++
tags:
- C++
---

Wanted to add something very quick before heading to bed. I'm going to edit this post when I wake up. Here's my first take on <a href="http://www.reddit.com/r/dailyprogrammer/comments/29zut0/772014_challenge_170_easy_blackjack_checker/" title="Reddit's simple blackjack checker">Reddit's simple blackjack checker</a>. <!--more-->Seems to work, and I think it's fairly elegant, tbh, but I'll have a better look when it's not 6 in the morning :).

Edit: I was reading the code again today. Some of the things I would change are:
<ul>
<li>Spit the work into input phase and output phase. In input phase, simply store the strings. I feel like that's probably good programming practice.</li>
<li>Reduce the number of lines in main, although there are that many. Split the different areas into functions.</li>
<li>Add more objected orientedness to make this more tidy. It's a little bit messy right now.</li>
</ul>

<!--more-->

{% highlight c++ %}
#include <iostream>
#include <string>
#include <vector>
#include <algorithm>

using namespace std;

struct Player
{
    string Name = "";
    int currentTotal = 0;
    int bestTotal = 0;
    int Aces = 0;
    bool folded = false;
    int NumberOfCards = 0;
    void AddValue(int val)
    {
        if (val == 1)
            Aces++;
        else
            currentTotal += val;

        bestTotal = getBestTotal();
        if (bestTotal > 21)
            folded = true;
        NumberOfCards++;
    }
    int getBestTotal()
    {
        int tempTotal = currentTotal;
        int tempAces = Aces;
        if (tempAces > 1)
        {
            //The other aces need to be 1s to get the best value so
            tempTotal += (tempAces - 1);
            tempAces = 1;
        }
        if ( tempTotal + tempAces*11 <= 21)
            return tempTotal + tempAces * 11;
        else
            return tempTotal + tempAces;
    }

};

int ConvertCardToInt(string Card)
{
    int output = 0;
    if (Card == "Ace"){
        output = 1;
    }
    else if (Card == "King"){
        output = 10;
    }
    else if (Card == "Queen"){
        output = 10;
    }
    else if (Card == "Jack"){
        output = 10;
    }
    else if (Card == "Ten"){
        output = 10;
    }
    else if (Card == "Nine"){
        output = 9;
    }
    else if (Card == "Eight"){
        output = 8;
    }
    else if (Card == "Seven"){
        output = 7;
    }
    else if (Card == "Six"){
        output = 6;
    }
    else if (Card == "Five"){
        output = 5;
    }
    else if (Card == "Four"){
        output = 4;
    }
    else if (Card == "Three"){
        output = 3;
    }
    else if (Card == "Two"){
        output = 2;
    }
    else
    {
        output = 0;
    }
    return output;
}

vector<string> wordCreater(string input)
{
    vector<string> output;
    // Let's get the name out of the way first
    size_t currentStartPos = input.find_first_of(':');
    string temp = input.substr(0, currentStartPos);
    output.push_back(temp);
    size_t increaser = currentStartPos;
    do
    {
        currentStartPos = increaser + 2;    //Assuming there's a space after the delimiter
        increaser = input.find_first_of(',', currentStartPos);
        temp = input.substr(currentStartPos, increaser - currentStartPos);
        output.push_back(temp);
    } while (increaser != string::npos);
    return output;
}

string getCardVal(string input)
{
    //We know the first word is the card value, so just get that
    size_t FirstSpacePosition = input.find_first_of(' ');
    return input.substr(0, FirstSpacePosition);
}

template <typename T>
void deletePtr(T* const ptr)
{
    delete ptr;
}

bool comparePlayers(Player* i, Player* j)
{
    if (i->folded && j->folded)
        return true; //doesn't even matter

    if (i->folded && !j->folded)
    {
        return true;
    }
    else if (!i->folded && j->folded)
    {
        return false;
    }
    //Check for 5 card trick
    else if (i->NumberOfCards >= 5)
    {
        return false;
    }
    else if (j->NumberOfCards >= 5)
    {
        return true;
    }
    // both are either not folded
    else if (i->bestTotal < j->bestTotal)
        return true;
    else
        return false;
}
int main(int argc, const char** argv)
{
    vector<Player*> Players;
    // Get the number of
    int NumberOfPlayers = 0;
    string temp;
    getline(cin, temp);

    NumberOfPlayers = atoi(&temp[0]);
    for (int i; i < NumberOfPlayers; i++)
    {
        getline(cin, temp);
        Player* player = new Player();
        vector<string> tokens = wordCreater(temp);
        player->Name = tokens[0];

        for (vector<string>::iterator iter = tokens.begin() + 1; iter != tokens.end(); iter++){
            string cardValue = getCardVal(*iter);
            player->AddValue(ConvertCardToInt(cardValue));
        }
        Players.push_back(player);
    }
    sort(Players.begin(), Players.end(), comparePlayers);

    //Winner
    if (!(*(Players.end() - 1))->folded)
    {
        string trick = ((*(Players.end() - 1))->NumberOfCards >= 5 ) ? " with a 5-card trick!" : "!";
        cout << "\n" + (*(Players.end() - 1))->Name + " has won" + trick;
    }
    else
        printf("\nNo one won!");

    //clean up
    for_each(Players.begin(), Players.end(), deletePtr<Player>);

    return 0;
}{% endhighlight %}
