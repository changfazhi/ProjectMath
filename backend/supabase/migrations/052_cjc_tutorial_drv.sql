-- Migration 052: CJC 2022 JC2 H2 Math Tutorial — Discrete Random Variables (DISCUSSION only, 9 questions)
-- Source: TUTORIAL/STATS QN/6.3 Discrete Random Variable + solution.pdf, DISCUSSION section (pp.31-34);
--         worked solutions cross-checked against TUTORIAL/ STATS SOLUTIONS/6.3 2022 Discrete Random Variable DQ Solution.pdf.
-- REVIEW PROBLEMS deliberately excluded. Answers verified against the tutorial answer key (re-derived).
-- Provenance stripped: generic source 'H2 Math Tutorial (Discrete Random Variable)', inline exam tags removed.
-- IDs: prefix 'cc22' + topic-index '3' (stats file 6.3) + 3-digit Q# -> cc223001..cc223009. Topic bbbb0003.
-- Grading: clean scalar results graded (fractions 'exact', decimals 'range'); "show that" / "tabulate the
--          distribution" / distribution-in-terms-of-a-parameter parts left null (revealed). No DDL.

-- Q1: product of two tetrahedral dice
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc223001-0000-0000-0000-000000000000',
  'bbbb0003-0000-0000-0000-000000000000',
  1,
  $$Product of two tetrahedral dice$$,
  $$An unbiased die is in the form of a regular tetrahedron and has its faces numbered 1, 2, 3 and 4. When the die is thrown on to a horizontal table, the number on the face in contact with the table is noted. Two such dice are thrown and the score \(X\) is found by multiplying these numbers together. Obtain the probability distribution of \(X\) and derive the values of$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$The distribution of \(X\) (over the 16 equally likely ordered pairs): \(x=1,2,3,4,6,8,9,12,16\) with probabilities \(\frac{1}{16},\frac{2}{16},\frac{2}{16},\frac{3}{16},\frac{2}{16},\frac{2}{16},\frac{1}{16},\frac{2}{16},\frac{1}{16}\). (i) \(\mathrm{P}(X>8)=\frac{1+2+1}{16}=\frac14\). (ii) \(\mathrm{E}(X)=\frac{100}{16}=\frac{25}{4}\). (iii) \(\mathrm{E}(X^2)=\frac{900}{16}\), so \(\mathrm{Var}(X)=\frac{900}{16}-\left(\frac{25}{4}\right)^2=\frac{275}{16}\).$$,
  4,
  'H2 Math Tutorial (Discrete Random Variable)',
  $$[
  {"label": "dist", "prompt_latex": "Obtain the probability distribution of \\(X\\).", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "i", "prompt_latex": "\\(\\mathrm{P}(X>8)\\),", "correct_answer": "\\frac{1}{4}", "answer_type": "exact", "tolerance": null},
  {"label": "ii", "prompt_latex": "\\(\\mathrm{E}(X)\\),", "correct_answer": "\\frac{25}{4}", "answer_type": "exact", "tolerance": null},
  {"label": "iii", "prompt_latex": "\\(\\mathrm{Var}(X)\\).", "correct_answer": "\\frac{275}{16}", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);

-- Q2: disc and tetrahedral die
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc223002-0000-0000-0000-000000000000',
  'bbbb0003-0000-0000-0000-000000000000',
  2,
  $$Disc and tetrahedral die$$,
  $$An unbiased disc has a single dot marked on one side and two dots marked on the other side. A tetrahedral die has faces marked with a score of 1, 2, 3 and 4. The probability of getting a score of 1, 2, 3 and 4 is \(\frac15, p, \frac15\) and \(q\) respectively, where \(p, q\in[0,1]\). A game is played by throwing the disc and the die together. The random variable \(S\) is the sum of the score showing on the die and twice the number of dots showing on the disc.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$Since the die scores sum to 1, \(p+q=\frac35\). (i) \(\mathrm{P}(S=6)=\frac12(p+q)=\frac12\cdot\frac35=\frac{3}{10}\). (ii) \(\mathrm{P}(S=4)=\frac{p}{2}=\frac16\Rightarrow p=\frac13\), so \(q=\frac35-\frac13=\frac{4}{15}\). (iii) distribution of \(S\): \(s=3,4,5,6,7,8\) with probabilities \(\frac1{10},\frac16,\frac15,\frac3{10},\frac1{10},\frac2{15}\).$$,
  5,
  'H2 Math Tutorial (Discrete Random Variable)',
  $$[
  {"label": "i", "prompt_latex": "Find \\(\\mathrm{P}(S=6)\\).", "correct_answer": "\\frac{3}{10}", "answer_type": "exact", "tolerance": null},
  {"label": "ii", "prompt_latex": "Given that \\(\\mathrm{P}(S=4)=\\dfrac{1}{6}\\), calculate the values of \\(p\\) and \\(q\\).", "correct_answer": "p = 1/3, q = 4/15", "answer_type": "exact", "tolerance": null, "answers": [
    {"key": "p", "label": "p", "correct_answer": "\\frac{1}{3}", "answer_type": "exact", "tolerance": null},
    {"key": "q", "label": "q", "correct_answer": "\\frac{4}{15}", "answer_type": "exact", "tolerance": null}
  ]},
  {"label": "iii", "prompt_latex": "Find the probability distribution of \\(S\\).", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);

-- Q3: game with four cards
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc223003-0000-0000-0000-000000000000',
  'bbbb0003-0000-0000-0000-000000000000',
  2,
  $$Card game with a scoring rule$$,
  $$A game is played with a set of 4 cards, each distinctly numbered 1, 2, 3 and 4. A player randomly picks a pair of cards without replacement. If the sum of the cards' numbers is an odd number, the sum is the player's score. If the sum of the two cards' numbers is an even number, the player randomly picks a third card from the remaining cards. The square of the third card's number is the player's score.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$The 6 pairs are equally likely. Odd-sum pairs give scores \(3,5,5,7\); even-sum pairs \(\{1,3\},\{2,4\}\) lead to a third card whose square is the score. (i) score 4 needs \(\{1,3\}\) then card 2: \(\frac16\cdot\frac12=\frac{1}{12}\). (ii) distribution: \(s=1,3,4,5,7,9,16\) with probabilities \(\frac1{12},\frac16,\frac1{12},\frac13,\frac16,\frac1{12},\frac1{12}\); \(\mathrm{E}(S)=\frac{70}{12}=\frac{35}{6}\). (iii) given three cards were drawn, the score is the third card squared; \(\mathrm{P}(\text{score}<5\mid\text{three cards})=\frac12\).$$,
  6,
  'H2 Math Tutorial (Discrete Random Variable)',
  $$[
  {"label": "i", "prompt_latex": "Find the probability that a player obtains a score of 4.", "correct_answer": "\\frac{1}{12}", "answer_type": "exact", "tolerance": null},
  {"label": "ii", "prompt_latex": "Find the probability distribution of a player's score, \\(S\\). Hence, find the expected score of a player.", "correct_answer": "\\frac{35}{6}", "answer_type": "exact", "tolerance": null},
  {"label": "iii", "prompt_latex": "Find the probability that a player obtains a score lower than 5, given that he draws three cards.", "correct_answer": "\\frac{1}{2}", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);

-- Q4: people between two friends in a queue
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc223004-0000-0000-0000-000000000000',
  'bbbb0003-0000-0000-0000-000000000000',
  2,
  $$People between two friends in a queue$$,
  $$Alex and his friend stand randomly in a queue with 3 other people. The random variable \(X\) is the number of people standing between Alex and his friend.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$Among the \(5!\) equally likely orders (equivalently the \(\binom{5}{2}=10\) position-pairs for the two friends): (i) exactly 2 between them uses positions \((1,4),(2,5)\): \(\frac{2\cdot 2}{20}=0.2\). (ii) distribution \(x=0,1,2,3\) with probabilities \(0.4,0.3,0.2,0.1\). (iii) \(\mathrm{E}(X)=0(0.4)+1(0.3)+2(0.2)+3(0.1)=1\); \(\mathrm{E}((X-1)^2)=\mathrm{Var}(X)=\mathrm{E}(X^2)-1^2=2-1=1\).$$,
  4,
  'H2 Math Tutorial (Discrete Random Variable)',
  $$[
  {"label": "i", "prompt_latex": "Show that \\(\\mathrm{P}(X=2)=0.2\\).", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ii", "prompt_latex": "Tabulate the probability distribution of \\(X\\).", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "iii", "prompt_latex": "Find \\(\\mathrm{E}(X)\\) and \\(\\mathrm{E}((X-1)^2)\\). Hence find \\(\\mathrm{Var}(X)\\).", "correct_answer": "E(X) = 1, E((X-1)^2) = 1, Var(X) = 1", "answer_type": "exact", "tolerance": null, "answers": [
    {"key": "EX", "label": "\\mathrm{E}(X)", "correct_answer": "1", "answer_type": "exact", "tolerance": null},
    {"key": "E1", "label": "\\mathrm{E}((X-1)^2)", "correct_answer": "1", "answer_type": "exact", "tolerance": null},
    {"key": "VarX", "label": "\\mathrm{Var}(X)", "correct_answer": "1", "answer_type": "exact", "tolerance": null}
  ]}
]$$::jsonb
);

-- Q5: probability function in terms of theta
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc223005-0000-0000-0000-000000000000',
  'bbbb0003-0000-0000-0000-000000000000',
  2,
  $$Probability function with a parameter$$,
  $$The probability function of \(X\) is given by \(\mathrm{P}(X=x)=(2x-1)\theta\) for \(x=1,2,3\); \(\mathrm{P}(X=4)=k\); and \(\mathrm{P}(X=x)=0\) otherwise, where \(0<\theta<\dfrac{1}{9}\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) Probabilities sum to 1: \(\theta+3\theta+5\theta+k=1\Rightarrow k=1-9\theta\); distribution \(x=1,2,3,4\) with probabilities \(\theta,3\theta,5\theta,1-9\theta\). (ii) \(\mathrm{E}(X)=\theta+6\theta+15\theta+4(1-9\theta)=4-14\theta\); \(\mathrm{E}(X^2)=\theta+12\theta+45\theta+16(1-9\theta)=16-86\theta\), so \(\mathrm{Var}(X)=16-86\theta-(4-14\theta)^2=26\theta-196\theta^2\). (iii) \(\mathrm{Var}(Y)=b^2\mathrm{Var}(X)=\frac13 b^2\Rightarrow \mathrm{Var}(X)=\frac13\); solving \(196\theta^2-26\theta+\frac13=0\) with \(\theta<\frac19\) gives \(\theta=0.0144\).$$,
  6,
  'H2 Math Tutorial (Discrete Random Variable)',
  $$[
  {"label": "i", "prompt_latex": "Show that \\(k=1-9\\theta\\). Find, in terms of \\(\\theta\\), the probability distribution of \\(X\\).", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ii", "prompt_latex": "Find \\(\\mathrm{E}(X)\\) in terms of \\(\\theta\\) and hence show that \\(\\mathrm{Var}(X)=26\\theta-196\\theta^2\\).", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "iii", "prompt_latex": "The random variable \\(Y\\) is related to \\(X\\) by the formula \\(Y=a+bX\\), where \\(a\\) and \\(b\\) are non-zero constants. Given that \\(\\mathrm{Var}(Y)=\\dfrac{1}{3}b^2\\), find the value of \\(\\theta\\).", "correct_answer": "0.0144", "answer_type": "range", "tolerance": 0.0001}
]$$::jsonb
);

-- Q6: two cards drawn from a mixed pack
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc223006-0000-0000-0000-000000000000',
  'bbbb0003-0000-0000-0000-000000000000',
  2,
  $$Sum of two cards from a mixed pack$$,
  $$Two cards are drawn at random without replacement from a pack of cards consisting of two cards numbered 3, three cards numbered 4 and \(n\) cards numbered 5. The random variable \(X\) is defined as the sum of the scores on the two cards.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) With \(\binom{n+5}{2}=\frac{(n+4)(n+5)}{2}\) equally likely pairs, \(X\in\{6,7,8,9,10\}\) with probabilities \(\frac{2}{(n+4)(n+5)},\frac{12}{(n+4)(n+5)},\frac{4n+6}{(n+4)(n+5)},\frac{6n}{(n+4)(n+5)},\frac{n(n-1)}{(n+4)(n+5)}\). (ii) \(\mathrm{E}(X)=\dfrac{10n+36}{n+5}\), so \(a=10,\ b=36\). (iii) \(\mathrm{Var}(X)=\dfrac{g(n)}{(n+5)^2(n+4)}\) with \(g(n)=22n^2+78n+36\).$$,
  6,
  'H2 Math Tutorial (Discrete Random Variable)',
  $$[
  {"label": "i", "prompt_latex": "Determine the probability distribution of \\(X\\).", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ii", "prompt_latex": "Show that \\(\\mathrm{E}(X)=\\dfrac{an+b}{n+5}\\), where \\(a\\) and \\(b\\) are constants to be determined.", "correct_answer": "a = 10, b = 36", "answer_type": "exact", "tolerance": null, "answers": [
    {"key": "a", "label": "a", "correct_answer": "10", "answer_type": "exact", "tolerance": null},
    {"key": "b", "label": "b", "correct_answer": "36", "answer_type": "exact", "tolerance": null}
  ]},
  {"label": "iii", "prompt_latex": "Show that \\(\\mathrm{Var}(X)=\\dfrac{g(n)}{(n+5)^2(n+4)}\\) where \\(g(n)\\) is a quadratic polynomial to be determined.", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);

-- Q7: coin-tossing game
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc223007-0000-0000-0000-000000000000',
  'bbbb0003-0000-0000-0000-000000000000',
  3,
  $$Coin-tossing game$$,
  $$A player tosses two coins in a game. The game ends if the exposed faces of the two coins are different. Otherwise, the two coins and another coin are tossed and the game ends after the second toss. Let \(X\) be the total number of heads exposed in a game.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) If the two coins match the game continues with a third toss of 3 coins. \(X=2\) via HH (prob \(\frac14\)) then 0 more heads \(\left(\frac18\right)\): \(\frac1{32}\); or TT (prob \(\frac14\)) then 2 more heads \(\left(\frac38\right)\): \(\frac3{32}\). Total \(\frac1{32}+\frac3{32}=\frac18\). (ii) distribution \(x=0,1,2,3,4,5\) with probabilities \(\frac1{32},\frac{19}{32},\frac18,\frac18,\frac3{32},\frac1{32}\). (iii) \(\mathrm{E}(X)=\frac{56}{32}=\frac74\); for a fair game the payment equals the expected receipt, so \(k=\frac74\).$$,
  5,
  'H2 Math Tutorial (Discrete Random Variable)',
  $$[
  {"label": "i", "prompt_latex": "Show that \\(\\mathrm{P}(X=2)=\\dfrac{1}{8}\\).", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ii", "prompt_latex": "Find the probability distribution of \\(X\\).", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "iii", "prompt_latex": "If the player pays $k for each game and the amount of money he received in $ is equal to the number of heads obtained, find the value of \\(k\\) for the game to be fair.", "correct_answer": "\\frac{7}{4}", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);

-- Q8: biased tetrahedral die game
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc223008-0000-0000-0000-000000000000',
  'bbbb0003-0000-0000-0000-000000000000',
  3,
  $$Biased tetrahedral die game$$,
  $$A biased tetrahedral (4-sided) die has its faces numbered '−1', '0', '2' and '3'. It is thrown onto a table and the random variable \(X\) denotes the number on the face in contact with the table. The probability distribution of \(X\) is \(\mathrm{P}(X=-1)=\frac18,\ \mathrm{P}(X=0)=\frac12,\ \mathrm{P}(X=2)=\frac18,\ \mathrm{P}(X=3)=\frac14\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) \(\mathrm{P}(Y=2)\) sums the pairs \((-1,3),(3,-1),(0,2),(2,0)\): \(\frac1{32}+\frac1{32}+\frac1{16}+\frac1{16}=\frac{3}{16}\). (ii) \(\mathrm{P}(\max=-1)=\left(\frac18\right)^2=\frac1{64}\) pays \$16. Sum prime means sum \(\in\{2,3,5\}\): \(\mathrm{P}=\frac{3}{16}+\frac14+\frac1{16}=\frac12\), paying \$3. Expected receipt \(=16\cdot\frac1{64}+3\cdot\frac12=\$1.75\); subtracting the \$2 stake, the expected gain is \(-\$0.25\).$$,
  4,
  'H2 Math Tutorial (Discrete Random Variable)',
  $$[
  {"label": "i", "prompt_latex": "The random variable \\(Y\\) is defined by \\(X_1+X_2\\), where \\(X_1\\) and \\(X_2\\) are 2 independent observations of \\(X\\). Show that \\(\\mathrm{P}(Y=2)=\\dfrac{3}{16}\\).", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ii", "prompt_latex": "In a game, a player pays $2 to throw two such biased tetrahedral dice simultaneously on a table. For each die, the number on the face in contact with the table is the score of the die. The player receives $16 if the maximum of the two scores is −1, and receives $3 if the sum of the two scores is prime. For all other cases, the player receives nothing. Find the player's expected gain in the game.", "correct_answer": "-0.25", "answer_type": "range", "tolerance": 0.005}
]$$::jsonb
);

-- Q9: two dice of different bias
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc223009-0000-0000-0000-000000000000',
  'bbbb0003-0000-0000-0000-000000000000',
  3,
  $$Combined score of three cubical dice$$,
  $$A cubical die has three faces marked with a '1', two faces marked with a '2' and one face marked with a '3'. A second cubical die has one face marked '1', two faces marked '2' and three faces marked '3'. Two of the first type of die and one of the second type are thrown together, and \(X\) denotes the total score obtained. Denote the expectation and variance of \(X\) by \(\mu\) and \(\sigma^2\) respectively.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$First die: \(\mathrm{E}=1\cdot\frac12+2\cdot\frac13+3\cdot\frac16=\frac53\), \(\mathrm{Var}=\frac{10}{3}-\left(\frac53\right)^2=\frac59\). Second die: \(\mathrm{E}=1\cdot\frac16+2\cdot\frac13+3\cdot\frac12=\frac73\), \(\mathrm{Var}=6-\left(\frac73\right)^2=\frac59\). (i) \(\sigma^2=2\cdot\frac59+\frac59=\frac{15}{9}=\frac53\). (ii) \(\mu=\frac{17}{3}\), \(2\sigma=2\sqrt{\frac53}\approx2.58\); only \(X=3\) and \(X=9\) satisfy \(|X-\mu|>2\sigma\): \(\mathrm{P}=\frac{1}{24}+\frac{1}{72}=\frac{1}{18}\).$$,
  6,
  'H2 Math Tutorial (Discrete Random Variable)',
  $$[
  {"label": "a", "prompt_latex": "Calculate the expectation and variance of the score obtained when the first die (three '1', two '2', one '3') is thrown once.", "correct_answer": "E = 5/3, Var = 5/9", "answer_type": "exact", "tolerance": null, "answers": [
    {"key": "E", "label": "\\mathrm{E}", "correct_answer": "\\frac{5}{3}", "answer_type": "exact", "tolerance": null},
    {"key": "Var", "label": "\\mathrm{Var}", "correct_answer": "\\frac{5}{9}", "answer_type": "exact", "tolerance": null}
  ]},
  {"label": "b", "prompt_latex": "Deduce the expectation and variance of the score obtained in one throw of the second die (one '1', two '2', three '3').", "correct_answer": "E = 7/3, Var = 5/9", "answer_type": "exact", "tolerance": null, "answers": [
    {"key": "E", "label": "\\mathrm{E}", "correct_answer": "\\frac{7}{3}", "answer_type": "exact", "tolerance": null},
    {"key": "Var", "label": "\\mathrm{Var}", "correct_answer": "\\frac{5}{9}", "answer_type": "exact", "tolerance": null}
  ]},
  {"label": "i", "prompt_latex": "Show that \\(\\sigma^2=\\dfrac{5}{3}\\).", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ii", "prompt_latex": "Show that \\(\\mathrm{P}(|X-\\mu|>2\\sigma)=\\dfrac{1}{18}\\).", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);
