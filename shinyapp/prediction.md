## How does this app get it's prediction?

This app uses the last three words to predict the next word.
Based on some 50000 lines of text from blogs, news and tweet's we have calculated
which word follows a certain word.
For example: If I enter "I went to the.." the app looks at "went to the" and predicts "public" as next word, with "next, point and mall" as alternatives.

From the input (blogs, news and tweets) we 
- got all 'four-grams' (possible combinations of words with a length of four)
- counted the frequency of these four-grams
- did the same for three-grams (length = 3) and bi-grams (length = 2)

Based on the input of the first three words the app searches the next words with the highest frequencies.
The answers from four-, tri- and bi-grams are combined and the top-5 is presented.

If no next words can be found (not in our prepared dictionary) 'the' is returned
as the most common word. This happens with words outside of our dictionary but also in case of spelling errors or foreign words.
