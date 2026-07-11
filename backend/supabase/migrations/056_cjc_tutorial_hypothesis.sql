-- Migration 056: CJC 2022 JC2 H2 Math Tutorial — Hypothesis Testing (DISCUSSION only, 8 questions)
-- Source: TUTORIAL/STATS QN/6.7 Hypothesis Testing + solution.pdf, DISCUSSION section (pp.22-25);
--         worked solutions cross-checked against TUTORIAL/ STATS SOLUTIONS/6.7 2022 Hypothesis Testing DQ Solution.pdf.
-- REVIEW PROBLEMS deliberately excluded. Answers verified against the tutorial answer key (re-derived).
-- Provenance stripped: generic source 'H2 Math Tutorial (Hypothesis Testing)', inline exam tags removed.
-- IDs: prefix 'cc22' + topic-index '7' (stats file 6.7) + 3-digit Q# -> cc227001..cc227008. Topic bbbb0005.
-- Grading: only unambiguous numeric asks graded (unbiased estimates, least alpha%, least n, least k, p-value);
--          worded conclusions, hypothesis statements, explanations and compound sample-mean ranges left null. No DDL.

-- Q1: consumer union light-bulb test
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc227001-0000-0000-0000-000000000000',
  'bbbb0005-0000-0000-0000-000000000000',
  1,
  $$Consumer union light-bulb test$$,
  $$For many years of prior experimentation, the Consumer Union has found that the mean life of a 100-watt light bulb is 72 days of continuous usage, with a standard deviation of 12 days. The light bulb company has recently marketed their bulb as "new and improved, yielding longer life". The Consumer Union purchases 55 bulbs and tests them. The average life of the bulbs tested is 75.2 days. Does the mean of 75.2 present sufficient evidence to support the producer's claim that the new bulbs are superior? Use 5% level of significance.$$,
  'exact',
  $$See solution$$,
  NULL,
  $$Test \(H_0:\mu=72\) vs \(H_1:\mu>72\) at 5%. \(z_{\text{test}}=\dfrac{75.2-72}{12/\sqrt{55}}=1.98>1.6449\) (p-value \(=0.0240<0.05\)), so reject \(H_0\): there is sufficient evidence at the 5% level that the new bulbs are superior.$$,
  4,
  'H2 Math Tutorial (Hypothesis Testing)',
  $$[
  {"label": "conclusion", "prompt_latex": "Carry out the test and state your conclusion in context.", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);

-- Q2: manufacturer understating mean power
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc227002-0000-0000-0000-000000000000',
  'bbbb0005-0000-0000-0000-000000000000',
  2,
  $$Manufacturer understating mean power$$,
  $$A manufacturer makes light bulbs with power normally distributed with mean 13 watts and standard deviation 2.716 watts. A sample of 50 bulbs is taken and found to have a mean power of 13.168 watts.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) \(H_0:\mu=13\) vs \(H_1:\mu>13\); \(z_{\text{test}}=0.437\) (p-value \(=0.331>0.05\)), do not reject \(H_0\): no evidence the mean power is understated. (ii) A 5% level of significance means there is a 0.05 probability of concluding the mean power is understated when it is in fact 13 watts. (iii) The least significance level to reject \(H_0\) equals the p-value, \(\alpha=33.2\). (iv) For \(z_{\text{test}}=\dfrac{0.168\sqrt{n}}{2.716}>1.2816\Rightarrow\sqrt{n}>20.72\Rightarrow n>429.4\); least \(n=430\).$$,
  6,
  'H2 Math Tutorial (Hypothesis Testing)',
  $$[
  {"label": "i", "prompt_latex": "Test at 5% level of significance whether the manufacturer is understating the mean power.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ii", "prompt_latex": "Explain what is meant by the phrase 'a 5% level of significance' in the context of this question.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "iii", "prompt_latex": "Given now that the level of significance is unknown, if we wish to arrive at the conclusion that the manufacturer is understating the mean power, what should be the least level of significance \\(\\alpha\\%\\), correct to 1 decimal place?", "correct_answer": "33.2", "answer_type": "range", "tolerance": 0.1},
  {"label": "iv", "prompt_latex": "At 10% level of significance, what should be the least sample size in order to conclude that the manufacturer has understated the mean power?", "correct_answer": "430", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);

-- Q3: department-store sales promotion
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc227003-0000-0000-0000-000000000000',
  'bbbb0005-0000-0000-0000-000000000000',
  2,
  $$Department-store sales promotion$$,
  $$A department store reported that over the past six months, the average amount spent per customer has been $215 with standard deviation of $100. The store carried out a sales promotion for a week on a range of products. In order to test, at 5% level of significance, whether or not the sales promotion has increased the average amount spent per customer, a random sample of 100 customers visiting the store during the sales promotion week was taken. The amount spent per customer was recorded.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) No — since the sample size \(n=100\) is large, by the Central Limit Theorem the sample mean is approximately normal regardless of the population distribution, so no normality assumption is needed. (ii) \(H_0:\mu=215\) vs \(H_1:\mu>215\). \(H_0\) is rejected when \(z_{\text{test}}=\dfrac{\bar{x}-215}{100/\sqrt{100}}>1.6449\Rightarrow \bar{x}>215+16.449=231.45\).$$,
  4,
  'H2 Math Tutorial (Hypothesis Testing)',
  $$[
  {"label": "i", "prompt_latex": "State, with a reason, whether, in performing the above test, it is necessary to assume that the amount spent per customer follows a normal distribution.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ii", "prompt_latex": "Write down the null and alternative hypotheses under test. Given that the null hypothesis is rejected, show that the sample mean is greater than $231.45.", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);

-- Q4: mobile phone battery standby-time
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc227004-0000-0000-0000-000000000000',
  'bbbb0005-0000-0000-0000-000000000000',
  2,
  $$Mobile-phone battery standby-time$$,
  $$A random sample of 90 batteries, used in a particular model of mobile phone, is tested and the "standby-time" is measured. The results are summarised by \(\sum x=3040.8\) and \(\sum x^2=115773.66\). Test, at the 1% significance level, whether the mean standby-time is less than 36.0 h.\\ This type of battery is advertised as having a 'talk-time' of 5 hours. In a test at the 5% significance level it is found that there is significant evidence that the population mean talk-time is less than 5 hours. Using only this information, and giving a reason in each case, state whether each of the following statements is (i) necessarily true, (ii) necessarily false, or (iii) neither necessarily true nor necessarily false.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$Standby test: \(\bar{x}=33.787\), unbiased variance \(=0.1044\); \(z_{\text{test}}=-1.74>-2.3263\) (p-value \(=0.04139>0.01\)), do not reject \(H_0\). (a) Significant at 5% \(\Rightarrow\) also significant at the larger 10% level, so this is necessarily true. (b) A one-tailed rejection of "\(\mu<5\)" says nothing about the two-tailed "\(\mu\neq5\)" at a different level, so this is neither necessarily true nor necessarily false.$$,
  5,
  'H2 Math Tutorial (Hypothesis Testing)',
  $$[
  {"label": "test", "prompt_latex": "Test, at the 1% significance level, whether the mean standby-time is less than 36.0 h.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "a", "prompt_latex": "There is significant evidence at the 10% significance level that the population mean talk-time is less than 5 hours.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "b", "prompt_latex": "There is significant evidence at the 5% significance level that the population mean talk-time is not 5 hours.", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);

-- Q5: ride-hailing waiting time
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc227005-0000-0000-0000-000000000000',
  'bbbb0005-0000-0000-0000-000000000000',
  2,
  $$Ride-hailing waiting time$$,
  $$The company Snatch provides a ride-hailing service comprising taxis and private cars in Singapore. Snatch claims that the mean waiting time for a passenger from the booking time to the time of the vehicle's arrival is 7 minutes. To test whether the claim is true, a random sample of 30 passengers' waiting times is obtained. The standard deviation of the sample is 2 minutes. A hypothesis test conducted concludes that there is sufficient evidence at the 1% significance level to reject the claim.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) \(H_0:\mu=7\) vs \(H_1:\mu\neq7\); unbiased variance \(=\frac{30}{29}(2^2)=\frac{120}{29}\), so \(\bar{T}\sim N\!\left(7,\frac{4}{29}\right)\). (ii) Reject when \(\left|\frac{\bar{t}-7}{\sqrt{4/29}}\right|>2.5758\Rightarrow \bar{t}\le6.04\) or \(\bar{t}\ge7.96\). (iii) For the one-tailed test \(H_1:\mu>7\) with the sample mean \(>7\) already in the rejection region at 1%, the conclusion is that the mean waiting time is more than 7 minutes.$$,
  6,
  'H2 Math Tutorial (Hypothesis Testing)',
  $$[
  {"label": "i", "prompt_latex": "State appropriate hypotheses and the distribution of the test statistic used.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ii", "prompt_latex": "Find the range of values of the sample mean waiting time, \\(\\bar{t}\\).", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "iii", "prompt_latex": "A hypothesis test is conducted at the 1% significance level whether the mean waiting time of passengers is more than 7 minutes. Using the existing sample, deduce the conclusion of this test if the sample mean waiting time is more than 7 minutes.", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);

-- Q6: length of string in a ball
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc227006-0000-0000-0000-000000000000',
  'bbbb0005-0000-0000-0000-000000000000',
  2,
  $$Length of string in a ball$$,
  $$A company sells balls of string. A manager claims that the average length of string in a ball is at least 300 m. To test this claim, a random sample of 100 balls of string is checked and the lengths of string per ball, \(x\) m, are summarised by \(\sum(x-300)=-60\) and \(\sum(x-300)^2=1240\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) \(\bar{x}=300+\frac{-60}{100}=299.4\); unbiased variance \(=\frac{1}{99}\left(1240-\frac{(-60)^2}{100}\right)=12.2\). (ii) An unbiased estimate is one whose expected value equals the population parameter it estimates. (iii) \(H_0:\mu=300\) vs \(H_1:\mu<300\); \(z_{\text{test}}=-1.72\), p-value \(=0.0427<0.05\), reject \(H_0\): the manager's claim is not valid. (iv) With variance \(12.1\), reject at 10% when \(\frac{k-300}{\sqrt{12.1/100}}<-1.2816\); the claim is valid (not rejected) when \(k\ge299.55\), so the least value is \(299.55\).$$,
  8,
  'H2 Math Tutorial (Hypothesis Testing)',
  $$[
  {"label": "i", "prompt_latex": "Find the unbiased estimates of the population mean and variance.", "correct_answer": "mean 299.4, variance 12.2", "answer_type": "exact", "tolerance": null, "answers": [
    {"key": "mean", "label": "unbiased mean", "correct_answer": "299.4", "answer_type": "range", "tolerance": 0.05},
    {"key": "var", "label": "unbiased variance", "correct_answer": "12.2", "answer_type": "range", "tolerance": 0.05}
  ]},
  {"label": "ii", "prompt_latex": "What do you understand by the term \"unbiased estimate\"?", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "iii", "prompt_latex": "Test at the 5% level of significance whether the manager's claim is valid.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "iv", "prompt_latex": "The manufacturing process is improved and the new population variance is known to be \\(12.1\\,\\text{m}^2\\). A new random sample of 100 balls of string is chosen and the mean of this sample is \\(k\\) m. A test at the 10% level of significance indicates that the manager's claim is valid for this improved process. Find the least possible value of \\(k\\), giving your answer correct to 2 decimal places.", "correct_answer": "299.55", "answer_type": "range", "tolerance": 0.05}
]$$::jsonb
);

-- Q7: Overseas Universities Test scores
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc227007-0000-0000-0000-000000000000',
  'bbbb0005-0000-0000-0000-000000000000',
  2,
  $$Overseas Universities Test scores$$,
  $$(a) College students intending to further their studies overseas have to sit for a mandatory Overseas Universities Test (OUT). Researcher Mr Anand wishes to find out if male college students tend to score higher for OUT compared to female college students. Mr Anand's colleague randomly selects 150 male and 150 female students from the combined student population of three particular colleges near his home to form a sample of 300 college students for the research.\\ (b) The mean OUT score for all college students in 2016 is 66. Mr Anand randomly selects 240 college students taking OUT in 2017 and their scores, \(x\), are summarised in the table (score : frequency): 60 : 40, 65 : 90, 68 : 63, 70 : 27, 75 : 18, 80 : 2.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(a) Not a random sample: it is restricted to three colleges near his home and forces exactly 150 of each sex, so not every sample of 300 from the population is equally likely. (b)(i) \(\bar{x}=\frac{15934}{240}=66.391\); unbiased variance \(=\frac{1}{239}\left(1061912-\frac{15934^2}{240}\right)=16.85=4.1048^2\). (ii) \(H_0:\mu=66\) vs \(H_1:\mu>66\); p-value \(=0.0697>0.10\), do not reject \(H_0\). (iii) A 10% level of significance means a 0.10 probability of concluding the 2017 mean exceeds 66 when it is in fact 66. (iv) A different conclusion (reject \(H_0\)) needs \(z_{\text{test}}>1.2816\Rightarrow\bar{x}>66.3\); i.e. the current \(\bar{x}<66.3\) gave "do not reject", so the required range is \(\bar{x}<66.3\).$$,
  8,
  'H2 Math Tutorial (Hypothesis Testing)',
  $$[
  {"label": "a", "prompt_latex": "Explain whether the sample of 300 college students is a random sample.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "bi", "prompt_latex": "(b)(i) Write down the unbiased estimates of the population mean and variance of the OUT scores for the college students in 2017.", "correct_answer": "mean 66.391, variance 16.85", "answer_type": "exact", "tolerance": null, "answers": [
    {"key": "mean", "label": "unbiased mean", "correct_answer": "66.391", "answer_type": "range", "tolerance": 0.05},
    {"key": "var", "label": "unbiased variance", "correct_answer": "16.85", "answer_type": "range", "tolerance": 0.05}
  ]},
  {"label": "bii", "prompt_latex": "(b)(ii) Test, at the 10% level of significance, whether the mean OUT score for all college students in 2017 is higher than the mean score attained in 2016.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "biii", "prompt_latex": "(b)(iii) Explain what is meant by the phrase '10% level of significance' in this context.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "biv", "prompt_latex": "(b)(iv) Mr Anand draws a new sample of 240 male college students. Using the unbiased estimate for the population variance computed in (i), find the range of values for the sample mean \\(\\bar{x}\\) that is required for this new sample to achieve a different conclusion from that in (ii).", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);

-- Q8: battery lifetime, combined samples
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc227008-0000-0000-0000-000000000000',
  'bbbb0005-0000-0000-0000-000000000000',
  3,
  $$Battery lifetime, combined samples$$,
  $$A consumer association is testing the lifetime of a particular type of battery that is claimed to have a lifetime of 150 hours. A random sample of 70 batteries of this type is tested and the lifetime, \(x\) hours, of each battery is measured. The results are summarised by \(\sum x=10317\) and \(\sum x^2=1540231\). The population mean lifetime is denoted by \(\mu\) hours. The null hypothesis \(\mu=150\) is to be tested against the alternative hypothesis \(\mu<150\). A second random sample of 50 batteries of this type is tested and the lifetime, \(y\) hours, is measured, with results summarised by \(\sum y=7331\) and \(\sum y^2=1100565\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$First sample: \(\bar{x}=147.39\), unbiased variance \(=187.5\); \(z_{\text{test}}=-1.296\), p-value \(=0.0975\) (3 s.f.). This p-value is the probability of obtaining a sample of 70 batteries with mean lifetime \(\le147.39\) hours when the population mean is 150 hours. Combined sample (\(n=120\), \(\sum=17648\), \(\sum^2=2640796\)): \(z_{\text{test}}=-1.64<-1.2816\) (p-value \(=0.0500<0.10\)), reject \(H_0\) at the 10% level.$$,
  6,
  'H2 Math Tutorial (Hypothesis Testing)',
  $$[
  {"label": "pval", "prompt_latex": "Find the p-value of the test on the first sample and state the meaning of this p-value in the context of the question.", "correct_answer": "0.0975", "answer_type": "range", "tolerance": 0.0005},
  {"label": "combined", "prompt_latex": "Combining the two samples into a single sample, carry out a test, at the 10% significance level, of the same null and alternative hypotheses.", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);
