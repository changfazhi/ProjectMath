-- Migration 055: CJC 2022 JC2 H2 Math Tutorial — Sampling and Estimation Theory (DISCUSSION only, 8 questions)
-- Source: TUTORIAL/STATS QN/6.6 Sampling _ Estimation Theory + solution.pdf, DISCUSSION section (pp.25-27);
--         worked solutions cross-checked against TUTORIAL/ STATS SOLUTIONS/6.6 2022 Sampling _ Estimation Theory DQ Solution.pdf.
-- REVIEW PROBLEMS deliberately excluded. Answers verified against the tutorial answer key (re-derived).
-- Provenance stripped: generic source 'H2 Math Tutorial (Sampling and Estimation Theory)', inline exam tags removed.
-- IDs: prefix 'cc22' + topic-index '6' (stats file 6.6) + 3-digit Q# -> cc226001..cc226008. Topic bbbb0004.
-- Grading: unbiased estimates + sample-mean probabilities graded; least-sample-size counts graded 'exact';
--          "state a CLT condition" / "explain a random sample" / show-that + distribution parts left null. No DDL.

-- Q1: unbiased estimates from a frequency table
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc226001-0000-0000-0000-000000000000',
  'bbbb0004-0000-0000-0000-000000000000',
  1,
  $$Unbiased estimates from a frequency table$$,
  $$The diameters, in mm, of 80 rods selected at random from a large consignment are summarised in the table (diameter to nearest mm : number of rods): 11 : 3, 12 : 22, 13 : 31, 14 : 20, 15 : 4. Use two different methods to find the unbiased estimates for the population mean and variance of the diameter of the rods in the consignment.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$\(\sum fx=1040\), so \(\bar{x}=\frac{1040}{80}=13\). \(\sum fx^2=13590\), so \(s^2=\frac{1}{79}\left(13590-\frac{1040^2}{80}\right)=\frac{70}{79}=0.886\).$$,
  4,
  'H2 Math Tutorial (Sampling and Estimation Theory)',
  $$[
  {"label": "mean-var", "prompt_latex": "Find the unbiased estimates of the population mean and variance.", "correct_answer": "mean 13, variance 0.886", "answer_type": "exact", "tolerance": null, "answers": [
    {"key": "mean", "label": "unbiased mean", "correct_answer": "13", "answer_type": "exact", "tolerance": null},
    {"key": "var", "label": "unbiased variance", "correct_answer": "0.886", "answer_type": "range", "tolerance": 0.005}
  ]}
]$$::jsonb
);

-- Q2: unbiased estimates from summary statistics
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc226002-0000-0000-0000-000000000000',
  'bbbb0004-0000-0000-0000-000000000000',
  1,
  $$Unbiased estimates from summary statistics$$,
  $$Find the unbiased estimate of the population mean and variance from which each of the following samples is drawn:$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(a) \(\bar{x}=\frac{15508}{100}=155.08\); \(s^2=\frac{1}{99}\left(2413891-\frac{15508^2}{100}\right)=90.0\). (b) \(\bar{t}=36.9+\frac{-12}{40}=36.6\); \(s^2=\frac{1}{39}\left(79.21-\frac{(-12)^2}{40}\right)=1.94\).$$,
  4,
  'H2 Math Tutorial (Sampling and Estimation Theory)',
  $$[
  {"label": "a", "prompt_latex": "\\(\\sum x=15508,\\ \\sum x^2=2413891\\) and \\(n=100\\).", "correct_answer": "mean 155.08, variance 90.0", "answer_type": "exact", "tolerance": null, "answers": [
    {"key": "mean", "label": "unbiased mean", "correct_answer": "155.08", "answer_type": "range", "tolerance": 0.05},
    {"key": "var", "label": "unbiased variance", "correct_answer": "90.0", "answer_type": "range", "tolerance": 0.1}
  ]},
  {"label": "b", "prompt_latex": "\\(\\sum(t-36.9)=-12,\\ \\sum(t-36.9)^2=79.21\\) and \\(n=40\\).", "correct_answer": "mean 36.6, variance 1.94", "answer_type": "exact", "tolerance": null, "answers": [
    {"key": "mean", "label": "unbiased mean", "correct_answer": "36.6", "answer_type": "range", "tolerance": 0.05},
    {"key": "var", "label": "unbiased variance", "correct_answer": "1.94", "answer_type": "range", "tolerance": 0.01}
  ]}
]$$::jsonb
);

-- Q3: sample mean of a sample of size 50
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc226003-0000-0000-0000-000000000000',
  'bbbb0004-0000-0000-0000-000000000000',
  1,
  $$Sample mean of a sample of size 50$$,
  $$A random sample of size 50 is taken from each of the following distributions. Find the probability that the sample mean is less than 4.5.$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$(i) \(X\sim B(10,0.4)\): \(\mathrm{E}(X)=4\), \(\mathrm{Var}(X)=2.4\), so \(\bar{X}\sim N(4,\frac{2.4}{50})\); \(\mathrm{P}(\bar{X}<4.5)=0.989\). (ii) \(\mathrm{E}(Y)=4.3\), \(\mathrm{Var}(Y)=4.3\), so \(\bar{Y}\sim N(4.3,\frac{4.3}{50})\); \(\mathrm{P}(\bar{Y}<4.5)=0.752\).$$,
  4,
  'H2 Math Tutorial (Sampling and Estimation Theory)',
  $$[
  {"label": "i", "prompt_latex": "\\(X\\sim B(10,0.4)\\)", "correct_answer": "0.989", "answer_type": "range", "tolerance": 0.001},
  {"label": "ii", "prompt_latex": "\\(\\mathrm{E}(Y)=4.3,\\ \\mathrm{Var}(Y)=4.3\\)", "correct_answer": "0.752", "answer_type": "range", "tolerance": 0.001}
]$$::jsonb
);

-- Q4: sample mean and the CLT
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc226004-0000-0000-0000-000000000000',
  'bbbb0004-0000-0000-0000-000000000000',
  2,
  $$Sample mean and the Central Limit Theorem$$,
  $$It is given that the distribution \(Y\) is normally distributed and has mean 4 and variance 3, and that \(\bar{Y}\) is the sample mean of \(n\) independent observations of \(Y\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) \(\bar{Y}\sim N(4,\frac{3}{5})\); \(\mathrm{P}(\bar{Y}<5)=0.902\). (ii) The CLT applies when the sample size is large (\(n\ge30\)), so \(\bar{Y}\) is approximately normal regardless of the distribution of \(Y\). (iii) \(\bar{Y}\sim N(6,\frac{12}{n})\); \(\mathrm{P}(\bar{Y}>5)>0.99\Rightarrow\sqrt{\frac{n}{12}}>2.326\Rightarrow n>64.9\), so the smallest sample size is \(65\).$$,
  5,
  'H2 Math Tutorial (Sampling and Estimation Theory)',
  $$[
  {"label": "i", "prompt_latex": "Find \\(\\mathrm{P}(\\bar{Y}<5)\\) when \\(n=5\\).", "correct_answer": "0.902", "answer_type": "range", "tolerance": 0.001},
  {"label": "ii", "prompt_latex": "If \\(Y\\) is not normally distributed, state one condition for which the central limit theorem can be applied to the calculation of \\(\\mathrm{P}(\\bar{Y}<5)\\).", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "iii", "prompt_latex": "If \\(Y\\) is uniformly distributed over the interval \\((0,12)\\), such that \\(\\mathrm{E}(Y)=6\\) and \\(\\mathrm{Var}(Y)=12\\), find the smallest sample size required such that \\(\\mathrm{P}(\\bar{Y}>5)>0.99\\).", "correct_answer": "65", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);

-- Q5: Horlicks in glass jars
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc226005-0000-0000-0000-000000000000',
  'bbbb0004-0000-0000-0000-000000000000',
  2,
  $$Horlicks in glass jars$$,
  $$The weight of Horlicks in glass jars labelled 500g is normally distributed with mean 505.1g and standard deviation 7.5g. The weight of an empty glass jar is normally distributed with mean 350g and standard deviation 5.5g. The weight of a glass jar is independent of the weight of Horlicks it contains.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(a) Independent events: \(\mathrm{P}(\text{jar}<365)=0.9968\) and \(\mathrm{P}(\text{Horlicks}<499)=0.208\); product \(=0.207\). (b) \(\bar{X}\sim N(505.1,\frac{56.25}{50})\). (i) \(\mathrm{P}(505<\bar{X}<508)=0.534\). (ii) \(\mathrm{P}(\bar{X}>504)=0.850\); expected number out of 100 samples \(=100\times0.850=85\).$$,
  6,
  'H2 Math Tutorial (Sampling and Estimation Theory)',
  $$[
  {"label": "a", "prompt_latex": "Find the probability that a randomly selected jar weighs less than 365g and contains less than 499g of Horlicks.", "correct_answer": "0.207", "answer_type": "range", "tolerance": 0.001},
  {"label": "bi", "prompt_latex": "(b) A random sample of 50 jars of Horlicks is taken and the mean weight of the Horlicks is calculated. What is the probability that the sample mean lies between 505g and 508g?", "correct_answer": "0.534", "answer_type": "range", "tolerance": 0.001},
  {"label": "bii", "prompt_latex": "(b)(ii) A hundred such samples, each of 50 jars of Horlicks, are taken. In how many of these samples would you expect the sample mean to be greater than 504?", "correct_answer": "85", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);

-- Q6: children watching television
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc226006-0000-0000-0000-000000000000',
  'bbbb0004-0000-0000-0000-000000000000',
  2,
  $$Children watching television$$,
  $$The mean time spent by children of age 12 on watching television programmes in one day is 3.5 hours with standard deviation of 0.7 hours.$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$(i) \(\bar{X}\sim N(3.5,\frac{0.49}{100})\); \(\mathrm{P}(3.4<\bar{X}<3.7)=0.921\). (ii) Total \(T\sim N(350,49)\); \(\mathrm{P}(T>365)=0.0161\). (iii) A random sample means every 12-year-old child has an equal chance of selection and selections are independent, so all samples of 100 are equally likely.$$,
  5,
  'H2 Math Tutorial (Sampling and Estimation Theory)',
  $$[
  {"label": "i", "prompt_latex": "What is the probability that in a random sample of 100 children, the mean watching time in one day is between 3.4 and 3.7 hours?", "correct_answer": "0.921", "answer_type": "range", "tolerance": 0.001},
  {"label": "ii", "prompt_latex": "What will be the probability that the total time spent by the 100 children on watching television programmes on a Sunday exceeds 365 hours?", "correct_answer": "0.0161", "answer_type": "range", "tolerance": 0.0005},
  {"label": "iii", "prompt_latex": "Explain what is meant by a random sample in this context.", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);

-- Q7: light-bulb life sample size
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc226007-0000-0000-0000-000000000000',
  'bbbb0004-0000-0000-0000-000000000000',
  2,
  $$Light-bulb life sample size$$,
  $$The life, in hours, of a randomly chosen light bulb produced by a manufacturer is normally distributed with mean 1100 and standard deviation 70.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$\(\bar{X}\sim N(1100,\frac{4900}{n})\); \(\mathrm{P}(\bar{X}>1120)\le0.05\Rightarrow\frac{20\sqrt{n}}{70}\ge1.6449\Rightarrow\sqrt{n}\ge5.757\Rightarrow n\ge33.1\), so the least sample size is \(34\). The CLT is not needed because the population of lifespans is already normal, so \(\bar{X}\) is exactly normal for any \(n\).$$,
  4,
  'H2 Math Tutorial (Sampling and Estimation Theory)',
  $$[
  {"label": "n", "prompt_latex": "How large a sample is required such that the probability that the mean life in the sample shall exceed 1120 is not more than 5%?", "correct_answer": "34", "answer_type": "exact", "tolerance": null},
  {"label": "clt", "prompt_latex": "Do you need to use the Central Limit Theorem in your working? Justify your answer.", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);

-- Q8: draws until a ball repeats
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc226008-0000-0000-0000-000000000000',
  'bbbb0004-0000-0000-0000-000000000000',
  3,
  $$Draws until a ball repeats$$,
  $$There are three identically shaped balls, numbered from 1 to 3, in a bag. Balls are drawn one by one at random and with replacement. The random variable \(X\) is the number of draws needed for any ball to be drawn a second time. The two draws of the same ball do not need to be consecutive.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$Distribution: \(\mathrm{P}(X=2)=\frac13,\ \mathrm{P}(X=3)=\frac49,\ \mathrm{P}(X=4)=\frac29\). (i) \(\mathrm{P}(X=4)\): the first three draws are all distinct \(\left(1\cdot\frac23\cdot\frac13=\frac29\right)\) and the fourth must repeat one of them: \(\frac29\). (ii) \(\mathrm{E}(X)=\frac{26}{9}\); \(\mathrm{E}(X^2)=\frac{80}{9}\), so \(\mathrm{Var}(X)=\frac{80}{9}-\left(\frac{26}{9}\right)^2=\frac{44}{81}\). (iii) \(\bar{X}\sim N\!\left(\frac{26}{9},\frac{44/81}{44}\right)=N\!\left(\frac{26}{9},\frac{1}{81}\right)\); \(\mathrm{P}(\bar{X}>3)=0.159\).$$,
  6,
  'H2 Math Tutorial (Sampling and Estimation Theory)',
  $$[
  {"label": "i", "prompt_latex": "Show that \\(\\mathrm{P}(X=4)=\\dfrac{2}{9}\\) and find the probability distribution of \\(X\\).", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ii", "prompt_latex": "Show that \\(\\mathrm{E}(X)=\\dfrac{26}{9}\\) and find the exact value of \\(\\mathrm{Var}(X)\\).", "correct_answer": "\\frac{44}{81}", "answer_type": "exact", "tolerance": null},
  {"label": "iii", "prompt_latex": "The mean for forty-four independent observations of \\(X\\) is denoted by \\(\\bar{X}\\). Using a suitable approximation, find the probability that \\(\\bar{X}\\) exceeds 3.", "correct_answer": "0.159", "answer_type": "range", "tolerance": 0.001}
]$$::jsonb
);
