Coursera Data Science Capstone Report
========================================================
author: Emiel Schoenmakers
date: June 1st, 2016
autosize: true
part of Data Science Specialization![DS](jhuds-logo.png)

in cooperation with ![SK](swiftkey.png)

Capstone Objective
========================================================
The objective of the Capstone Project is to build a word prediction algorithm to show all skills learned during the Data Science Specialization. The final product is a working app which accepts (parts of) a sentence and predicts the next word.

- source of data is HC Corpora  (50k lines sampled from news(20k), blog(20k) and twitter (10k))
- load and clean the data
- perform exploratory analysis  (milestone report on RPubs)
- create predictive model       (resulting tables part of the app)
- create app and publish on shinyapps.io
- document using RPubs  (this slidedeck)

see slide 5 for links


The result: A Word-prediction App
========================================================
In this app you can enter some (English) text.
Using the last three words the next word is predicted. The best prediction is shown in text below the entered text. The wordcloud shows the top 5 suggestions (scaled with the score). Through the navbar two explanation pages can be accessed. Have fun!

![app](app.png)

The algorithm
========================================================
* <small> The ngrams (fourgram: "I went to the") split in 'outcome' (last word) and 'prediction' (first part). Ex: "I went to" = predictor, "the' = outcome of prediction
* If entered text has no valid 'predictor' look at predictor in shorter n-1gram. Ex: if "I went to" not found as predictor in 4grams look for "went to"-predictor in the tri-gram and subseq "to" in the bi-gram.
* The Katz Back-off formula used to calculate the probability of these lower ngrams to ensure total probability over possible terms = 1. 
$$P_{katz}(y|x)= 
\begin{cases} {{c^*(xy) \over c(x)} \quad \quad if c(x)>0} \\
{\alpha(x)P_{katz}(y) \quad otherwise} \\
\end{cases}$$
$$\alpha(x) = 1- \sum{c^*(xy) \over c(x)}$$
* Load time, responsiveness and performance (correct prediction) of the app optimezed by tuning lambda (0.5) and removing all fourgrams which occurred just once. This resulted in a 26% correct prediction on the test set. </small>

Reference
========================================================
* Source of the Data http://www.corpora.heliohost.org/index.html
* Katz Back-off model https://en.wikipedia.org/wiki/Katz%27s_back-off_model
* 50k lines sample size based on the plot on page 9 of this paper
http://research.microsoft.com/en-us/um/redmond/groups/srg/papers/2001-joshuago-tr72.pdf
* App available on https://emiels.shinyapps.io/wordprediction/
* Code available on https://github.com/emiels/DSP
* Milestone report including exploratory analysis: http://rpubs.com/emiels/DSP01
* Report available on: http://rpubs.com/emiels/DSCap
