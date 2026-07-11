-- Migration 050: CJC 2022 JC2 H2 Math Tutorial — Permutations and Combinations (DISCUSSION only, 12 questions)
-- Source: TUTORIAL/STATS QN/6.1 Permutations and Combinations + solution.pdf, DISCUSSION section (pp.28-30);
--         worked solutions cross-checked against TUTORIAL/ STATS SOLUTIONS/6.1 2022 PNC DQ Solution.pdf.
-- REVIEW PROBLEMS and Self-Practice deliberately excluded. Answers verified against the tutorial answer key.
-- Provenance stripped: generic source 'H2 Math Tutorial (Permutations and Combinations)', inline exam tags removed.
-- IDs: prefix 'cc22' (2022 stats set) + topic-index '1' (stats file 6.1) + 3-digit Q# -> cc221001..cc22100c. Topic bbbb0001.
-- All answers are integer counts -> graded 'exact'. No DDL: parts JSONB (008) already exists.

-- Q1: numbers from digits, size restriction (3 graded sub-parts)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc221001-0000-0000-0000-000000000000',
  'bbbb0001-0000-0000-0000-000000000000',
  1,
  $$Numbers formed from six distinct digits$$,
  $$Given the digits 1, 2, 3, 4, 6 and 8, and using each digit at most once, determine how many numbers can be formed if the number has to be$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) 1- or 2-digit numbers: \(6\times5+6=36\). (ii) 3-digit numbers: \(6\times5\times4=120\). (iii) 4-digit numbers: \(6\times5\times4\times3=360\).$$,
  4,
  'H2 Math Tutorial (Permutations and Combinations)',
  $$[
  {"label": "i", "prompt_latex": "less than 100,", "correct_answer": "36", "answer_type": "exact", "tolerance": null},
  {"label": "ii", "prompt_latex": "between 100 and 1000,", "correct_answer": "120", "answer_type": "exact", "tolerance": null},
  {"label": "iii", "prompt_latex": "between 1000 and 10000.", "correct_answer": "360", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);

-- Q2: largest number of wrong telephone numbers (single answer)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  'cc221002-0000-0000-0000-000000000000',
  'bbbb0001-0000-0000-0000-000000000000',
  1,
  $$Even five-digit telephone number$$,
  $$A girl wishes to phone a friend but cannot remember the exact number. She knows that it is a five-digit number, that it is even, and that it consists of the digits 2, 3, 4, 5 and 6 in some order. Using this information, find the largest number of different wrong telephone numbers she could try.$$,
  'exact',
  $$71$$,
  NULL,
  $$The last digit must be even: 3 choices from \(\{2,4,6\}\), and the other four digits fill the remaining places in \(4!\) ways, giving \(3\times4!=72\) even numbers. Excluding the one correct number leaves \(72-1=71\) wrong numbers.$$,
  3,
  'H2 Math Tutorial (Permutations and Combinations)'
);

-- Q3: dividing 6 people into groups
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc221003-0000-0000-0000-000000000000',
  'bbbb0001-0000-0000-0000-000000000000',
  1,
  $$Dividing 6 people into groups$$,
  $$Find the number of ways in which 6 people may be divided into groups of$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) Groups of 1, 2, 3 (all different sizes): \(\dfrac{6!}{1!\,2!\,3!}=60\). (ii) Groups of 2, 2, 2 (three equal groups): \(\dfrac{6!}{2!\,2!\,2!}\times\dfrac{1}{3!}=15\). (iii) Groups of 3, 1, 1, 1 (three equal groups of 1): \(\dfrac{6!}{3!\,1!\,1!\,1!}\times\dfrac{1}{3!}=20\).$$,
  3,
  'H2 Math Tutorial (Permutations and Combinations)',
  $$[
  {"label": "i", "prompt_latex": "1, 2 and 3,", "correct_answer": "60", "answer_type": "exact", "tolerance": null},
  {"label": "ii", "prompt_latex": "2, 2 and 2,", "correct_answer": "15", "answer_type": "exact", "tolerance": null},
  {"label": "iii", "prompt_latex": "3, 1, 1 and 1.", "correct_answer": "20", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);

-- Q4: four-letter words from the alphabet
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc221004-0000-0000-0000-000000000000',
  'bbbb0001-0000-0000-0000-000000000000',
  2,
  $$Four-letter words from 26 letters$$,
  $$A four-letter word can be formed from any of the 26 letters in the alphabet. Determine the number of such words with$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) Repetitions allowed: \(26^4=456976\). (ii) All different, exactly one vowel: choose the vowel's position (4) and the vowel (5), then fill the other 3 places with distinct consonants \(21\times20\times19\): \(4\times5\times21\times20\times19=159600\). (iii) Repetitions allowed, at least one vowel: \(26^4-21^4=456976-194481=262495\).$$,
  3,
  'H2 Math Tutorial (Permutations and Combinations)',
  $$[
  {"label": "i", "prompt_latex": "repetitions of the letters allowed,", "correct_answer": "456976", "answer_type": "exact", "tolerance": null},
  {"label": "ii", "prompt_latex": "different letters and containing exactly one vowel,", "correct_answer": "159600", "answer_type": "exact", "tolerance": null},
  {"label": "iii", "prompt_latex": "repetitions allowed and containing at least one vowel.", "correct_answer": "262495", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);

-- Q5: arrangements of ELEVEN
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc221005-0000-0000-0000-000000000000',
  'bbbb0001-0000-0000-0000-000000000000',
  2,
  $$Arrangements of the word ELEVEN$$,
  $$Find the number of arrangements of the 6 letters in the word ELEVEN (E, L, E, V, E, N) in which$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$There are three E's. (i) No restrictions: \(\dfrac{6!}{3!}=120\). (ii) The three E's consecutive (treat EEE as one block, arrange 4 units): \(4!=24\). (iii) First letter E, last letter N: arrange the middle E, E, L, V: \(\dfrac{4!}{2!}=12\). (iv) First E or last N or both: \(n(\text{first E})=\dfrac{5!}{2!}=60\), \(n(\text{last N})=\dfrac{5!}{3!}=20\), \(n(\text{both})=12\); \(60+20-12=68\).$$,
  4,
  'H2 Math Tutorial (Permutations and Combinations)',
  $$[
  {"label": "i", "prompt_latex": "there are no restrictions,", "correct_answer": "120", "answer_type": "exact", "tolerance": null},
  {"label": "ii", "prompt_latex": "all the 3 letters E are consecutive,", "correct_answer": "24", "answer_type": "exact", "tolerance": null},
  {"label": "iii", "prompt_latex": "the first letter is E and the last letter is N,", "correct_answer": "12", "answer_type": "exact", "tolerance": null},
  {"label": "iv", "prompt_latex": "the first letter is E or the last letter is N or both.", "correct_answer": "68", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);

-- Q6: books on a shelf, grouped and separated (single answer)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  'cc221006-0000-0000-0000-000000000000',
  'bbbb0001-0000-0000-0000-000000000000',
  2,
  $$Books on a shelf: grouped and separated$$,
  $$4 distinct green books, 4 distinct blue books and 2 distinct red books are arranged on a shelf. The green books are always placed together in the same order, but the red books are always separated. Calculate the number of ways in which this can be done.$$,
  'exact',
  $$3600$$,
  NULL,
  $$Treat the 4 green books (fixed internal order) as one block. Arrange this block with the 4 distinct blue books: \(5!=120\) ways, creating 6 gaps. Place the 2 distinct red books into 2 different gaps (separated): \(6\times5=30\). Total \(120\times30=3600\).$$,
  3,
  'H2 Math Tutorial (Permutations and Combinations)'
);

-- Q7: naval signals with coloured flags
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc221007-0000-0000-0000-000000000000',
  'bbbb0001-0000-0000-0000-000000000000',
  2,
  $$Naval signals from coloured flags$$,
  $$Naval signals are made by arranging coloured flags in a vertical line and the flags are read from top to bottom. How many different signals can be made from 1 green, 3 red and 2 blue flags if$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) All 6 flags used: \(\dfrac{6!}{1!\,3!\,2!}=60\). (ii) At least 5 used = (all 6) + (exactly 5). Exactly 5: drop one flag — drop a red \(\dfrac{5!}{2!2!}=30\), drop a blue \(\dfrac{5!}{3!}=20\), drop the green \(\dfrac{5!}{3!2!}=10\); total \(60\). So at least 5 \(=60+60=120\).$$,
  3,
  'H2 Math Tutorial (Permutations and Combinations)',
  $$[
  {"label": "i", "prompt_latex": "all 6 of the flags are used,", "correct_answer": "60", "answer_type": "exact", "tolerance": null},
  {"label": "ii", "prompt_latex": "at least 5 of them are used?", "correct_answer": "120", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);

-- Q8: round table with families
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc221008-0000-0000-0000-000000000000',
  'bbbb0001-0000-0000-0000-000000000000',
  3,
  $$Round table with two families$$,
  $$Three single men, two single women and two families take their places at a round table. Each of the two families consists of two parents and one child. Find the number of possible seating arrangements if$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) Same family together and the two single women separated: treat each family as a block. Arranging the 3 single men and 2 family-blocks around the table with the internal family orders, then slotting the 2 women into separated gaps gives \(17280\). (ii) Seats numbered (so rotations count as distinct) and each child seated between their parents: \(31680\).$$,
  2,
  'H2 Math Tutorial (Permutations and Combinations)',
  $$[
  {"label": "i", "prompt_latex": "members of the same family are seated together and the two single women are separated,", "correct_answer": "17280", "answer_type": "exact", "tolerance": null},
  {"label": "ii", "prompt_latex": "the seats are numbered and each child sits between their parents.", "correct_answer": "31680", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);

-- Q9: selections from a box with identical balls (single answer)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source)
VALUES (
  'cc221009-0000-0000-0000-000000000000',
  'bbbb0001-0000-0000-0000-000000000000',
  3,
  $$Selections from a box with identical balls$$,
  $$A box contains 8 balls, of which 3 are identical (and so are indistinguishable from one another) and the other 5 are different from each other. 3 balls are to be picked out of the box; the order in which they are picked out does not matter. Find the number of different possible selections of 3 balls.$$,
  'exact',
  $$26$$,
  NULL,
  $$Split by the number of identical balls chosen: 0 identical \(\binom{5}{3}=10\); 1 identical \(\binom{5}{2}=10\); 2 identical \(\binom{5}{1}=5\); 3 identical \(1\). Total \(10+10+5+1=26\).$$,
  3,
  'H2 Math Tutorial (Permutations and Combinations)'
);

-- Q10: the word CORRELATION
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc22100a-0000-0000-0000-000000000000',
  'bbbb0001-0000-0000-0000-000000000000',
  3,
  $$Arrangements of the word CORRELATION$$,
  $$Using the letters of the word "CORRELATION" (which contains two O's, two R's, and the single letters C, E, L, A, T, I, N), find the number of$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$CORRELATION has 11 letters with O and R each repeated twice. (i) A and T next to each other: treat AT as one block (2 internal orders) and arrange the resulting 10 units: \(\dfrac{10!}{2!\,2!}\times2=1814400\). (ii) 6-letter code words (accounting for the repeated O and R across the cases of how many pairs are used): \(114660\).$$,
  2,
  'H2 Math Tutorial (Permutations and Combinations)',
  $$[
  {"label": "i", "prompt_latex": "arrangements such that the two letters A and T are next to each other,", "correct_answer": "1814400", "answer_type": "exact", "tolerance": null},
  {"label": "ii", "prompt_latex": "6-letter code words that can be formed.", "correct_answer": "114660", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);

-- Q11: theatre seating + salad bar selections
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc22100b-0000-0000-0000-000000000000',
  'bbbb0001-0000-0000-0000-000000000000',
  2,
  $$Theatre seating and salad-bar selections$$,
  $$(a) Eight people go to the theatre and sit in a particular group of eight reserved seats in the front row. Three of the eight belong to one family and sit together.\\ (b) The salad bar at a restaurant has 6 separate bowls containing lettuce, tomatoes, cucumber, radishes, spring onions and beetroot respectively. John decides to visit the salad bar and make a selection. At each bowl, he can choose to take some of the contents or not.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(a)(i) Treat the family of 3 as a block (\(3!\) internal orders) and arrange with the other 5: \(6!\times3!=4320\). (a)(ii) From these, subtract the arrangements where the two who refuse to sit together are adjacent: \(4320-1440=2880\). (b)(i) Each of the 6 bowls is in or out, at least one taken: \(2^6-1=63\). (b)(ii) Choose 4 items including tomatoes = choose 3 more of the remaining 5 bowls: \(\binom{5}{3}=10\).$$,
  4,
  'H2 Math Tutorial (Permutations and Combinations)',
  $$[
  {"label": "ai", "prompt_latex": "(a)(i) If the other five people do not mind where they sit, find the number of possible seating arrangements for all eight people.", "correct_answer": "4320", "answer_type": "exact", "tolerance": null},
  {"label": "aii", "prompt_latex": "(a)(ii) If the other five people do not mind where they sit, except that two of them refuse to sit together, find the number of possible seating arrangements for all eight people.", "correct_answer": "2880", "answer_type": "exact", "tolerance": null},
  {"label": "bi", "prompt_latex": "(b)(i) Assuming that John takes some of the contents from at least one bowl, find how many different selections he can make.", "correct_answer": "63", "answer_type": "exact", "tolerance": null},
  {"label": "bii", "prompt_latex": "(b)(ii) John decides he is going to have 4 salad items, and one of them will be tomatoes. How many different selections can he make?", "correct_answer": "10", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);

-- Q12: committees and round-table seating from 10 people
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc22100c-0000-0000-0000-000000000000',
  'bbbb0001-0000-0000-0000-000000000000',
  3,
  $$Committees and round-table seating$$,
  $$A group of 10 people consists of 3 married couples and 4 single men.\\ (a) A committee of 4 is to be formed from the 10 people.\\ (b) The group sits at a round table with 10 seats.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(a)(i) \(\binom{10}{4}=210\). (a)(ii) At most 1 married couple = total \(-\) (exactly 2 couples): \(210-\binom{3}{2}=210-3=207\). (a)(iii) At least one man and at least one woman: \(210-\) (all men) \(-\) (all women) \(=210-\binom{7}{4}-\binom{3}{4}=210-35-0=175\). (b)(i) Each man next to his wife: treat each of the 3 couples as a block, giving \(3+4=7\) units round the table: \((7-1)!\times2^3=720\times8=5760\). (b)(ii) One man absent leaves 9 people; the empty seat fixes a reference point, so the 9 fill the remaining seats in \(9!=362880\) ways. (b)(iii) A couple absent leaves 8 people with 2 identical empty seats round the table: \(\dfrac{(10-1)!}{2!}=\dfrac{9!}{2}=181440\).$$,
  4,
  'H2 Math Tutorial (Permutations and Combinations)',
  $$[
  {"label": "ai", "prompt_latex": "(a)(i) How many different committees can be formed?", "correct_answer": "210", "answer_type": "exact", "tolerance": null},
  {"label": "aii", "prompt_latex": "(a)(ii) How many different committees can be formed if the committee can consist of at most 1 married couple?", "correct_answer": "207", "answer_type": "exact", "tolerance": null},
  {"label": "aiii", "prompt_latex": "(a)(iii) How many different committees can be formed if the committee consists of at least one man and at least one woman?", "correct_answer": "175", "answer_type": "exact", "tolerance": null},
  {"label": "bi", "prompt_latex": "(b)(i) If each man sits next to his wife, how many ways can they be seated?", "correct_answer": "5760", "answer_type": "exact", "tolerance": null},
  {"label": "bii", "prompt_latex": "(b)(ii) If one particular man is absent and the rest are allowed to sit without any restrictions, how many ways can they be seated?", "correct_answer": "362880", "answer_type": "exact", "tolerance": null},
  {"label": "biii", "prompt_latex": "(b)(iii) If a particular couple is absent and the rest are allowed to sit without any restrictions, how many ways can they be seated?", "correct_answer": "181440", "answer_type": "exact", "tolerance": null}
]$$::jsonb
);
