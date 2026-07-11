-- Migration 053: CJC 2022 JC2 H2 Math Tutorial — Binomial Distribution (DISCUSSION only, 10 questions)
-- Source: TUTORIAL/STATS QN/6.4 Binomial Distribution + solution.pdf, DISCUSSION section (pp.29-31);
--         worked solutions cross-checked against TUTORIAL/ STATS SOLUTIONS/6.4 2022 Binomial Distribution DQ Solution.pdf.
-- REVIEW PROBLEMS and Self-Practice deliberately excluded. Answers verified against the tutorial answer key.
-- Provenance stripped: generic source 'H2 Math Tutorial (Binomial Distribution)', inline exam tags removed.
-- IDs: prefix 'cc22' + topic-index '4' (stats file 6.4) + 3-digit Q# -> cc224001..cc22400a. Topic bbbb0007.
-- Grading: GC probabilities graded 'range' (3-4 s.f.); integer n/mode graded 'exact'; "state assumptions" /
--          "write down the distribution" / set-of-values / expected-frequency-table parts left null (revealed). No DDL.

-- Q1: fast-food burger purchases
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc224001-0000-0000-0000-000000000000',
  'bbbb0007-0000-0000-0000-000000000000',
  1,
  $$Fast-food burger purchases$$,
  $$From past records, the purchases at a fast food outlet show that 63% of customers buy a burger. This figure is made up of 30% who buy a beef burger, 24% who buy a fish burger and 9% who buy a chicken burger. No one buys more than one burger. Find the probability that, in a random sample of 27 customers,$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$(i) \(X\sim B(27,0.63)\), \(\mathrm{P}(X\ge23)=0.0108\). (ii) "not fish" \(\sim B(27,0.76)\), \(\mathrm{P}(<26)=\mathrm{P}(\le25)=0.994\). (iii) "beef or chicken" \(\sim B(27,0.39)\), \(\mathrm{P}(>15)=0.0263\). (iv) "no burger" \(\sim B(27,0.37)\), \(\mathrm{P}(\ge8)=0.839\). (v) chicken \(\sim B(27,0.09)\); \(\mathrm{P}(C=4\mid C<6)=\dfrac{\mathrm{P}(C=4)}{\mathrm{P}(C\le5)}=0.136\).$$,
  5,
  'H2 Math Tutorial (Binomial Distribution)',
  $$[
  {"label": "i", "prompt_latex": "at least 23 customers buy a burger,", "correct_answer": "0.0108", "answer_type": "range", "tolerance": 0.0005},
  {"label": "ii", "prompt_latex": "less than 26 customers do not buy a fish burger,", "correct_answer": "0.994", "answer_type": "range", "tolerance": 0.001},
  {"label": "iii", "prompt_latex": "more than 15 customers buy either a beef or a chicken burger,", "correct_answer": "0.0263", "answer_type": "range", "tolerance": 0.0005},
  {"label": "iv", "prompt_latex": "no less than 8 customers do not buy a burger,", "correct_answer": "0.839", "answer_type": "range", "tolerance": 0.001},
  {"label": "v", "prompt_latex": "exactly 4 customers buy a chicken burger given that fewer than 6 customers buy a chicken burger.", "correct_answer": "0.136", "answer_type": "range", "tolerance": 0.001}
]$$::jsonb
);

-- Q2: survey on consumer protection
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc224002-0000-0000-0000-000000000000',
  'bbbb0007-0000-0000-0000-000000000000',
  1,
  $$Survey on consumer protection$$,
  $$A survey found that 95% of the respondents would favour greater consumer protection.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) \(X\sim B(30,0.95)\), \(\mathrm{P}(X=25)=0.0124\). (ii) For \(Y\sim B(n,0.95)\) we need \(\mathrm{P}(Y\ge40)>0.980\); increasing \(n\), the least value satisfying this is \(n=46\).$$,
  4,
  'H2 Math Tutorial (Binomial Distribution)',
  $$[
  {"label": "i", "prompt_latex": "Find the probability that out of 30 respondents, 25 of them would favour greater consumer protection.", "correct_answer": "0.0124", "answer_type": "range", "tolerance": 0.0005},
  {"label": "ii", "prompt_latex": "Find the least number of respondents surveyed such that the probability that at least 40 of them would favour greater consumer protection exceeds 0.980.", "correct_answer": "46", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);

-- Q3: B(16, p) with given variance
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc224003-0000-0000-0000-000000000000',
  'bbbb0007-0000-0000-0000-000000000000',
  1,
  $$Binomial with a given variance$$,
  $$The random variable \(X\sim B(16,p)\) where \(p<0.5\). If the variance of \(X\) is 3.36, find the value of \(p\). Find also the probability that \(X\) is less than the mean.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$\(\mathrm{Var}(X)=16p(1-p)=3.36\Rightarrow p(1-p)=0.21\Rightarrow p=0.3\) or \(0.7\); since \(p<0.5\), \(p=0.3\). Mean \(=16(0.3)=4.8\), so \(\mathrm{P}(X<4.8)=\mathrm{P}(X\le4)=0.450\).$$,
  4,
  'H2 Math Tutorial (Binomial Distribution)',
  $$[
  {"label": "i", "prompt_latex": "Find the value of \\(p\\).", "correct_answer": "0.3", "answer_type": "exact", "tolerance": null},
  {"label": "ii", "prompt_latex": "Find the probability that \\(X\\) is less than the mean.", "correct_answer": "0.450", "answer_type": "range", "tolerance": 0.001}
]$$::jsonb
);

-- Q4: medical treatment side-effect
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc224004-0000-0000-0000-000000000000',
  'bbbb0007-0000-0000-0000-000000000000',
  2,
  $$Medical-treatment side-effect$$,
  $$On average, 30% of the patients having a certain medical treatment experience severe headache. A random sample of 12 patients is given the treatment.$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$Let \(X\sim B(12,0.3)\). (i) assume patients are independent and the probability of a headache is constant at 0.3. (ii) \(\mathrm{P}(X<3)=\mathrm{P}(X\le2)=0.253\). (iii) For \(Y\sim B(5,0.253)\), \(\mathrm{P}(Y=2)=0.267\).$$,
  4,
  'H2 Math Tutorial (Binomial Distribution)',
  $$[
  {"label": "i", "prompt_latex": "Write down the distribution of the number of patients who experience severe headache, and state an assumption for the choice of the distribution.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ii", "prompt_latex": "Find the probability that fewer than 3 patients experience severe headache.", "correct_answer": "0.253", "answer_type": "range", "tolerance": 0.001},
  {"label": "iii", "prompt_latex": "Five random samples of 12 patients are given the treatment. Find the probability that two of these five samples have fewer than 3 patients who experience severe headache.", "correct_answer": "0.267", "answer_type": "range", "tolerance": 0.001}
]$$::jsonb
);

-- Q5: shooting competition scoring
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc224005-0000-0000-0000-000000000000',
  'bbbb0007-0000-0000-0000-000000000000',
  2,
  $$Shooting-competition scoring$$,
  $$Teams of 8 people enter a shooting competition. Each member of a team takes a shot at the target. The number of points scored by a team is obtained by \(2x\) where \(x\) is the number of shots that hit the target. For a particular team, each member of the team independently has a probability of 0.75 of hitting the target.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$Let \(x\sim B(8,0.75)\). (i) points \(>6\Leftrightarrow 2x>6\Leftrightarrow x\ge4\): \(\mathrm{P}(x\ge4)=0.973\). (ii) the most likely number of hits is the mode of \(B(8,0.75)\), which is 6, so the most likely score is \(2(6)=12\).$$,
  4,
  'H2 Math Tutorial (Binomial Distribution)',
  $$[
  {"label": "i", "prompt_latex": "Find the probability that a randomly chosen team scores more than 6 points.", "correct_answer": "0.973", "answer_type": "range", "tolerance": 0.001},
  {"label": "ii", "prompt_latex": "Find the number of points that a team is most likely to score.", "correct_answer": "12", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);

-- Q6: contacting friends by telephone
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc224006-0000-0000-0000-000000000000',
  'bbbb0007-0000-0000-0000-000000000000',
  2,
  $$Contacting friends by telephone$$,
  $$When I try to contact (by telephone) any of my friends in the evening, I know that on average the probability that I succeed is 0.7. On one evening I attempt to contact a fixed number, \(n\), of different friends. If I do not succeed with a particular friend, I do not attempt to contact that friend again that evening. The number of friends whom I succeed in contacting is the random variable \(R\).$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$(i) Model \(R\sim B(n,0.7)\): each contact attempt is independent, and the probability of success is constant at 0.7. (ii) In reality successes may not be independent (e.g. friends are together, or a busy period lowers everyone's availability), so the constant-probability / independence assumption may fail. (iii) With \(n=8\), \(R\sim B(8,0.7)\), \(\mathrm{P}(R\ge6)=0.552\).$$,
  4,
  'H2 Math Tutorial (Binomial Distribution)',
  $$[
  {"label": "i", "prompt_latex": "State, in the context of this question, two assumptions needed to model \\(R\\) by a binomial distribution.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ii", "prompt_latex": "Explain why one of the assumptions stated in part (i) may not hold in this context.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "iii", "prompt_latex": "Assume now that these assumptions do in fact hold. Given that \\(n=8\\), find the probability that \\(R\\) is at least 6.", "correct_answer": "0.552", "answer_type": "range", "tolerance": 0.001}
]$$::jsonb
);

-- Q7: supermarket credit-card payments (single answer)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  'cc224007-0000-0000-0000-000000000000',
  'bbbb0007-0000-0000-0000-000000000000',
  2,
  $$Supermarket credit-card payments$$,
  $$Customers at a supermarket pay for their purchases either by cash or credit card. The probability of a randomly chosen customer paying by credit card is 0.3. Find the probability that, on a randomly chosen day, there are more than 6 customers among the first 20 customers who pay by credit card and the fifth customer is the second customer who does so.$$,
  'range',
  $$0.0598$$,
  0.0005,
  $$"Fifth customer is the second to pay by card" means exactly 1 of the first 4 pays by card and the 5th pays by card: \(\binom{4}{1}(0.3)(0.7)^3\times0.3\). Given these 2 successes in the first 5, we need more than 6 in the first 20 overall, i.e. at least 5 more among customers 6–20 (\(\sim B(15,0.3)\), \(\mathrm{P}(\ge5)\)). Multiplying: \(0.0598\).$$,
  4,
  'H2 Math Tutorial (Binomial Distribution)'
);

-- Q8: rotten peaches in boxes
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc224008-0000-0000-0000-000000000000',
  'bbbb0007-0000-0000-0000-000000000000',
  3,
  $$Rotten peaches in boxes$$,
  $$A harvester packs peaches in boxes of \(m\) peaches each. On average, \(100p\%\) of the peaches are rotten. The total number of rotten peaches in 4 randomly selected boxes has a mean of 3 and variance of 2.91. A box is rejected if there are at least 2 rotten peaches in the box.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$Total rotten in 4 boxes \(\sim B(4m,p)\): \(4mp=3\) and \(4mp(1-p)=2.91\Rightarrow 1-p=0.97\Rightarrow p=0.03\), then \(m=25\). Per box \(X\sim B(25,0.03)\), \(\mathrm{P}(X\ge2)=1-\mathrm{P}(X\le1)=0.172\). (iii) Among the first 9 boxes exactly 2 are rejected and the 10th is the third rejected: \(\binom{9}{2}(0.172)^2(0.828)^7(0.172)=0.0489\). (iv) For \(B(n,0.172)\), require \(\mathrm{P}(<3)<0.1\); the least \(n\) is 30.$$,
  6,
  'H2 Math Tutorial (Binomial Distribution)',
  $$[
  {"label": "i", "prompt_latex": "State, in context, two assumptions needed for the number of rotten peaches in a box to be well modelled by a binomial distribution.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ii", "prompt_latex": "Find \\(m\\) and \\(p\\). Hence, show that the probability that a box of peaches is rejected is approximately 0.172.", "correct_answer": "m = 25, p = 0.03", "answer_type": "exact", "tolerance": null, "answers": [
    {"key": "m", "label": "m", "correct_answer": "25", "answer_type": "exact", "tolerance": null},
    {"key": "p", "label": "p", "correct_answer": "0.03", "answer_type": "exact", "tolerance": null}
  ]},
  {"label": "iii", "prompt_latex": "Ten boxes of peaches are selected at random for a quality check. Find the probability that the last box to be selected is the third one to be rejected.", "correct_answer": "0.0489", "answer_type": "range", "tolerance": 0.0005},
  {"label": "iv", "prompt_latex": "It is given that the probability that fewer than 3 out of \\(n\\) randomly chosen boxes of peaches are rejected is less than 0.1. Write down an inequality involving \\(n\\) and find the least possible value of \\(n\\).", "correct_answer": "30", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);

-- Q9: bag of numbered balls game
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc224009-0000-0000-0000-000000000000',
  'bbbb0007-0000-0000-0000-000000000000',
  3,
  $$Bag of numbered balls game$$,
  $$A bag contains two balls numbered 3, \(n\) balls numbered 2 and three balls numbered 1. A player picks two balls at random from the bag at the same time. If the difference between the numbers on the two balls is 2, the player receives $6. If the difference between the numbers on the two balls is 1, the player does not receive or lose any money. If the numbers on the two balls are the same, the player loses $1.$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$(i) The expected receipt is positive for \(n\) up to a maximum, and the largest \(n\) for which the player still expects to receive money is 8. (ii) With \(n=8\), counting pairs (total \(\binom{13}{2}=78\)) that give the same number: \(\binom{2}{2}+\binom{8}{2}+\binom{3}{2}=1+28+3=32\), so \(\mathrm{P}(\text{lose})=\frac{32}{78}=\frac{16}{39}\). (iii) \(W\sim B\!\left(50,\frac{16}{39}\right)\), \(\mathrm{P}(W\ge20)=0.611\). (iv) \(\mathrm{P}(W=r)>0.1\) for \(r\in\{19,20,21,22\}\).$$,
  6,
  'H2 Math Tutorial (Binomial Distribution)',
  $$[
  {"label": "i", "prompt_latex": "Show that the largest value of \\(n\\) such that the player is expected to receive money from this game is 8.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ii", "prompt_latex": "For the rest of this question, take the value of \\(n\\) to be 8. Show that the probability that a player loses money in a game is \\(\\dfrac{16}{39}\\).", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "iii", "prompt_latex": "Victoria plays this game 50 times. Find the probability that she lost money for at least 20 games.", "correct_answer": "0.611", "answer_type": "range", "tolerance": 0.001},
  {"label": "iv", "prompt_latex": "The probability that Victoria loses money in \\(r\\) games is more than 0.1. Find the set of values of \\(r\\).", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);

-- Q10: fitting a binomial model to experimental data
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc22400a-0000-0000-0000-000000000000',
  'bbbb0007-0000-0000-0000-000000000000',
  3,
  $$Fitting a binomial model to data$$,
  $$In an experiment, a biased coin is tossed \(n\) times and the number of 'heads' obtained is recorded. 80 experiments were conducted and the results are shown in the table (number of heads : frequency): 0 : 7, 1 : 21, 2 : 26, 3 : 18, 4 : 7, 5 : 1, more than 5 : 0.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(a) \(\bar{x}=\frac{160}{80}=2\); \(\sum fx^2=424\), \(\text{Var}=\frac{424}{80}-2^2=1.3\), s.d. \(=1.14\). (b) Matching a binomial: \(np=2\) and \(np(1-p)=1.3\Rightarrow 1-p=0.65\), \(p=0.350\); \(n\approx6\). (c) Using \(B(6,0.35)\), expected frequencies \(\approx6.03,19.5,26.2,18.8,7.61,1.64,0.147\); these are reasonably close to the observed frequencies, so the binomial model is suitable.$$,
  4,
  'H2 Math Tutorial (Binomial Distribution)',
  $$[
  {"label": "a", "prompt_latex": "Calculate the mean and standard deviation of the data.", "correct_answer": "mean 2, s.d. 1.14", "answer_type": "exact", "tolerance": null, "answers": [
    {"key": "mean", "label": "mean", "correct_answer": "2", "answer_type": "exact", "tolerance": null},
    {"key": "sd", "label": "s.d.", "correct_answer": "1.14", "answer_type": "range", "tolerance": 0.005}
  ]},
  {"label": "b", "prompt_latex": "By comparing the answer found above with those expected for a binomial distribution, estimate \\(n\\) and the probability of getting a 'head' with a toss of the coin, \\(p\\).", "correct_answer": "n = 6, p = 0.350", "answer_type": "exact", "tolerance": null, "answers": [
    {"key": "n", "label": "n", "correct_answer": "6", "answer_type": "exact", "tolerance": null},
    {"key": "p", "label": "p", "correct_answer": "0.350", "answer_type": "range", "tolerance": 0.005}
  ]},
  {"label": "c", "prompt_latex": "Using a binomial model with parameters \\(n\\) and \\(p\\) found above, calculate the expected frequencies for 0, 1, 2, …, \\(n\\) number of 'heads' and state, giving a reason, whether the binomial distribution is a suitable model.", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);
