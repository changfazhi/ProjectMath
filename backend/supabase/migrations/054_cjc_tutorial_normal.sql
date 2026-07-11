-- Migration 054: CJC 2022 JC2 H2 Math Tutorial — Normal Distribution (DISCUSSION only, 12 questions)
-- Source: TUTORIAL/STATS QN/6.5 Normal Distribution + solution.pdf, DISCUSSION section (pp.25-27);
--         worked solutions cross-checked against TUTORIAL/ STATS SOLUTIONS/6.5 2022 Normal Distribution DQ Solution_01.01.22.pdf.
-- REVIEW PROBLEMS and Self-Practice deliberately excluded. Answers verified against the tutorial answer key (re-derived).
-- Provenance stripped: generic source 'H2 Math Tutorial (Normal Distribution)', inline exam tags removed.
-- IDs: prefix 'cc22' + topic-index '5' (stats file 6.5) + 3-digit Q# -> cc225001..cc22500c. Topic bbbb0008.
-- Grading: GC probabilities and recovered mu/sigma graded 'range'; "give a reason" / "state whether a normal model
--          is appropriate" / range-of-k (inequality) / show-that / express-in-terms-of-k / two-value 'a' parts null.

-- Q1: reason a normal model is inappropriate
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc225001-0000-0000-0000-000000000000',
  'bbbb0008-0000-0000-0000-000000000000',
  1,
  $$When a normal model is inappropriate$$,
  $$An examination is marked out of 100. It is taken by a large number of candidates. The mean mark, for all candidates, is 72.1, and the standard deviation is 15.2. Give a reason why a normal distribution, with this mean and standard deviation, would not give a good approximation to the distribution of marks.$$,
  'exact',
  $$See solution$$,
  NULL,
  $$A normal distribution is unbounded, but marks are capped at 100. With mean 72.1 and s.d. 15.2, \(\mathrm{P}(X>100)\) is non-negligible (about 4%), so a normal model would predict impossible marks above 100 (and the true distribution is skewed toward the ceiling).$$,
  2,
  'H2 Math Tutorial (Normal Distribution)',
  $$[
  {"label": "reason", "prompt_latex": "Give a reason why the normal model would not give a good approximation.", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);

-- Q2: whether a normal model is appropriate
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc225002-0000-0000-0000-000000000000',
  'bbbb0008-0000-0000-0000-000000000000',
  1,
  $$Is a normal model appropriate?$$,
  $$The heights of boys and girls in a Junior College may be assumed to follow independent normal distributions. For each of the following cases, state with a reason, whether or not a normal model is likely to be appropriate.$$,
  'exact',
  $$See solution$$,
  NULL,
  $$(a) Not appropriate: combining boys and girls (with different mean heights) gives a bimodal, non-normal mixture. (b) Appropriate: a sum of independent normal heights is normal. (c) Not appropriate: "days since last birthday" is roughly uniform on \([0,365]\), not bell-shaped.$$,
  3,
  'H2 Math Tutorial (Normal Distribution)',
  $$[
  {"label": "a", "prompt_latex": "The height of a student chosen at random from a combined group of boys and girls.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "b", "prompt_latex": "The sum of heights of a randomly chosen sample of 3 boys.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "c", "prompt_latex": "The number of days since his last birthday of a randomly chosen student.", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);

-- Q3: combinations of two independent normals
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc225003-0000-0000-0000-000000000000',
  'bbbb0008-0000-0000-0000-000000000000',
  1,
  $$Combinations of two independent normals$$,
  $$\(X\) and \(Y\) are continuous random variables having independent normal distributions. The means of \(X\) and \(Y\) are 10 and 12 respectively, and the standard deviations are 2 and 3 respectively. Find$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$(a) \(\mathrm{P}(Y<10)=0.252\). (b) \(2X\sim N(20,16)\), \(\mathrm{P}(2X>25)=0.106\). (c) \(Y-X\sim N(2,13)\), \(\mathrm{P}(Y<X)=\mathrm{P}(Y-X<0)=0.290\). (d) \(4X+5Y\sim N(100,964)\), \(\mathrm{P}(4X+5Y>90)=0.722\). (e) \(X_1+X_2\sim N(20,8)\); \(\mathrm{P}(X_1+X_2>x)=0.25\Rightarrow x=21.9\).$$,
  5,
  'H2 Math Tutorial (Normal Distribution)',
  $$[
  {"label": "a", "prompt_latex": "\\(\\mathrm{P}(Y<10)\\)", "correct_answer": "0.252", "answer_type": "range", "tolerance": 0.001},
  {"label": "b", "prompt_latex": "\\(\\mathrm{P}(2X>25)\\)", "correct_answer": "0.106", "answer_type": "range", "tolerance": 0.001},
  {"label": "c", "prompt_latex": "\\(\\mathrm{P}(Y<X)\\)", "correct_answer": "0.290", "answer_type": "range", "tolerance": 0.001},
  {"label": "d", "prompt_latex": "\\(\\mathrm{P}(4X+5Y>90)\\)", "correct_answer": "0.722", "answer_type": "range", "tolerance": 0.001},
  {"label": "e", "prompt_latex": "the value of \\(x\\) such that \\(\\mathrm{P}(X_1+X_2>x)=0.25\\), where \\(X_1\\) and \\(X_2\\) are independent observations of \\(X\\).", "correct_answer": "21.9", "answer_type": "range", "tolerance": 0.05}
]$$::jsonb
);

-- Q4: range of values of k
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc225004-0000-0000-0000-000000000000',
  'bbbb0008-0000-0000-0000-000000000000',
  1,
  $$Range of values of k$$,
  $$Given that \(X\sim N(67,81)\), find the range of possible values of \(k\) such that$$,
  'exact',
  $$See solution$$,
  NULL,
  $$\(\sigma=9\). (a) \(\mathrm{P}(X>k)<0.55\Rightarrow \frac{k-67}{9}>\Phi^{-1}(0.45)=-0.1257\Rightarrow k\ge65.9\). (b) \(\mathrm{P}(X<k)>0.777\Rightarrow \frac{k-67}{9}>\Phi^{-1}(0.777)=0.7626\Rightarrow k\ge73.9\).$$,
  4,
  'H2 Math Tutorial (Normal Distribution)',
  $$[
  {"label": "a", "prompt_latex": "\\(\\mathrm{P}(X>k)<0.55\\)", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "b", "prompt_latex": "\\(\\mathrm{P}(X<k)>0.777\\)", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);

-- Q5: apple grading machine
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc225005-0000-0000-0000-000000000000',
  'bbbb0008-0000-0000-0000-000000000000',
  2,
  $$Apple grading machine$$,
  $$A grading machine is set to reject an apple as too large if its mass exceeds 150 g, and too small if its mass is less than 110 g. Over a long period, 10% of apples are rejected as too large and 15% are rejected as too small. The mass, in grams, of a randomly chosen apple may be taken to have the distribution \(N(\mu,\sigma^2)\). Find \(\mu\) and \(\sigma\).$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$\(\frac{150-\mu}{\sigma}=1.2816\) and \(\frac{110-\mu}{\sigma}=-1.0364\). Subtracting: \(40=2.318\sigma\Rightarrow\sigma=17.3\); then \(\mu=150-1.2816(17.3)=128\).$$,
  4,
  'H2 Math Tutorial (Normal Distribution)',
  $$[
  {"label": "mu-sigma", "prompt_latex": "Find \\(\\mu\\) and \\(\\sigma\\).", "correct_answer": "mu = 128, sigma = 17.3", "answer_type": "exact", "tolerance": null, "answers": [
    {"key": "mu", "label": "\\mu", "correct_answer": "128", "answer_type": "range", "tolerance": 0.5},
    {"key": "sigma", "label": "\\sigma", "correct_answer": "17.3", "answer_type": "range", "tolerance": 0.1}
  ]}
]$$::jsonb
);

-- Q6: recover mu and sigma from symmetric tail probabilities
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc225006-0000-0000-0000-000000000000',
  'bbbb0008-0000-0000-0000-000000000000',
  2,
  $$Recovering mu and sigma$$,
  $$The random variable \(X\) has the distribution \(N(\mu,\sigma^2)\). Given that \(\mathrm{P}(X<85)=\mathrm{P}(X>101)=0.0548\), find the values of \(\mu\) and \(\sigma\).$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$By symmetry \(\mu=\frac{85+101}{2}=93\). Then \(\frac{85-93}{\sigma}=\Phi^{-1}(0.0548)=-1.60\Rightarrow\sigma=5.00\).$$,
  4,
  'H2 Math Tutorial (Normal Distribution)',
  $$[
  {"label": "mu-sigma", "prompt_latex": "Find the values of \\(\\mu\\) and \\(\\sigma\\).", "correct_answer": "mu = 93, sigma = 5.00", "answer_type": "exact", "tolerance": null, "answers": [
    {"key": "mu", "label": "\\mu", "correct_answer": "93", "answer_type": "range", "tolerance": 0.5},
    {"key": "sigma", "label": "\\sigma", "correct_answer": "5.00", "answer_type": "range", "tolerance": 0.05}
  ]}
]$$::jsonb
);

-- Q7: rods of type A and B
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc225007-0000-0000-0000-000000000000',
  'bbbb0008-0000-0000-0000-000000000000',
  2,
  $$Rods of type A and B$$,
  $$Lengths of rods of type A are normally distributed with mean 5 cm and standard deviation 0.5 cm, and lengths of rods of type B are normally distributed with mean 10 cm and standard deviation 1 cm. Assume the lengths of rods of type A and B are independent. Find the probability that$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(a) \(3A+2B\sim N(35,\ 3(0.25)+2(1))=N(35,2.75)\); \(\mathrm{P}(33<S<36)=0.613\). (b) \(6A-3B\sim N(0,\ 6(0.25)+9(1))=N(0,10.5)\); \(\mathrm{P}(6A>3B)=\mathrm{P}(6A-3B>0)=\frac12\) by symmetry.$$,
  4,
  'H2 Math Tutorial (Normal Distribution)',
  $$[
  {"label": "a", "prompt_latex": "a length consisting of 3 rods of type A and 2 rods of type B is between 33 cm and 36 cm long,", "correct_answer": "0.613", "answer_type": "range", "tolerance": 0.001},
  {"label": "b", "prompt_latex": "a length consisting of 6 rods of type A is longer than three times the length of a randomly chosen rod of type B.", "correct_answer": "\\frac{1}{2}", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);

-- Q8: N(10,4) probabilities and inverse
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc225008-0000-0000-0000-000000000000',
  'bbbb0008-0000-0000-0000-000000000000',
  3,
  $$Probabilities for a normal variable$$,
  $$A variable \(X\) is distributed normally with mean 10 and standard deviation 2.$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$(i) \(\mathrm{P}(9<X<13)=0.625\). (ii) \(\mathrm{P}(X<12)=0.841\). (iii) \(\mathrm{P}(a<X<12)=0.15\) gives \(a=11.0\) or \(a=14.8\). (iv) \(\mathrm{P}(X<12)=0.841\), \(\mathrm{P}(X>12)=0.159\); for three values, two below 12 and one above: \(\binom{3}{1}(0.841)^2(0.159)=0.337\).$$,
  6,
  'H2 Math Tutorial (Normal Distribution)',
  $$[
  {"label": "i", "prompt_latex": "Find \\(\\mathrm{P}(9<X<13)\\).", "correct_answer": "0.625", "answer_type": "range", "tolerance": 0.001},
  {"label": "ii", "prompt_latex": "Find \\(\\mathrm{P}(X<12)\\).", "correct_answer": "0.841", "answer_type": "range", "tolerance": 0.001},
  {"label": "iii", "prompt_latex": "Find the possible values of \\(a\\) if the probability that \\(X\\) is between \\(a\\) and 12 is 0.15.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "iv", "prompt_latex": "If three values of \\(X\\) are taken at random, calculate the probability that two of them are less than 12 and the other is greater than 12.", "correct_answer": "0.337", "answer_type": "range", "tolerance": 0.001}
]$$::jsonb
);

-- Q9: chickens and turkeys sold by weight
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc225009-0000-0000-0000-000000000000',
  'bbbb0008-0000-0000-0000-000000000000',
  3,
  $$Chickens and turkeys sold by weight$$,
  $$Chickens and turkeys are sold by weight. The masses, in kg, of chickens and turkeys are modelled as having independent normal distributions: chickens have mean mass 2.2 and standard deviation 0.5; turkeys have mean mass 10.5 and standard deviation 2.1. Chickens are sold at $3 per kg and turkeys at $5 per kg.$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$(i) chicken price \(=3M\); \(3M>7\Leftrightarrow M>2.333\); \(\mathrm{P}=0.395\). (ii) turkey price \(=5T>55\Leftrightarrow T>11\); \(\mathrm{P}(T>11)=0.406\); combined \(=0.395\times0.406=0.160\). (iii) total price \(3C+5T\sim N(59.1,112.5)\); \(\mathrm{P}(>62)=0.392\). (iv) since the total selling price sums two independent variables its spread is larger, so a value above \$62 is more likely than requiring both individual prices to exceed their separate thresholds simultaneously.$$,
  6,
  'H2 Math Tutorial (Normal Distribution)',
  $$[
  {"label": "i", "prompt_latex": "Find the probability that a randomly chosen chicken has a selling price exceeding $7.", "correct_answer": "0.395", "answer_type": "range", "tolerance": 0.001},
  {"label": "ii", "prompt_latex": "Find the probability that both a randomly chosen chicken has a selling price exceeding $7 and a randomly chosen turkey has a selling price exceeding $55.", "correct_answer": "0.160", "answer_type": "range", "tolerance": 0.001},
  {"label": "iii", "prompt_latex": "Find the probability that the total selling price of a randomly chosen chicken and a randomly chosen turkey is more than $62.", "correct_answer": "0.392", "answer_type": "range", "tolerance": 0.001},
  {"label": "iv", "prompt_latex": "Explain why the answer to part (iii) is greater than the answer in part (ii).", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);

-- Q10: symbolic combination of two normals
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc22500a-0000-0000-0000-000000000000',
  'bbbb0008-0000-0000-0000-000000000000',
  3,
  $$Symbolic combination of two normals$$,
  $$Two independent random variables \(X\) and \(Y\) have the distributions \(N(2\mu,\sigma^2)\) and \(N(3\mu,3\sigma^2)\) respectively.$$,
  'exact',
  $$See solution$$,
  NULL,
  $$(i) Standardising, \(\mathrm{P}(X<2\mu+2\sigma^2)=\mathrm{P}\!\left(Z<\frac{2\sigma^2}{\sigma}\right)=\mathrm{P}(Z<2\sigma)=k\). (ii) \(Y-X\sim N(\mu,\ 4\sigma^2)\); standardising, \(\mathrm{P}(|Y-X-\mu|>4\sigma^2)=2\,\mathrm{P}(Z>2\sigma)=2(1-k)\).$$,
  5,
  'H2 Math Tutorial (Normal Distribution)',
  $$[
  {"label": "i", "prompt_latex": "Given that \\(\\mathrm{P}(X<2\\mu+2\\sigma^2)=k\\), show that \\(\\mathrm{P}(Z<2\\sigma)=k\\).", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ii", "prompt_latex": "Write down the mean and the variance of \\(Y-X\\). Hence find \\(\\mathrm{P}(|Y-X-\\mu|>4\\sigma^2)\\) in terms of \\(k\\).", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);

-- Q11: sums of many observations
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc22500b-0000-0000-0000-000000000000',
  'bbbb0008-0000-0000-0000-000000000000',
  3,
  $$Sums of many observations$$,
  $$The random variable \(X\) has a normal distribution with mean 3 and variance 4. The random variable \(S\) is the sum of 100 independent observations of \(X\), and the random variable \(T\) is the sum of a further 300 independent observations of \(X\). Giving your answers to 3 decimal places,$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$\(S\sim N(300,400)\), \(T\sim N(900,1200)\). (i) \(\mathrm{P}(S>310)=0.309\). (ii) \(3S-T\sim N(0,4800)\), \(\mathrm{P}(3S>50+T)=\mathrm{P}(3S-T>50)=0.235\). (iii) \(N\sim N(3n,4n)\); \(\mathrm{P}(N>3.5n)=\mathrm{P}\!\left(Z>\frac{0.5n}{2\sqrt{n}}\right)=\mathrm{P}(Z>0.25\sqrt{n})\to 0\) as \(n\to\infty\).$$,
  6,
  'H2 Math Tutorial (Normal Distribution)',
  $$[
  {"label": "i", "prompt_latex": "\\(\\mathrm{P}(S>310)\\),", "correct_answer": "0.309", "answer_type": "range", "tolerance": 0.001},
  {"label": "ii", "prompt_latex": "\\(\\mathrm{P}(3S>50+T)\\),", "correct_answer": "0.235", "answer_type": "range", "tolerance": 0.001},
  {"label": "iii", "prompt_latex": "The random variable \\(N\\) is the sum of \\(n\\) independent observations of \\(X\\). State the approximate value of \\(\\mathrm{P}(N>3.5n)\\) as \\(n\\) becomes very large, justifying your answer.", "correct_answer": "0", "answer_type": "range", "tolerance": 0.0001}
]$$::jsonb
);

-- Q12: supermarket grapefruits and papayas
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc22500c-0000-0000-0000-000000000000',
  'bbbb0008-0000-0000-0000-000000000000',
  3,
  $$Supermarket grapefruits and papayas$$,
  $$A supermarket sells grapefruits and papayas by mass. The masses, in grams, of a grapefruit and a papaya are modelled as having normal distributions. A grapefruit has mean mass \(\mu\) g, standard deviation 15 g, and selling price $0.007 per g; a papaya has mean mass 450 g, standard deviation 20 g, and selling price $0.008 per g. State clearly the parameters of any normal distribution you use.$$,
  'range',
  $$See individual parts$$,
  NULL,
  $$(i) 65% weigh \(>300\): \(\frac{300-\mu}{15}=\Phi^{-1}(0.35)=-0.385\Rightarrow\mu=305.78\approx306\). Take \(\mu=306\). (ii) \(3G\sim N(918,675)\), \(\mathrm{P}(3G<950)=0.891\). (iii) \(\mathrm{P}(G>300)=0.65\); \(B(10,0.65)\), \(\mathrm{P}(\ge6)=0.751\). (iv) \(3G-2P\sim N(18,1475)\), \(\mathrm{P}(|3G-2P|<100)=0.983\). (v) \(4G\sim N(1224,900)\), cost \(=0.007(4G)\ge9\Leftrightarrow 4G\ge1285.7\); \(\mathrm{P}=0.0198\). (vi) bundle cost \(0.007G+0.008P\sim N(5.742,0.03663)\); need \(\mathrm{P}(\text{cost}\le a)\ge0.9\Rightarrow a\ge5.742+1.2816(0.1914)=5.99\).$$,
  16,
  'H2 Math Tutorial (Normal Distribution)',
  $$[
  {"label": "i", "prompt_latex": "Given that 65% of the grapefruits sold weigh more than 300 g, show that \\(\\mu=306\\), leaving your answer to the nearest whole number.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ii", "prompt_latex": "Take \\(\\mu=306\\). Find the probability that the total mass of 3 randomly chosen grapefruits is less than 950 g.", "correct_answer": "0.891", "answer_type": "range", "tolerance": 0.001},
  {"label": "iii", "prompt_latex": "Ten grapefruits are chosen at random. Find the probability that more than half of the grapefruits weigh more than 300 g.", "correct_answer": "0.751", "answer_type": "range", "tolerance": 0.001},
  {"label": "iv", "prompt_latex": "Find the probability that the total mass of 3 randomly chosen grapefruits differs from the total mass of 2 randomly chosen papayas by at most 100 grams.", "correct_answer": "0.983", "answer_type": "range", "tolerance": 0.001},
  {"label": "v", "prompt_latex": "Find the probability that it will cost at least $9 to buy 4 grapefruits.", "correct_answer": "0.0198", "answer_type": "range", "tolerance": 0.0005},
  {"label": "vi", "prompt_latex": "The supermarket decides to have a promotion, selling a bundle of 1 grapefruit and 1 papaya at a fixed price. Find the least price, $a, that the supermarket should charge for the bundle if there is at least a 90% chance of not making a loss.", "correct_answer": "5.99", "answer_type": "range", "tolerance": 0.01}
]$$::jsonb
);
