-- Migration 051: CJC 2022 JC2 H2 Math Tutorial — Probability (DISCUSSION only, 10 questions)
-- Source: TUTORIAL/STATS QN/6.2 Probability + solution.pdf, DISCUSSION section (pp.33-36);
--         worked solutions cross-checked against TUTORIAL/ STATS SOLUTIONS/6.2 2022 Probability DQ Solution.pdf.
-- REVIEW PROBLEMS and Self-Practice deliberately excluded. Answers verified against the tutorial answer key (re-derived).
-- Provenance stripped: generic source 'H2 Math Tutorial (Probability)', inline exam tags removed.
-- IDs: prefix 'cc22' + topic-index '2' (stats file 6.2) + 3-digit Q# -> cc222001..cc22200a. Topic bbbb0002.
-- Grading: clean probabilities graded (fractions 'exact', 3-4 s.f. decimals 'range'); tree-diagram / describe /
--          prove / "state whether ..." parts left null (revealed). No DDL: parts JSONB (008) already exists.

-- Q1: fair die thrown twice
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc222001-0000-0000-0000-000000000000',
  'bbbb0002-0000-0000-0000-000000000000',
  1,
  $$A fair die thrown twice$$,
  $$In a game, an ordinary fair die is thrown twice and the number that appears on each throw is noted. Find the probability that$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$Each of the 36 ordered outcomes is equally likely. (i) both 6: \(\frac{1}{36}\). (ii) neither is 5: \(\left(\frac{5}{6}\right)^2=\frac{25}{36}\). (iii) one 6 and the other 5: \(\frac{2}{36}=\frac{1}{18}\). (iv) sum \(=6\): \((1,5),(2,4),(3,3),(4,2),(5,1)\) give \(\frac{5}{36}\). (v) first \(<\) second given sum \(=6\): of the 5 outcomes, \((1,5),(2,4)\) qualify: \(\frac{2}{5}\).$$,
  5,
  'H2 Math Tutorial (Probability)',
  $$[
  {"label": "i", "prompt_latex": "both numbers are '6',", "correct_answer": "\\frac{1}{36}", "answer_type": "exact", "tolerance": null},
  {"label": "ii", "prompt_latex": "neither number is a '5',", "correct_answer": "\\frac{25}{36}", "answer_type": "exact", "tolerance": null},
  {"label": "iii", "prompt_latex": "one number is '6' and the other is '5',", "correct_answer": "\\frac{1}{18}", "answer_type": "exact", "tolerance": null},
  {"label": "iv", "prompt_latex": "the sum of the numbers is 6,", "correct_answer": "\\frac{5}{36}", "answer_type": "exact", "tolerance": null},
  {"label": "v", "prompt_latex": "the first number is less than the second given that the sum of the two numbers is 6.", "correct_answer": "\\frac{2}{5}", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);

-- Q2: events A and B with given probabilities
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc222002-0000-0000-0000-000000000000',
  'bbbb0002-0000-0000-0000-000000000000',
  1,
  $$Conditional probabilities of two events$$,
  $$Events A and B are such that \(\mathrm{P}(A)=\dfrac{5}{12}\), \(\mathrm{P}(A\mid B')=\dfrac{7}{12}\) and \(\mathrm{P}(A\cap B)=\dfrac{1}{8}\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$\(\mathrm{P}(A\cap B')=\frac{5}{12}-\frac{1}{8}=\frac{7}{24}\), so \(\mathrm{P}(B')=\frac{7/24}{7/12}=\frac12\) and (i) \(\mathrm{P}(B)=\frac12\). (ii) \(\mathrm{P}(A\mid B)=\frac{1/8}{1/2}=\frac14\). (iii) \(\mathrm{P}(B\mid A)=\frac{1/8}{5/12}=\frac{3}{10}\). (iv) \(\mathrm{P}(A\cup B)=\frac{5}{12}+\frac12-\frac18=\frac{19}{24}\). Since \(\mathrm{P}(A)\mathrm{P}(B)=\frac{5}{24}\neq\frac18=\mathrm{P}(A\cap B)\), A and B are not independent; since \(\mathrm{P}(A\cap B)\neq0\), they are not mutually exclusive.$$,
  6,
  'H2 Math Tutorial (Probability)',
  $$[
  {"label": "i", "prompt_latex": "\\(\\mathrm{P}(B)\\),", "correct_answer": "\\frac{1}{2}", "answer_type": "exact", "tolerance": null},
  {"label": "ii", "prompt_latex": "\\(\\mathrm{P}(A\\mid B)\\),", "correct_answer": "\\frac{1}{4}", "answer_type": "exact", "tolerance": null},
  {"label": "iii", "prompt_latex": "\\(\\mathrm{P}(B\\mid A)\\),", "correct_answer": "\\frac{3}{10}", "answer_type": "exact", "tolerance": null},
  {"label": "iv", "prompt_latex": "\\(\\mathrm{P}(A\\cup B)\\).", "correct_answer": "\\frac{19}{24}", "answer_type": "exact", "tolerance": null},
  {"label": "v", "prompt_latex": "State, with reasons, whether the events A and B are independent or mutually exclusive.", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);

-- Q3: choosing 4 from 10 people
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc222003-0000-0000-0000-000000000000',
  'bbbb0002-0000-0000-0000-000000000000',
  1,
  $$Choosing four from ten people$$,
  $$Four persons are chosen at random from a group of ten persons consisting of four men and six women. Three of the women are sisters. Calculate the probability that the four persons chosen will$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$Total ways \(\binom{10}{4}=210\). (i) four women: \(\frac{\binom{6}{4}}{210}=\frac{15}{210}=\frac{1}{14}\). (ii) two women, two men: \(\frac{\binom{6}{2}\binom{4}{2}}{210}=\frac{90}{210}=\frac{3}{7}\). (iii) include the three sisters (plus any 1 of the other 7): \(\frac{\binom{7}{1}}{210}=\frac{7}{210}=\frac{1}{30}\).$$,
  3,
  'H2 Math Tutorial (Probability)',
  $$[
  {"label": "i", "prompt_latex": "consist of four women,", "correct_answer": "\\frac{1}{14}", "answer_type": "exact", "tolerance": null},
  {"label": "ii", "prompt_latex": "consist of two women and two men,", "correct_answer": "\\frac{3}{7}", "answer_type": "exact", "tolerance": null},
  {"label": "iii", "prompt_latex": "include the three sisters.", "correct_answer": "\\frac{1}{30}", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);

-- Q4: soft-toy defects tree diagram
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc222004-0000-0000-0000-000000000000',
  'bbbb0002-0000-0000-0000-000000000000',
  1,
  $$Soft-toy defects$$,
  $$A manufacturer carried out a survey on the defects in their soft toys. It is found that the probability of a toy having poor stitching is 0.03 and that a toy with poor stitching has a probability 0.7 of splitting open. A toy without poor stitching has a probability 0.02 of splitting open.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(ii) \(\mathrm{P}(\text{split})=0.03(0.7)+0.97(0.02)=0.021+0.0194=0.0404\). (iii) exactly one defect \(=0.03(0.3)+0.97(0.02)=0.009+0.0194=0.0284\). (iv) \(\mathrm{P}(\text{poor stitching}\mid\text{split})=\frac{0.021}{0.0404}=0.520\).$$,
  4,
  'H2 Math Tutorial (Probability)',
  $$[
  {"label": "i", "prompt_latex": "Draw a tree diagram to represent this information.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ii", "prompt_latex": "Find the probability that a randomly chosen toy splits open.", "correct_answer": "0.0404", "answer_type": "range", "tolerance": 0.0005},
  {"label": "iii", "prompt_latex": "Find the probability that a randomly chosen toy has exactly one of the defects, poor stitching or splitting open.", "correct_answer": "0.0284", "answer_type": "range", "tolerance": 0.0005},
  {"label": "iv", "prompt_latex": "Given that a toy is split open, find the probability that the toy has poor stitching.", "correct_answer": "0.520", "answer_type": "range", "tolerance": 0.001}
]$$::jsonb
);

-- Q5: fifteen people in a line / circle
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc222005-0000-0000-0000-000000000000',
  'bbbb0002-0000-0000-0000-000000000000',
  2,
  $$Fifteen people: sisters and brothers$$,
  $$A group of fifteen people consists of one pair of sisters, one set of three brothers and ten other people. The fifteen people are arranged randomly in a line.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) sisters together: \(\frac{14!\,2!}{15!}=\frac{2}{15}\). (ii) brothers not all together: \(1-\frac{13!\,3!}{15!}=1-\frac{1}{35}=\frac{34}{35}\). (iii) sisters together and brothers together: \(\frac{12!\,2!\,3!}{15!}=\frac{2}{455}\). (iv) either/both \(=\frac{2}{15}+\frac{1}{35}-\frac{2}{455}=\frac{43}{273}\). (v) in a circle, sisters together: \(\frac{13!\,2!}{14!}=\frac{1}{7}\).$$,
  6,
  'H2 Math Tutorial (Probability)',
  $$[
  {"label": "i", "prompt_latex": "Find the probability that the sisters are next to each other.", "correct_answer": "\\frac{2}{15}", "answer_type": "exact", "tolerance": null},
  {"label": "ii", "prompt_latex": "Find the probability that the brothers are not all next to one another.", "correct_answer": "\\frac{34}{35}", "answer_type": "exact", "tolerance": null},
  {"label": "iii", "prompt_latex": "Find the probability that the sisters are next to each other and the brothers are all next to one another.", "correct_answer": "\\frac{2}{455}", "answer_type": "exact", "tolerance": null},
  {"label": "iv", "prompt_latex": "Find the probability that either the sisters are next to each other or the brothers are all next to one another or both.", "correct_answer": "\\frac{43}{273}", "answer_type": "exact", "tolerance": null},
  {"label": "v", "prompt_latex": "Instead the fifteen people are arranged in a circle. Find the probability that the sisters are next to each other.", "correct_answer": "\\frac{1}{7}", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);

-- Q6: mass-screening test for a disease
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc222006-0000-0000-0000-000000000000',
  'bbbb0002-0000-0000-0000-000000000000',
  2,
  $$Mass-screening test for a disease$$,
  $$A certain disease is present in 1 in 200 of the population. In a mass screening programme, a quick test for the disease is used but the test is not totally reliable. For someone who does have the disease there is a probability of 0.9 that the test will prove positive, whereas for someone who does not have the disease, there is a probability of 0.02 that the test will prove positive.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$Let \(\mathrm{P}(D)=\frac{1}{200}=0.005\). (a)(ii) \(\mathrm{P}(D\cap +)=0.005(0.9)=\frac{9}{2000}\). (a)(iii) \(\mathrm{P}(-)=0.005(0.1)+0.995(0.98)=\frac{2439}{2500}\). (a)(iv) \(\mathrm{P}(+)=0.0045+0.995(0.02)=0.0244\), so \(\mathrm{P}(D\mid +)=\frac{0.0045}{0.0244}=\frac{45}{244}\). (b) two positive tests: \(\mathrm{P}(D\mid ++)=\frac{0.005(0.9)^2}{0.005(0.9)^2+0.995(0.02)^2}=\frac{0.00405}{0.004448}=0.911\).$$,
  6,
  'H2 Math Tutorial (Probability)',
  $$[
  {"label": "ai", "prompt_latex": "(a) A person is chosen at random and tested. Copy and complete the tree diagram which illustrates the application of one test.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "aii", "prompt_latex": "(a)(ii) Find the probability that the person has the disease and the test is positive.", "correct_answer": "\\frac{9}{2000}", "answer_type": "exact", "tolerance": null},
  {"label": "aiii", "prompt_latex": "(a)(iii) Find the probability that the test is negative.", "correct_answer": "\\frac{2439}{2500}", "answer_type": "exact", "tolerance": null},
  {"label": "aiv", "prompt_latex": "(a)(iv) Given that the test is positive, find the probability that the person has the disease.", "correct_answer": "\\frac{45}{244}", "answer_type": "exact", "tolerance": null},
  {"label": "b", "prompt_latex": "(b) People for whom the test proves positive are recalled and re-tested. Find the probability that a person has the disease if the second test also proves positive.", "correct_answer": "0.911", "answer_type": "range", "tolerance": 0.001}
]$$::jsonb
);

-- Q7: multiple-choice question guessing model
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc222007-0000-0000-0000-000000000000',
  'bbbb0002-0000-0000-0000-000000000000',
  2,
  $$MCQ: knowing versus guessing$$,
  $$A multiple-choice question (MCQ) consists of 5 suggested answers, only one of which is correct. For each of the questions set for a particular topic, there is a probability of \(p\) that a student, Alice, knows the correct answer, and whenever she knows the correct answer she selects it. If she does not know the correct answer, she randomly selects one of the 5 suggested answers. The events K and C are defined as follows: K: Alice knows the correct answer; C: Alice selects the correct answer.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) \(\mathrm{P}(C)=p+(1-p)\cdot\frac15=\frac{1}{5}(4p+1)\). (ii) \(K'\cap C\) is the event that Alice does not know the correct answer yet still selects it (i.e. she guesses correctly). (iii) \(\mathrm{P}(K'\mid C)=\frac{(1-p)/5}{(4p+1)/5}=\frac{1-p}{4p+1}=\frac{1}{16}\Rightarrow 16(1-p)=4p+1\Rightarrow p=\frac{3}{4}\).$$,
  4,
  'H2 Math Tutorial (Probability)',
  $$[
  {"label": "i", "prompt_latex": "Find the probability, in terms of \\(p\\), that Alice selects the correct answer.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ii", "prompt_latex": "Describe what the event \\(K'\\cap C\\) represents in the context of this question.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "iii", "prompt_latex": "Given that \\(\\mathrm{P}(K'\\mid C)=\\dfrac{1}{16}\\), find the value of \\(p\\).", "correct_answer": "\\frac{3}{4}", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);

-- Q8: card game between A and B
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc222008-0000-0000-0000-000000000000',
  'bbbb0002-0000-0000-0000-000000000000',
  2,
  $$Card game between two players$$,
  $$In a game played by two people A and B, each player is given three cards with three different animal pictures printed on them. The players flash their cards simultaneously to indicate one of the three animals, 'elephant', 'cat' and 'mouse'. 'Elephant' defeats 'cat', 'cat' defeats 'mouse' and 'mouse' defeats 'elephant'. If the animals are the same, the round is a draw. At each round, A indicates 'elephant', 'cat' and 'mouse' with probabilities 0.3, 0.3 and 0.4 respectively, while the corresponding probabilities for B are 0.2, 0.5 and 0.3. The game continues until a winner is found. Find the probability that$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) draw \(=0.3(0.2)+0.3(0.5)+0.4(0.3)=0.33\). (ii) A wins a round: elephant beats cat \(0.3(0.5)\) + cat beats mouse \(0.3(0.3)\) + mouse beats elephant \(0.4(0.2)=0.15+0.09+0.08=0.32\). (iii) B wins first round \(=1-0.33-0.32=0.35\); given not a draw: \(\frac{0.35}{0.67}=\frac{35}{67}\). (iv) B wins the contest \(=\frac{\mathrm{P}(B\text{ wins a round})}{\mathrm{P}(\text{decisive round})}=\frac{0.35}{0.67}=\frac{35}{67}\).$$,
  4,
  'H2 Math Tutorial (Probability)',
  $$[
  {"label": "i", "prompt_latex": "a round ends in a draw,", "correct_answer": "0.33", "answer_type": "range", "tolerance": 0.005},
  {"label": "ii", "prompt_latex": "A is the winner in the first round,", "correct_answer": "0.32", "answer_type": "range", "tolerance": 0.005},
  {"label": "iii", "prompt_latex": "B is the winner in the first round given that the first round does not end in a draw,", "correct_answer": "\\frac{35}{67}", "answer_type": "exact", "tolerance": null},
  {"label": "iv", "prompt_latex": "B will be the winner in the contest.", "correct_answer": "\\frac{35}{67}", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);

-- Q9: spectacles survey (boys/girls proportion)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc222009-0000-0000-0000-000000000000',
  'bbbb0002-0000-0000-0000-000000000000',
  3,
  $$Spectacles survey$$,
  $$In a survey conducted by the National Eye Centre, it was found that \(p\%\) are boys and the remaining are girls. The probability that a randomly chosen boy wears spectacles is 0.3 and the probability that a randomly chosen girl wears spectacles is 0.24.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) \(\frac{p}{100}(0.3)+\frac{100-p}{100}(0.24)=0.267\Rightarrow 0.06p=2.7\Rightarrow p=45\). (ii) \(f(p)=\dfrac{\mathrm{P}(\text{girl}\cap\text{spectacles})}{\mathrm{P}(\text{spectacles})}=\dfrac{0.24(100-p)}{0.3p+0.24(100-p)}=\dfrac{4(100-p)}{400+p}\). \(f'(p)=\dfrac{-4(500)}{(400+p)^2}<0\) for all \(p\), so \(f\) is decreasing on \(0\le p\le100\): as the proportion of boys rises, the chance that a randomly chosen spectacle-wearer is a girl falls.$$,
  4,
  'H2 Math Tutorial (Probability)',
  $$[
  {"label": "i", "prompt_latex": "Find the value of \\(p\\), given that the probability that a randomly chosen child wears spectacles is 0.267.", "correct_answer": "45", "answer_type": "exact", "tolerance": null},
  {"label": "ii", "prompt_latex": "For a general value of \\(p\\), the probability that a randomly chosen child that wears spectacles is a girl is denoted by \\(f(p)\\). Show that \\(f(p)=\\dfrac{4(100-p)}{400+p}\\). Prove by differentiation that \\(f\\) is a decreasing function for \\(0\\le p\\le100\\), and explain what this statement means in the context of the question.", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);

-- Q10: events A, B, C with union/intersection reasoning
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc22200a-0000-0000-0000-000000000000',
  'bbbb0002-0000-0000-0000-000000000000',
  3,
  $$Bounds and independence for events A, B, C$$,
  $$For events A and B, it is given that \(\mathrm{P}(A)=\dfrac{5}{8}\) and \(\mathrm{P}(B)=\dfrac{2}{3}\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) greatest \(\mathrm{P}(A\cap B)=\min\!\left(\frac58,\frac23\right)=\frac58\); least \(=\mathrm{P}(A)+\mathrm{P}(B)-1=\frac{7}{24}\). With \(\mathrm{P}(A'\mid B')=\frac38\): (ii) \(\mathrm{P}(A'\cap B')=\frac38\cdot\frac13=\frac18\). (iii) \(\mathrm{P}(A\cup B)=1-\frac18=\frac78\). (iv) \(\mathrm{P}(A\cap B)=\frac58+\frac23-\frac78=\frac{5}{12}=\mathrm{P}(A)\mathrm{P}(B)\), so A and B are independent. (v) inclusion–exclusion: \(\frac{5}{8}+\frac23+\frac38-\frac{5}{12}-\frac14-\frac14+\mathrm{P}(A\cap B\cap C)=\frac{11}{12}\Rightarrow \mathrm{P}(A\cap B\cap C)=\frac16\).$$,
  10,
  'H2 Math Tutorial (Probability)',
  $$[
  {"label": "i", "prompt_latex": "Find the greatest and least possible values of \\(\\mathrm{P}(A\\cap B)\\).", "correct_answer": "greatest 5/8, least 7/24", "answer_type": "exact", "tolerance": null, "answers": [
    {"key": "greatest", "label": "greatest", "correct_answer": "\\frac{5}{8}", "answer_type": "exact", "tolerance": null},
    {"key": "least", "label": "least", "correct_answer": "\\frac{7}{24}", "answer_type": "exact", "tolerance": null}
  ]},
  {"label": "ii", "prompt_latex": "It is given in addition that \\(\\mathrm{P}(A'\\mid B')=\\dfrac{3}{8}\\). Find \\(\\mathrm{P}(A'\\cap B')\\).", "correct_answer": "\\frac{1}{8}", "answer_type": "exact", "tolerance": null},
  {"label": "iii", "prompt_latex": "Find \\(\\mathrm{P}(A\\cup B)\\).", "correct_answer": "\\frac{7}{8}", "answer_type": "exact", "tolerance": null},
  {"label": "iv", "prompt_latex": "Determine if A and B are independent events.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "v", "prompt_latex": "Given another event C such that \\(\\mathrm{P}(C)=\\dfrac{3}{8}\\), \\(\\mathrm{P}(A\\cap C)=\\mathrm{P}(B\\cap C)=\\dfrac{1}{4}\\) and \\(\\mathrm{P}(A\\cup B\\cup C)=\\dfrac{11}{12}\\), find \\(\\mathrm{P}(A\\cap B\\cap C)\\).", "correct_answer": "\\frac{1}{6}", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);
