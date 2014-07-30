---
layout: post
title: Simple RummyChecker
categories:
- C++
tags:
- C++
---

This is a build up on the BlackJack Checker. The Rummy Checker challenge is also from Reddit and can be found <a href="http://www.reddit.com/r/dailyprogrammer/comments/2a9u0a/792014_challenge_170_intermediate_rummy_checker/">here</a>. I think it's more organized than the blackjack checker and less hacky (except for the Run checker function - this function is soooo messy. I need to fix it, urgh).
<!--more-->
Major things I'm happy about:
<ul>
<li>Simple tokenizer - It's just good to have this code. I think it's reusable.</li>
<li>Decent organization - A Card class and a Hand class was created. I think the organization is decent, not amazing, but it's getting there.</li>
</ul>

Areas I need to improve on:
<ul>
<li>Rummy Run Detector - At the moment it's really brute-forcy. Gotta think of a better idea to go about it.</li>
<li>Separation - Could use better separation between input and output areas of the program, just for good coding practice.</li>
</ul>

<!--more-->

{% highlight c++ %}
#include <iostream>
#include <vector>
#include <algorithm>
#include <string>

using namespace std;
int RunLength = 3;
int SetLength = 3;

enum Suite
{
    Spades, Hearts, Clubs, Diamonds, Unknown
};

static const vector<string> tokenizeStrings(string input, string delimiter, int NumberOfSpacesAfterDelimiter)
{
    vector<string> output;
    size_t start;
    size_t found = -1 - NumberOfSpacesAfterDelimiter;  //Two because of spaces after delimiter
    string temp;
    do {
        start = found + 1 + NumberOfSpacesAfterDelimiter;  //Two because of spaces
        found = input.find_first_of(delimiter, start);
        temp = input.substr(start, found - start);
        output.push_back(temp);
    } while(found != string::npos);
    return output;
}

struct Card
{
    Suite m_suite;
    int m_value;

    static const string CardValues[13];
    static const string CardSuits[4];
    static const int ConvertCardValueToInt(string Card)
    {
        int output = 0;
        if (Card == "ace"){
            output = 1;
        }
        else if (Card == "king"){
            output = 13;
        }
        else if (Card == "queen"){
            output = 12;
        }
        else if (Card == "jack"){
            output = 11;
        }
        else if (Card == "ten"){
            output = 10;
        }
        else if (Card == "nine"){
            output = 9;
        }
        else if (Card == "eight"){
            output = 8;
        }
        else if (Card == "seven"){
            output = 7;
        }
        else if (Card == "six"){
            output = 6;
        }
        else if (Card == "five"){
            output = 5;
        }
        else if (Card == "four"){
            output = 4;
        }
        else if (Card == "three"){
            output = 3;
        }
        else if (Card == "two"){
            output = 2;
        }
        else
        {
            output = 0;
        }
        return output;
    }

    static const string ConvertIntToCardValue(int Val)
    {
        if (Val > 0 && Val <= 13)
            return CardValues[Val - 1];

        return "";
    }

    static const Suite ConvertCardStringToSuite(string input)
    {
        Suite s = Unknown;
        if (input == "spades")
            s = Spades;
        else if (input == "hearts")
            s = Hearts;
        else if (input == "clubs")
            s = Clubs;
        else if (input == "diamonds")
            s = Diamonds;

        return s;
    }

    static const string ConvertCardSuitToString(Suite input)
    {
        if (input >= 0 && input <= 3)
            return CardSuits[input];

        return "";
    }

    Card(string CardInput)
    {
        //Accepts inputs such as Ace of Diamonds
        vector<string> temp = tokenizeStrings(CardInput, " ", 0);
        m_value = ConvertCardValueToInt(temp[0]);
        m_suite = ConvertCardStringToSuite(temp[2]);
    }
};

const string Card::CardValues[13] = { "ace", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "jack", "queen", "king" };
const string Card::CardSuits[4] = { "spades", "hearts", "clubs", "diamonds" };

template <class T>
void deletePtr(T* ptr)
{
    delete ptr;
}

struct Hand
{
    vector<Card*> m_hand;
    void AddCard(Card *card)
    {
        m_hand.push_back(card);
    }

    void cleanUp()
    {
        for_each(m_hand.begin(), m_hand.end(), deletePtr<Card>);
    }

    static bool sorter(Card* i, Card* j)
    {
        if (i->m_suite != j->m_suite)
            return (int)(i->m_suite) < (int)(j->m_suite);
        else
            return i->m_value < j->m_value;
    }

    void sortHand()
    {
        sort(m_hand.begin(), m_hand.end(), Hand::sorter);
    }

    Card* CheckForSet(Card _card)
    {
        int NewSet = _card.m_value;
        int NumberOfCardsForSet = 1;
        for (vector<Card*>::iterator card = m_hand.begin(); card != m_hand.end(); card++)
        {
            if ((*card)->m_value == NewSet)
                NumberOfCardsForSet++;
        }
        if (NumberOfCardsForSet >= SetLength)
        {
            // Means we have a set
            for (vector<Card*>::iterator card = m_hand.begin(); card != m_hand.end(); card++)
            {
                if ((*card)->m_value != NewSet)
                    return *card;
            }
        }
        return nullptr;
    }

    Card* CheckForRun(Card _card)
    {
        //Messy as hell
        vector<Card*> Run;
        bool isRun = false;
        for (vector<Card*>::iterator card = m_hand.begin(); card != m_hand.end(); card++)
        {
            isRun = false;
            if ((*card)->m_suite != _card.m_suite)
            {
                continue;
            }

            Run.clear();
            Run.push_back(&_card);
            for (vector<Card*>::iterator card_set = card; card_set != m_hand.end(); card_set++)
            {
                if (Run.size() >= RunLength || (*card_set)->m_suite != _card.m_suite)
                    break;
                Run.push_back((*card_set));
            }

            if (Run.size() < RunLength)
            {
                //No runs possible
                isRun = false;
                break;
            }

            sort(Run.begin(), Run.end(), sorter);
            if ((*(Run.end()-1))->m_value - (*(Run.begin()))->m_value == RunLength - 1)
                isRun = true;

            //Found a Run?
            if (isRun)
            {
                vector<Card*>::iterator cardReturn = m_hand.begin();
                for (; cardReturn != m_hand.end(); cardReturn++)
                {
                    bool foundCardReturn = true;
                    for (vector<Card*>::iterator set_check = Run.begin(); set_check != Run.end() - 1; set_check++)
                    {
                        //CHeck if current cardReturn is in the Run.
                        if (*set_check == &_card)
                            continue;

                        if (*cardReturn == *set_check)
                        {
                            // The card we want to return can't be in the set
                            foundCardReturn = false;
                            break;
                        }
                    }
                    if (foundCardReturn)
                    {
                        return *cardReturn;
                    }
                }
                break;
            }
        }

        return nullptr;
    }
};

void outputWin(Card* card)
{
    if (card)
    {
        cout << "Swap the new card with " << Card::ConvertIntToCardValue(card->m_value) << " of " << Card::ConvertCardSuitToString(card->m_suite) << " to win!\n";
    }
    else
    {
        printf("No possible winning hand.\n");
    }

}

int main(int argc, char** argv)
{
    //string sampleString = "Two of Diamonds, Three of Diamonds, Four of Diamonds, Seven of Diamonds, Seven of Clubs, Seven of Hearts, Jack of Hearts";
    //string newCard = "Five of Diamonds";

    string sampleString, newCard;
    cout << "What is the initial hand?: ";
    getline(cin, sampleString);
    cout << "What is the added hand?: ";
    getline(cin, newCard);

    Hand myHand;
    //transform everything to lower case
    transform(sampleString.begin(), sampleString.end(), sampleString.begin(), ::tolower);
    transform(newCard.begin(), newCard.end(), newCard.begin(), ::tolower);
    vector<string> hand = tokenizeStrings(sampleString, ",:", 1);

    // For each of the cards, we need to create cards out of them
    for (vector<string>::iterator _card = hand.begin(); _card != hand.end(); _card++)
        myHand.AddCard(new Card(*_card));
    myHand.sortHand();

    Card* swappableCard = new Card(newCard);

    cout << "Checking for a run with length " << RunLength << "\n";
    Card* swappedCard = myHand.CheckForRun(*swappableCard);
    outputWin(swappedCard);

    cout << "Checking for a set with length " << SetLength << "\n";
    swappedCard = myHand.CheckForSet(*swappableCard);
    outputWin(swappedCard);

    RunLength = 4;
    cout << "Checking for a run with length " << RunLength << "\n";
    swappedCard = myHand.CheckForRun(*swappableCard);
    outputWin(swappedCard);

    SetLength = 4;
    cout << "Checking for a set with length " << SetLength << "\n";
    swappedCard = myHand.CheckForSet(*swappableCard);
    outputWin(swappedCard);

    //Clean up
    delete swappableCard;
    myHand.cleanUp();

    return 0;
}
{% endhighlight %}

Here's a sample of an input and output:
<pre>What is the initial hand?: Two of Diamonds, Three of Diamonds, Four of Diamonds, Seven of Diamonds, Seven of Clubs, Seven of Hearts, Jack of Hearts
What is the added hand?: Five of Diamonds
Checking for a run with length 3
Swap the new card with seven of hearts to win!
Checking for a set with length 3
No possible winning hand.
Checking for a run with length 4
Swap the new card with seven of hearts to win!
Checking for a set with length 4
No possible winning hand.
</pre>

<span style="text-decoration:underline;"><strong>A brief explanation on the two checker methods</strong></span>

<em>Set Checker:</em>
Simply go through the hand and count the number of cards with the same value as the new card. If it exceeds 3 of 4, then you have a set. Then just go through the hand once more and swap with the first card that isn't the same value as the new card.

<em>Run Checker:
</em>This code is significantly more messy. Let's see. Go through each card in the (sorted) hand until you get to the same suit as the new card. (Aside: the sort method that I've implemented, sorts the hands in terms of values grouped with their individual suits). Then, depending on if we're checking for a 3 card or 4 card run, we create a temporary second set called a Run (which is essentially a vector of cards).
We insert the new card in, and then insert the next 2 to 3 cards in depending on the length of the run we're interested in. When we're doing this, and we encounter a card with a different suit than our new card, we know that a run isn't possible since we've hit a new suit in a sorted hand, so break out of the function. If we are successful in adding the right number of cards, we sort this mini hand. Then we subtract the largest value from the smallest value, and the result should be the length of the run we are interested in minus 1. So for instance, if we are interested in a run of 4 cards, and we have 3, 4, 5, 6 of the same suit, then 6 - 3 would give us 3. Now if this is the case, then we have successfully found a run!
To find a card we can remove from the hand, I use the brute force method. Which means going through the hand once again and as soon as I hit a card which is not in the mini-hand, I can discard that card.
<em>Clearly this method can be improved upon....</em>
