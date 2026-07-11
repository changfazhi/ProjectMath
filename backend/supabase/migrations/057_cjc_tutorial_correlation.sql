-- Migration 057: CJC 2022 JC2 H2 Math Tutorial — Correlation and Linear Regression (DISCUSSION only, 9 questions)
-- Source: TUTORIAL/STATS QN/6.8 Correlation and Linear Regression + solution.pdf, DISCUSSION section (pp.31-36);
--         worked solutions cross-checked against TUTORIAL/ STATS SOLUTIONS/6.8 2022 Correlation and Regression DQ Solution.pdf.
-- REVIEW PROBLEMS deliberately excluded. Answers verified against the tutorial answer key (re-derived where possible).
-- Provenance stripped: generic source 'H2 Math Tutorial (Correlation and Linear Regression)', inline exam tags removed.
-- IDs: prefix 'cc22' + topic-index '8' (stats file 6.8) + 3-digit Q# -> cc228001..cc228009. Topic bbbb0006.
-- Grading: r-values, model estimates and mean-point coordinates graded; scatter sketches, "comment"/"explain"/
--          "state whether" and full regression-equation statements left null. Concrete-data scatter sketches get
--          solution_graphs in migration 058. Q3(b) (destroyed-paper diagram, not reproducible) is excluded. No DDL.

-- Q1: sketching scatter diagrams for given r
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc228001-0000-0000-0000-000000000000',
  'bbbb0006-0000-0000-0000-000000000000',
  1,
  $$Sketching scatter diagrams for given r$$,
  $$(a) Eight pairs of values of variables \(x\) and \(y\) are measured. Draw a sketch of a possible scatter diagram of the data for each of the following cases.\\ (b) Draw separate diagrams, each with 8 points, all in the first quadrant, which represents the situation where the product moment correlation coefficient between variables \(x\) and \(y\) is as stated.$$,
  'exact',
  $$See solution$$,
  NULL,
  $$(a)(i) \(r\approx0\): points scattered with no linear trend (e.g. a cloud or a symmetric U-shape). (a)(ii) \(r\approx-0.8\): points falling from upper-left to lower-right, fairly tightly about a downward line. (b)(i) \(r=-1\): 8 points exactly on a straight line of negative gradient. (b)(ii) \(r=0\): 8 points with no linear trend. (b)(iii) \(0.5<r<0.9\): 8 points rising to the right, loosely about an upward line.$$,
  5,
  'H2 Math Tutorial (Correlation and Linear Regression)',
  $$[
  {"label": "ai", "prompt_latex": "(a)(i) the product moment correlation coefficient is approximately zero.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "aii", "prompt_latex": "(a)(ii) the product moment correlation coefficient is approximately −0.8.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "bi", "prompt_latex": "(b)(i) the correlation coefficient is −1.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "bii", "prompt_latex": "(b)(ii) the correlation coefficient is 0.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "biii", "prompt_latex": "(b)(iii) the correlation coefficient is between 0.5 and 0.9.", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);

-- Q2: aggregate vs monthly income
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc228002-0000-0000-0000-000000000000',
  'bbbb0006-0000-0000-0000-000000000000',
  1,
  $$Aggregate versus monthly income$$,
  $$The monthly incomes of 8 former classmates are tabulated against the aggregates that they scored in their Advanced Level Examinations (aggregate \(x\) : monthly income $y): 72 : 4400, 55 : 3550, 65 : 4000, 45 : 3000, 60 : 3800, 50 : 3200, 42 : 2850, 62 : 3950.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) From the GC, \(r=0.997\). (ii) A high correlation does not imply causation; both may be driven by other factors (e.g. ability, background), so "good results determine income" is not justified. (iii) Regression line of \(y\) on \(x\): \(y=52.4x+640\).$$,
  4,
  'H2 Math Tutorial (Correlation and Linear Regression)',
  $$[
  {"label": "i", "prompt_latex": "Obtain a scatter diagram and calculate the linear correlation coefficient.", "correct_answer": "0.997", "answer_type": "range", "tolerance": 0.001},
  {"label": "ii", "prompt_latex": "\"The strong correlation between a person's aggregate and his subsequent monthly income shows that good results determine one's income.\" Comment on this statement.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "iii", "prompt_latex": "Find the equation of the regression line of \\(y\\) on \\(x\\) (give the gradient and the y-intercept).", "correct_answer": "gradient 52.4, intercept 640", "answer_type": "exact", "tolerance": null, "answers": [
    {"key": "b", "label": "gradient", "correct_answer": "52.4", "answer_type": "range", "tolerance": 0.5},
    {"key": "a", "label": "y-intercept", "correct_answer": "640", "answer_type": "range", "tolerance": 10}
  ]}
]$$::jsonb
);

-- Q3: traffic flow and pollution
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc228003-0000-0000-0000-000000000000',
  'bbbb0006-0000-0000-0000-000000000000',
  1,
  $$Traffic flow and pollution$$,
  $$Traffic engineers are studying the correlation between traffic flow on a busy main road and air pollution. Traffic flow, \(x\), is reported each hour as the average flow in vehicles per hour. The air quality station provides an overall pollution reading, \(y\) (higher readings indicate more pollution). Data for a random sample of 8 hours (traffic flow \(x\) : pollution \(y\)): 1796 : 1.0, 1918 : 2.2, 2120 : 3.5, 2315 : 4.2, 2368 : 4.3, 2420 : 4.5, 2588 : 4.9, 2850 : 5.5. It is thought that \(y\) can be modelled by one of the formulae \(y=a+bx\) or \(y^2=c+dx\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(ii) \(r(x,y)=0.959\); \(r(x,y^2)=0.995\). (iii) \(y^2=c+dx\) is the better model since its \(|r|\) is closer to 1. (iv) Regression of \(y^2\) on \(x\): \(y^2=0.0279x-48.0\); at \(x=2000\), \(y^2=7.8\), so \(y=2.79\). (v) Correlation is not causation; the data support an association between traffic flow and pollution but cannot establish that heavy traffic causes it.$$,
  6,
  'H2 Math Tutorial (Correlation and Linear Regression)',
  $$[
  {"label": "i", "prompt_latex": "Draw the scatter diagram for these values, labelling the axes.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ii", "prompt_latex": "Find the value of the product moment correlation coefficient between (a) \\(x\\) and \\(y\\), and (b) \\(x\\) and \\(y^2\\).", "correct_answer": "r(x,y) = 0.959, r(x,y^2) = 0.995", "answer_type": "exact", "tolerance": null, "answers": [
    {"key": "r1", "label": "r(x,\\,y)", "correct_answer": "0.959", "answer_type": "range", "tolerance": 0.002},
    {"key": "r2", "label": "r(x,\\,y^2)", "correct_answer": "0.995", "answer_type": "range", "tolerance": 0.002}
  ]},
  {"label": "iii", "prompt_latex": "Use your answers to parts (i) and (ii) to explain which of \\(y=a+bx\\) or \\(y^2=c+dx\\) is the better model.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "iv", "prompt_latex": "It is required to estimate the value of \\(y\\) for which \\(x=2000\\). Find the equation of a suitable regression line, and use it to find the required estimate of \\(y\\).", "correct_answer": "2.79", "answer_type": "range", "tolerance": 0.05},
  {"label": "v", "prompt_latex": "The local newspaper carries a headline \"Heavy traffic causes air pollution\". Comment briefly on the validity of this headline in the light of your results.", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);

-- Q4: ages and prices of used cars
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc228004-0000-0000-0000-000000000000',
  'bbbb0006-0000-0000-0000-000000000000',
  2,
  $$Ages and prices of used cars$$,
  $$(a) Sketch a scatter diagram that might be expected when \(x\) and \(y\) are related approximately by \(y=px^2+t\) in each of the cases (i) and (ii) below. Each diagram should include 6 points, approximately equally spaced with respect to \(x\), with all x-values positive.\\ (b) The ages in months (\(m\)) and prices in dollars (\(P\)) of a random sample of ten used cars of a certain model are given in the table (\(m\) : \(P\)): 11 : 112800, 20 : 102600, 28 : 76500, 36 : 72000, 40 : 72000, 47 : 69000, 58 : 65800, 62 : 57000, 68 : 50600, 75 : 47600. It is thought that the price after \(m\) months can be modelled by \(P=am+b\) or \(P=c\ln m+d\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(a)(i) \(p,t>0\): an upward-curving (concave-up) set of 6 rising points. (a)(ii) \(p<0,t>0\): a downward-curving set of 6 points, high on the left and falling. (b)(i) \(r(m,P)=-0.9470\); \(r(\ln m,P)=-0.9749\). (b)(ii) \(P=c\ln m+d\) fits better (\(|r|\) closer to 1): \(P=-33659.72805\ln m+195693.5593\). (b)(iii) at \(m=50\), \(P=-33659.728\ln 50+195693.56\approx\$64\,000\).$$,
  6,
  'H2 Math Tutorial (Correlation and Linear Regression)',
  $$[
  {"label": "ai", "prompt_latex": "(a)(i) \\(p\\) and \\(t\\) are both positive.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "aii", "prompt_latex": "(a)(ii) \\(p\\) is negative and \\(t\\) is positive.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "bi", "prompt_latex": "(b)(i) Find, corrected to 4 decimal places, the value of the product moment correlation coefficient between (A) \\(m\\) and \\(P\\), and (B) \\(\\ln m\\) and \\(P\\).", "correct_answer": "r(m,P) = -0.9470, r(ln m,P) = -0.9749", "answer_type": "exact", "tolerance": null, "answers": [
    {"key": "rA", "label": "r(m,\\,P)", "correct_answer": "-0.9470", "answer_type": "range", "tolerance": 0.001},
    {"key": "rB", "label": "r(\\ln m,\\,P)", "correct_answer": "-0.9749", "answer_type": "range", "tolerance": 0.001}
  ]},
  {"label": "bii", "prompt_latex": "(b)(ii) Explain which of \\(P=am+b\\) and \\(P=c\\ln m+d\\) is the better model and find the equation of a suitable regression line for this model.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "biii", "prompt_latex": "(b)(iii) Use the equation of your regression line to estimate the price of a car that is 50 months old.", "correct_answer": "64000", "answer_type": "range", "tolerance": 500}
]$$::jsonb
);

-- Q5: world-record mile times
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc228005-0000-0000-0000-000000000000',
  'bbbb0006-0000-0000-0000-000000000000',
  2,
  $$World-record mile times$$,
  $$The table gives the world record time, in seconds above 3 minutes 30 seconds, for running 1 mile as at 1 January in various years (year \(x\) : time \(t\)): 1930 : 40.4, 1940 : 36.4, 1950 : 31.3, 1960 : 24.5, 1970 : 21.1, 1980 : 19.0, 1990 : 16.3, 2000 : 13.1.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) The scatter falls steadily but curves (levelling off). (ii) A straight line captures the overall downward trend but the points curve, so a linear model is only roughly appropriate; physically the record cannot fall forever. (iii) A quadratic would eventually turn and rise, predicting times that increase again — impossible for a record — so it fails for long-term predictions. (iv) Fitting \(\ln t=34.9-0.0161x\): at \(x=2010\), \(\ln t=2.55\), \(t\approx11.4\) s above 3:30, i.e. about 3 min 41.4 s. The prediction is an extrapolation beyond the data, so it is unreliable.$$,
  6,
  'H2 Math Tutorial (Correlation and Linear Regression)',
  $$[
  {"label": "i", "prompt_latex": "Draw a scatter diagram to illustrate the data.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ii", "prompt_latex": "Comment on whether a linear model would be appropriate, referring both to the scatter diagram and the context of the question.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "iii", "prompt_latex": "Explain why in this context a quadratic model would probably not be appropriate for long-term predictions.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "iv", "prompt_latex": "Fit a model of the form \\(\\ln t=a+bx\\) to the data, and use it to predict the world record time as at 1 January 2010. Comment on the reliability of your prediction.", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);

-- Q6: drag force in a wind tunnel
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc228006-0000-0000-0000-000000000000',
  'bbbb0006-0000-0000-0000-000000000000',
  2,
  $$Drag force in a wind tunnel$$,
  $$A car is placed in a wind tunnel and the drag force \(F\) for different wind speeds \(v\), in appropriate units, is recorded (\(v\) : \(F\)): 0 : 0, 4 : 2.5, 8 : 5.1, 12 : 8.8, 16 : 11.2, 20 : 13.6, 24 : 17.6, 28 : 22.0, 32 : 27.8, 36 : 33.9. It is thought that \(F\) can be modelled by \(F=a+bv\) or \(F=c+dv^2\).$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(ii) \(r(v,F)=0.9860\); \(r(v^2,F)=0.9907\). (iii) \(F=c+dv^2\) is slightly better (\(|r|\) closer to 1). (iv) Regression of \(F\) on \(v^2\): \(F=0.0242v^2+3.20\); at \(F=26.0\), \(v^2=942\), \(v=30.7\). Neither the regression of \(v\) on \(F\) nor \(v^2\) on \(F\) should be used because \(F\) (not \(v\)) is the controlled/independent variable, so we regress \(F\) on \(v^2\).$$,
  6,
  'H2 Math Tutorial (Correlation and Linear Regression)',
  $$[
  {"label": "i", "prompt_latex": "Draw the scatter diagram for these values, labelling the axes clearly.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ii", "prompt_latex": "Find, correct to 4 decimal places, the value of the product moment correlation coefficient between (a) \\(v\\) and \\(F\\), and (b) \\(v^2\\) and \\(F\\).", "correct_answer": "r(v,F) = 0.9860, r(v^2,F) = 0.9907", "answer_type": "exact", "tolerance": null, "answers": [
    {"key": "r1", "label": "r(v,\\,F)", "correct_answer": "0.9860", "answer_type": "range", "tolerance": 0.001},
    {"key": "r2", "label": "r(v^2,\\,F)", "correct_answer": "0.9907", "answer_type": "range", "tolerance": 0.001}
  ]},
  {"label": "iii", "prompt_latex": "Use your answers to parts (i) and (ii) to explain which of \\(F=a+bv\\) or \\(F=c+dv^2\\) is the better model.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "iv", "prompt_latex": "It is required to estimate the value of \\(v\\) for which \\(F=26.0\\). Find the equation of a suitable regression line and use it to find the required estimate. Explain why neither the regression line of \\(v\\) on \\(F\\) nor the regression line of \\(v^2\\) on \\(F\\) should be used.", "correct_answer": "30.7", "answer_type": "range", "tolerance": 0.2}
]$$::jsonb
);

-- Q7: electric-motor efficiency
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc228007-0000-0000-0000-000000000000',
  'bbbb0006-0000-0000-0000-000000000000',
  3,
  $$Electric-motor efficiency$$,
  $$A website about electric motors gives the percentage efficiency of motors depending on their power (horsepower). Xian has copied the following table for a particular motor, but he has copied one of the efficiency values wrongly (power \(x\) : efficiency \(y\%\)): 1 : 72.5, 1.5 : 82.5, 2 : 84.0, 3 : 87.4, 5 : 87.5, 7.5 : 88.5, 10 : 89.5, 20 : 90.2, 30 : 91.0, 40 : 91.7, 50 : 92.4. For parts (ii)–(v) you should exclude the wrongly copied point.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) The point that stands away from the smooth increasing trend is \((3,87.4)\). (ii) \(y\) increases at a decreasing rate, so it is not linear in \(x\). (iii) For \(y=\frac{c}{x}+d\): as \(x\) grows \(y\) rises toward \(d\), so \(c<0\) and \(d>0\). (iv) Regressing \(y\) on \(\frac1x\) (excluding the outlier): \(r=-0.980\), \(c=-17.5\), \(d=91.8\). (v) At the wrongly copied point \(x=3\): \(y=\frac{-17.5}{3}+91.8=85.9\); reliable because \(x=3\) is within the data range (interpolation) and \(|r|\) is close to 1.$$,
  10,
  'H2 Math Tutorial (Correlation and Linear Regression)',
  $$[
  {"label": "i", "prompt_latex": "Plot a scatter diagram for these values, labelling the axes. On your diagram, circle the point that Xian has copied wrongly.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ii", "prompt_latex": "Explain from your scatter diagram why the relationship between \\(x\\) and \\(y\\) should not be modelled by an equation of the form \\(y=ax+b\\).", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "iii", "prompt_latex": "Suppose that the relationship between \\(x\\) and \\(y\\) is modelled by \\(y=\\dfrac{c}{x}+d\\), where \\(c\\) and \\(d\\) are constants. State with a reason whether each of \\(c\\) and \\(d\\) is positive or negative.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "iv", "prompt_latex": "Find the product moment correlation coefficient and the constants \\(c\\) and \\(d\\) for the model in part (iii).", "correct_answer": "r = -0.980, c = -17.5, d = 91.8", "answer_type": "exact", "tolerance": null, "answers": [
    {"key": "r", "label": "r", "correct_answer": "-0.980", "answer_type": "range", "tolerance": 0.002},
    {"key": "c", "label": "c", "correct_answer": "-17.5", "answer_type": "range", "tolerance": 0.3},
    {"key": "d", "label": "d", "correct_answer": "91.8", "answer_type": "range", "tolerance": 0.3}
  ]},
  {"label": "v", "prompt_latex": "Use the model \\(y=\\dfrac{c}{x}+d\\), with the values of \\(c\\) and \\(d\\) found in (iv), to estimate the efficiency value \\(y\\) that Xian has copied wrongly. Give two reasons why you would expect this estimate to be reliable.", "correct_answer": "85.9", "answer_type": "range", "tolerance": 0.2}
]$$::jsonb
);

-- Q8: consumer price index (housing vs food)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc228008-0000-0000-0000-000000000000',
  'bbbb0006-0000-0000-0000-000000000000',
  3,
  $$Consumer price index$$,
  $$The table shows the housing and food price index from 2005 to 2012, with 2005 as the base period (index 100). Year : Housing index \(x\) : Food index \(y\) — 2005 : 100 : 100; 2006 : 100.7 : 101.6; 2007 : 102.3 : 104.6; 2008 : 116.8 : 112.6; 2009 : 123.1 : 115.2; 2010 : 124.3 : 116.8; 2011 : (missing) : 120.3; 2012 : 148 : 123.1.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i) With the regression line of \(y\) on \(x\), \(y=54.271+0.48363x\); putting \(y=120.3\) gives \(x=\frac{120.3-54.271}{0.48363}=136\) (nearest integer). (iii) Regression of \(\sqrt{x}\) on \(y\): \(\sqrt{x}=0.0896y+0.860\); at \(y=134.6\), \(\sqrt{x}=12.92\), \(x=167\). This is an extrapolation beyond the data range, so it may be unreliable. (iv) \(r(y,\sqrt{x})=0.979\). (v) A linear rescaling of the variables does not change \(r\), so the value is unchanged.$$,
  10,
  'H2 Math Tutorial (Correlation and Linear Regression)',
  $$[
  {"label": "i", "prompt_latex": "Show that the value of the missing housing price index for 2011 is 136 (nearest integer), given that the regression line of \\(y\\) on \\(x\\) is \\(y=54.271+0.48363x\\), correct to 5 significant figures.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ii", "prompt_latex": "Draw the scatter diagram for these values, labelling the axes clearly. Comment on the suitability of the linear model.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "iii", "prompt_latex": "It is required to estimate the housing price index in 2016 where the food price index in 2016 is 134.6. Find the equation of an appropriate regression line for \\(y\\) and \\(\\sqrt{x}\\) and use it to find the required estimate. Explain why this estimate might not be reliable.", "correct_answer": "167", "answer_type": "range", "tolerance": 2},
  {"label": "iv", "prompt_latex": "Find the product moment correlation coefficient between \\(y\\) and \\(\\sqrt{x}\\).", "correct_answer": "0.979", "answer_type": "range", "tolerance": 0.002},
  {"label": "v", "prompt_latex": "To simplify recordings and calculations, it would be more convenient to tabulate \\(\\dfrac{x}{100}\\) and \\(\\dfrac{y}{100}\\) instead. Without any further calculations, explain if the product moment correlation coefficient between \\(\\sqrt{\\dfrac{x}{100}}\\) and \\(\\dfrac{y}{100}\\) would differ from the value obtained in part (iv).", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);

-- Q9: fuel consumption versus speed
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'cc228009-0000-0000-0000-000000000000',
  'bbbb0006-0000-0000-0000-000000000000',
  3,
  $$Fuel consumption versus speed$$,
  $$Abi and Bhani find the fuel consumption for a car driven at different constant speeds. The table shows the fuel consumption, \(y\) km per litre, for different constant speeds, \(x\) km per hour (\(x\) : \(y\)): 40 : 22, 45 : 20, 50 : 18, 55 : 17, 60 : 16. Abi models the data using the line \(y=35-\frac13x\). Bhani models the same data using a straight line passing through the points \((40,22)\) and \((55,17)\); the sum of the squares of the residuals for Bhani's line is 1.$$,
  'exact',
  $$See individual parts$$,
  NULL,
  $$(i)(c) Residuals for Abi's line \(0.33,0,-0.33,0.33,1\): sum of squares \(=1.33\). (ii) Bhani's line has the smaller sum of squares (1 < 1.33), so it is the better fit. (iii) The least-squares line passes through \((\bar{x},\bar{y})=(50,18.6)\). (iv) \(y=-0.3x+33.6\); \(r\approx-0.985\). (v) At \(x=30\), \(y=24.6\); unreliable because \(x=30\) is outside the data range (extrapolation). (vi) A zero sum of squares means all Cerie's data points lie exactly on the regression line (a perfect straight line).$$,
  12,
  'H2 Math Tutorial (Correlation and Linear Regression)',
  $$[
  {"label": "ia", "prompt_latex": "(i)(a),(b) On the grid, draw a scatter diagram of the data, draw the line \\(y=35-\\frac13x\\), and mark the residual for each point.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ic", "prompt_latex": "(i)(c) Calculate the sum of the squares of the residuals for Abi's line.", "correct_answer": "1.33", "answer_type": "range", "tolerance": 0.05},
  {"label": "id", "prompt_latex": "(i)(d) Explain why, in general, the sum of the squares of the residuals rather than the sum of the residuals is used.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "ii", "prompt_latex": "State, with a reason, which of the two models, Abi's or Bhani's, gives a better fit.", "correct_answer": null, "answer_type": null, "tolerance": null},
  {"label": "iii", "prompt_latex": "State the coordinates of the point that the least squares regression line must pass through.", "correct_answer": "(50, 18.6)", "answer_type": "exact", "tolerance": null, "answers": [
    {"key": "x", "label": "\\bar{x}", "correct_answer": "50", "answer_type": "range", "tolerance": 0.05},
    {"key": "y", "label": "\\bar{y}", "correct_answer": "18.6", "answer_type": "range", "tolerance": 0.05}
  ]},
  {"label": "iv", "prompt_latex": "Use your calculator to find the equation of the least squares regression line of \\(y\\) on \\(x\\). State the value of the product moment correlation coefficient.", "correct_answer": "y = -0.3x + 33.6, r = -0.985", "answer_type": "exact", "tolerance": null, "answers": [
    {"key": "b", "label": "gradient", "correct_answer": "-0.3", "answer_type": "range", "tolerance": 0.01},
    {"key": "a", "label": "y-intercept", "correct_answer": "33.6", "answer_type": "range", "tolerance": 0.1},
    {"key": "r", "label": "r", "correct_answer": "-0.985", "answer_type": "range", "tolerance": 0.002}
  ]},
  {"label": "v", "prompt_latex": "Use the equation of the regression line to estimate the fuel consumption when the speed is 30 km per hour. Explain whether you would expect this value to be reliable.", "correct_answer": "24.6", "answer_type": "range", "tolerance": 0.2},
  {"label": "vi", "prompt_latex": "Cerie performs a similar experiment on a different car. She finds that the sum of the squares of the residuals for her line is 0. What can you deduce about the data points in Cerie's experiment?", "correct_answer": null, "answer_type": null, "tolerance": null}
]$$::jsonb
);
