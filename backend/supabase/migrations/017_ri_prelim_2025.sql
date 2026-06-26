-- 017_ri_prelim_2025.sql
-- Raffles Institution H2 Mathematics (9758) Preliminary Examination 2025 -- Paper 1
-- 11 questions, UUIDs e0250001-e0250011

-- Q1 [4] App. of Differentiation
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'e0250001-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  2,
  'Curve constants from normal and axis conditions',
  $$A curve has equation \(y = ax + b + \dfrac{c}{x^2-1}\), where \(a\), \(b\) and \(c\) are real constants. It is given that the curve crosses the \(x\)-axis at \(x = 2\). The normal to the curve at the point \((0,\,3)\) meets the \(x\)-axis at \(x = 7.5\).$$,
  'exact',
  '-6',
  NULL,
  $$Since \((2,0)\) lies on the curve: \(2a + b + \tfrac{1}{3}c = 0\) ...(1). Since \((0,3)\) lies on the curve: \(b - c = 3\) ...(2). \[\frac{dy}{dx} = a - \frac{2cx}{(x^2-1)^2}\] Gradient of normal at \((0,3)\): \(\dfrac{3-0}{0-7.5} = -\dfrac{2}{5}\), so gradient of tangent \(= \dfrac{5}{2}\), giving \(a = \dfrac{5}{2}\). Substituting into (1) and using (2): \(5 + b + \tfrac{1}{3}c = 0\) and \(b - c = 3\), giving \(c = -6\) and \(b = -3\).$$,
  4,
  'RI H2 Math Prelim 2025 Paper 1',
  $$[
    {"label":"a","prompt_latex":"Find the value of \\(a\\). \\([2]\\)","correct_answer":"\\frac{5}{2}","answer_type":"exact","tolerance":null},
    {"label":"b","prompt_latex":"Find the value of \\(b\\). \\([1]\\)","correct_answer":"-3","answer_type":"exact","tolerance":null},
    {"label":"c","prompt_latex":"Find the value of \\(c\\). \\([1]\\)","correct_answer":"-6","answer_type":"exact","tolerance":null}
  ]$$::jsonb
);

-- Q2 [4] App. of Differentiation
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'e0250002-0000-0000-0000-000000000000',
  'aaaa0013-0000-0000-0000-000000000000',
  2,
  'Rate of change of gradient on y = x arcsin x',
  $$The point \(P\) travels along the curve \(C\) with equation \(y = x\sin^{-1}x,\ -1 < x < 1\). Let the gradient of the curve \(C\) at the point \(P\) be \(m\). If the \(x\)-coordinate of \(P\) is increasing at the rate of 9 units per second when \(x = \dfrac{1}{2}\), find the exact value of the rate at which \(m\) is changing at this instant. \([4]\)$$,
  'exact',
  $$14\sqrt{3}$$,
  NULL,
  $$\(m = \dfrac{dy}{dx} = \sin^{-1}x + \dfrac{x}{\sqrt{1-x^2}}\). Differentiating: \[\frac{dm}{dx} = \frac{1}{\sqrt{1-x^2}} + \frac{\sqrt{1-x^2} - x\cdot\frac{-x}{\sqrt{1-x^2}}}{1-x^2} = \frac{2-x^2}{\sqrt{(1-x^2)^3}}\] When \(x = \dfrac{1}{2}\), \(\dfrac{dx}{dt} = 9\): \[\frac{dm}{dt} = \frac{dm}{dx}\cdot\frac{dx}{dt} = \frac{2-\frac{1}{4}}{\sqrt{\!\left(\frac{3}{4}\right)^{\!3}}} \times 9 = \frac{\frac{7}{4}}{\frac{3\sqrt{3}}{8}} \times 9 = \frac{14\sqrt{3}}{9}\times 9 = 14\sqrt{3}\]$$,
  4,
  'RI H2 Math Prelim 2025 Paper 1',
  $$[
    {"label":"a","prompt_latex":"Find the exact value of the rate at which \\(m\\) is changing at this instant. \\([4]\\)","correct_answer":"14\\sqrt{3}","answer_type":"exact","tolerance":null}
  ]$$::jsonb
);

-- Q3 [8] Vector (Basic)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'e0250003-0000-0000-0000-000000000000',
  'aaaa0008-0000-0000-0000-000000000000',
  3,
  'Vectors with magnitude condition and cross product',
  $$Relative to the origin \(O\), the points \(A\) and \(C\) have position vectors \(\mathbf{a}\) and \(2\mathbf{b}\) such that \[\mathbf{a} = 5p\,\mathbf{i} - 2p\,\mathbf{j} + 4p\,\mathbf{k} \quad \text{and} \quad \mathbf{b} = \mathbf{i} - 2\mathbf{j} + 2\mathbf{k},\] where \(p\) is a positive constant. It is given that \(|\mathbf{a}| = 2|\mathbf{b}|\).$$,
  'exact',
  '0',
  NULL,
  $$(a) \(|\mathbf{a}| = \sqrt{(5p)^2+(-2p)^2+(4p)^2} = 3\sqrt{5}\,p\). \(|\mathbf{b}| = 3\). Setting \(3\sqrt{5}\,p = 6\): \(p = \dfrac{2\sqrt{5}}{5}\). (b) \((\mathbf{a}+2\mathbf{b})\cdot(\mathbf{a}-2\mathbf{b}) = |\mathbf{a}|^2 - 4|\mathbf{b}|^2 = 36 - 36 = 0\). (c) \[\mathbf{a}\times\mathbf{b} = p\begin{pmatrix}5\\-2\\4\end{pmatrix}\times\begin{pmatrix}1\\-2\\2\end{pmatrix} = p\begin{pmatrix}4\\-6\\-8\end{pmatrix} = \frac{4\sqrt{5}}{5}\begin{pmatrix}2\\-3\\-4\end{pmatrix}\] Area of \(\triangle OAC = |\mathbf{a}\times\mathbf{b}| = \dfrac{4\sqrt{5}}{5}\sqrt{29} = \dfrac{4\sqrt{145}}{5}\). (d) \(\overrightarrow{OD}=\mathbf{a}+2\mathbf{b}\) and \(\overrightarrow{CA}=\mathbf{a}-2\mathbf{b}\) are the diagonals of parallelogram \(OADC\). From (b), \(OD\perp CA\). Area of \(\triangle OAC = \tfrac{1}{2}\cdot\tfrac{1}{2}|OD|\cdot|CA| = \tfrac{1}{4}|\mathbf{a}+2\mathbf{b}||\mathbf{a}-2\mathbf{b}| = |\mathbf{a}\times\mathbf{b}|\).$$,
  8,
  'RI H2 Math Prelim 2025 Paper 1',
  $$[
    {"label":"a","prompt_latex":"Find the exact value of \\(p\\). \\([2]\\)","correct_answer":"\\frac{2\\sqrt{5}}{5}","answer_type":"exact","tolerance":null},
    {"label":"b","prompt_latex":"Evaluate \\((\\mathbf{a}+2\\mathbf{b})\\cdot(\\mathbf{a}-2\\mathbf{b})\\). \\([1]\\)","correct_answer":"0","answer_type":"exact","tolerance":null},
    {"label":"c","prompt_latex":"Evaluate \\(\\mathbf{a}\\times\\mathbf{b}\\) and hence find the area of triangle \\(OAC\\). \\([3]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"d","prompt_latex":"Use a geometrical reason to explain why \\(|\\mathbf{a}\\times\\mathbf{b}| = \\dfrac{1}{4}(|\\mathbf{a}+2\\mathbf{b}|)(|\\mathbf{a}-2\\mathbf{b}|)\\). \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null}
  ]$$::jsonb
);

-- Q4 [10] Integration Technique
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'e0250004-0000-0000-0000-000000000000',
  'aaaa0015-0000-0000-0000-000000000000',
  3,
  'Partial fractions and integration by parts with ln',
  $$$$,
  'exact',
  '',
  NULL,
  $$(a) Let \(\dfrac{9x}{(2x-1)(x+1)^2} = \dfrac{A}{2x-1} + \dfrac{B}{x+1} + \dfrac{C}{(x+1)^2}\). Then \(9x \equiv A(x+1)^2 + B(2x-1)(x+1) + C(2x-1)\). Sub \(x=\tfrac{1}{2}\): \(A=2\). Sub \(x=-1\): \(C=3\). Comparing \(x^2\): \(A+2B=0\Rightarrow B=-1\). \[\int\frac{9x}{(2x-1)(x+1)^2}\,dx = \ln\!\left|\frac{2x-1}{x+1}\right| - \frac{3}{x+1} + c\] (b)(i) \(\dfrac{d}{dx}\!\left(\dfrac{1}{x^2+1}\right) = \dfrac{-2x}{(x^2+1)^2}\). (b)(ii) \(\dfrac{d}{dx}\ln\sqrt{x^2+1} = \dfrac{x}{x^2+1}\). (b)(iii) IBP with \(u = \ln\sqrt{x^2+1}\), \(v = \dfrac{1}{x^2+1}\): \[\int\frac{x\ln\sqrt{x^2+1}}{(x^2+1)^2}\,dx = -\frac{\ln\sqrt{x^2+1}}{2(x^2+1)} + \frac{1}{2}\int\frac{x}{(x^2+1)^2}\,dx = -\frac{\ln(x^2+1)+1}{4(x^2+1)}+c\]$$,
  10,
  'RI H2 Math Prelim 2025 Paper 1',
  $$[
    {"label":"a","prompt_latex":"Find \\(\\displaystyle\\int \\frac{9x}{(2x-1)(x+1)^2}\\,dx\\). \\([4]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"bi","prompt_latex":"Differentiate \\(\\dfrac{1}{x^2+1}\\) with respect to \\(x\\). \\([1]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"bii","prompt_latex":"Differentiate \\(\\ln\\sqrt{x^2+1}\\) with respect to \\(x\\). \\([1]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"biii","prompt_latex":"Hence find \\(\\displaystyle\\int \\frac{x\\ln\\sqrt{x^2+1}}{(x^2+1)^2}\\,dx\\). \\([4]\\)","correct_answer":null,"answer_type":null,"tolerance":null}
  ]$$::jsonb
);

-- Q5 [9] Graphing Techniques
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'e0250005-0000-0000-0000-000000000000',
  'aaaa0001-0000-0000-0000-000000000000',
  2,
  'Sketching f-prime and 1/f; sequence of transformations',
  $$The diagram shows the sketch of \(y = \mathrm{f}(x)\). The curve passes through \((1,0)\) and \((3,0)\), has turning points at \((1,0)\) and \((4,4)\), and asymptotes \(x=0\), \(x=2\), and \(y=2\).$$,
  'exact',
  '',
  NULL,
  $$(a)(i) \(y = \mathrm{f}'(x)\): zeros at \(x=1\) and \(x=4\) (turning points of \(\mathrm{f}\)), vertical asymptotes \(x=0\) and \(x=2\), horizontal asymptote \(y=0\). (a)(ii) \(y = \dfrac{1}{\mathrm{f}(x)}\): vertical asymptotes at \(x=1\) and \(x=3\) (zeros of \(\mathrm{f}\)), horizontal asymptote \(y=\tfrac{1}{2}\), turning point \(\left(4,\tfrac{1}{4}\right)\). (b) Note \(\dfrac{x^2+1}{x} = x + \dfrac{1}{x}\) and \(\dfrac{2x^2-5x+4}{x-2} = 2x-1+\dfrac{2}{x-2}\). Sequence: (A) Translate \(+2\) in the \(x\)-direction. (B) Scale parallel to the \(y\)-axis by factor 2. (C) Translate \(+3\) in the \(y\)-direction.$$,
  9,
  'RI H2 Math Prelim 2025 Paper 1',
  $$[
    {"label":"ai","prompt_latex":"Sketch the graph of \\(y = \\mathrm{f}'(x)\\), showing clearly the main features. \\([3]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"aii","prompt_latex":"Sketch the graph of \\(y = \\dfrac{1}{\\mathrm{f}(x)}\\), showing clearly the main features. \\([3]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"b","prompt_latex":"Describe a sequence of transformations which transforms the graph of \\(y = \\dfrac{x^2+1}{x}\\) to the graph of \\(y = \\dfrac{2x^2-5x+4}{x-2}\\). \\([3]\\)","correct_answer":null,"answer_type":null,"tolerance":null}
  ]$$::jsonb
);

-- Q6 [9] Sequences & Series
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'e0250006-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  2,
  'Geometric series 99% condition; AP with odd-integer additions',
  $$$$,
  'exact',
  $$\frac{920}{3}$$,
  NULL,
  $$(a) \(S_{4m} = 10(1-0.8^{4m})\), \(S_\infty = 10\). Need \(0.8^{4m} < 0.01\Rightarrow 4m > \dfrac{\ln 0.01}{\ln 0.8} \approx 20.637\). Since \(4m\) is a positive integer, \(4m \geq 21\), so least \(m = \dfrac{21}{4}\). (b)(i) Sum of all terms of \(A\): \(\tfrac{n}{2}[2a+(n-1)d]=676\) ...(1). Sum of all terms of \(B\): \(676 + n^2 = 2(676)\Rightarrow n^2=676\Rightarrow n=26\). Substituting \(n=26\) into (1): \(2a+25d=52\) ...(2). 12th term: \(a+11d=25\) ...(3). Solving: \(a=\dfrac{53}{3}\), \(d=\dfrac{2}{3}\). (b)(ii) \(B\) is AP with first term \(a+1=\dfrac{56}{3}\) and common difference \(d+2=\dfrac{8}{3}\). Sum of first 10 terms \(=\dfrac{10}{2}\!\left[2\cdot\dfrac{56}{3}+9\cdot\dfrac{8}{3}\right]=\dfrac{920}{3}\).$$,
  9,
  'RI H2 Math Prelim 2025 Paper 1',
  $$[
    {"label":"a","prompt_latex":"A geometric series has first term 2 and common ratio 0.8. Find algebraically the least value of \\(m\\) for the sum of the first \\(4m\\) terms to be greater than 99% of the sum to infinity. \\([3]\\)","correct_answer":"\\frac{21}{4}","answer_type":"exact","tolerance":null},
    {"label":"bi","prompt_latex":"A finite AP \\(A\\) has \\(n\\) terms, first term \\(a\\) and common difference \\(d\\). In progression \\(B\\), the \\(k\\)th term is obtained by adding the \\(k\\)th positive odd integer to the \\(k\\)th term of \\(A\\). Given that the 12th term of \\(A\\) is 25, the sum of all terms of \\(A\\) is 676, and the sum of all terms of \\(B\\) is twice the sum of all terms of \\(A\\), find the values of \\(n\\), \\(a\\) and \\(d\\). \\([4]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"bii","prompt_latex":"Obtain the sum of the first ten terms of \\(B\\). \\([2]\\)","correct_answer":"\\frac{920}{3}","answer_type":"exact","tolerance":null}
  ]$$::jsonb
);

-- Q7 [10] Functions
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'e0250007-0000-0000-0000-000000000000',
  'aaaa0002-0000-0000-0000-000000000000',
  3,
  'Inverse function, piecewise composite, finding exact k',
  $$The function \(\mathrm{f}\) is defined by \(\mathrm{f}: x \mapsto 1 + \dfrac{3}{e^x - 2}\) for \(x \in \mathbb{R},\ x > \ln 2\). Another function \(\mathrm{g}\) is defined by \[\mathrm{g}: x \mapsto \begin{cases} 2(x-1)^2 + 2 & x \leq 0, \\ 2 + |2-x| & 0 < x \leq 3. \end{cases}\]$$,
  'exact',
  $$1-\frac{\sqrt{10}}{2}$$,
  NULL,
  $$(a) Let \(y = 1 + \dfrac{3}{e^x-2}\). Then \(e^x = 2 + \dfrac{3}{y-1}\), so \(\mathrm{f}^{-1}(x) = \ln\!\left(2 + \dfrac{3}{x-1}\right)\) for \(x \in \mathbb{R},\ x > 1\). (b) \(R_{\mathrm{g}} = [2,\infty) \subseteq (1,\infty) = D_{\mathrm{f}^{-1}}\), so \(\mathrm{f}^{-1}\mathrm{g}\) exists. Sketch: for \(x \leq 0\), parabola \(2(x-1)^2+2\) with vertex at \((0,4)\) opening up; for \(0 < x \leq 3\), V-shape \(2+|2-x|\) with minimum \((2,2)\) and endpoint \((3,3)\). (c) \(\mathrm{f}^{-1}\mathrm{g}(k)=\ln\tfrac{5}{2}\Rightarrow \mathrm{g}(k)=\mathrm{f}\!\left(\ln\tfrac{5}{2}\right)=1+\dfrac{3}{\frac{5}{2}-2}=7\). For \(k\leq 0\): \(2(k-1)^2+2=7\Rightarrow(k-1)^2=\tfrac{5}{2}\Rightarrow k=1-\sqrt{\tfrac{5}{2}}=1-\dfrac{\sqrt{10}}{2}\) (rejecting \(k=1+\sqrt{5/2}>0\)).$$,
  10,
  'RI H2 Math Prelim 2025 Paper 1',
  $$[
    {"label":"a","prompt_latex":"Find \\(\\mathrm{f}^{-1}(x)\\) and state its domain. \\([3]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"b","prompt_latex":"Sketch the graph of \\(y = \\mathrm{g}(x)\\) and explain why the composite function \\(\\mathrm{f}^{-1}\\mathrm{g}\\) exists. \\([4]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"c","prompt_latex":"Hence find the exact value of \\(k\\) such that \\(\\mathrm{f}^{-1}\\mathrm{g}(k) = \\ln\\dfrac{5}{2}\\). \\([3]\\)","correct_answer":"1-\\frac{\\sqrt{10}}{2}","answer_type":"exact","tolerance":null}
  ]$$::jsonb
);

-- Q8 [12] Complex Number
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'e0250008-0000-0000-0000-000000000000',
  'aaaa0011-0000-0000-0000-000000000000',
  3,
  'Argand diagram geometry and f(z)=z^2-2z right-angle triangle',
  $$Do not use a calculator in answering this question.$$,
  'exact',
  '',
  NULL,
  $$(a)(i) Since \(w=u+iv\) with \(u,v>0\), \(kw=ku+ikv\) with \(ku,kv>0\). So \(\arg(kw)=\tan^{-1}\!\dfrac{kv}{ku}=\tan^{-1}\!\dfrac{v}{u}=\arg(w)\). (a)(ii) \(Q\) lies on ray \(OP\) extended (\(k>1\)); \(R=ikw\) is \(OQ\) rotated \(90^\circ\) anticlockwise, so \(OR\perp OQ\) and \(|OR|=|OQ|\). (b)(i) \(\mathrm{f}(\mathrm{f}(z))-\mathrm{f}(z)=(z^2-2z)^2-2(z^2-2z)-(z^2-2z)=(z^2-2z)[(z^2-2z)-3]=z(z-2)(z-3)(z+1)\). (b)(ii) Rotating \(\overrightarrow{BC}\) anticlockwise by \(\tfrac{\pi}{2}\) to get \(m\overrightarrow{BA}\): \(i[\mathrm{f}(\mathrm{f}(z))-\mathrm{f}(z)]=m[\mathrm{f}(z)-z]\). Dividing by \(z(z-3)\): \(i(z-2)(z+1)=mi\), so \((z-2)(z+1)=mi\). (b)(iii) With \(z=x+2\mathrm{i}\): \(z^2-z-2=mi\Rightarrow x^2-x-6+\mathrm{i}(4x-2)=m\mathrm{i}\). Real: \(x^2-x-6=0\Rightarrow x=3\). Imaginary: \(m=10\). \(B=\mathrm{f}(3+2\mathrm{i})=(3+2\mathrm{i})^2-2(3+2\mathrm{i})=5+12\mathrm{i}-6-4\mathrm{i}=-1+8\mathrm{i}\).$$,
  12,
  'RI H2 Math Prelim 2025 Paper 1',
  $$[
    {"label":"ai","prompt_latex":"The point \\(P\\) represents \\(w=u+iv\\) with \\(u,v>0\\). Explain algebraically why \\(\\arg(kw)=\\arg(w)\\) for any real constant \\(k>1\\). \\([1]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"aii","prompt_latex":"Points \\(Q\\) and \\(R\\) represent \\(kw\\) and \\(ikw\\) (\\(k>1\\)). Plot \\(Q\\) and \\(R\\) on an Argand diagram and show the geometrical relationship between \\(P\\), \\(Q\\) and \\(R\\). \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"bi","prompt_latex":"Points \\(A\\), \\(B\\), \\(C\\) represent \\(z\\), \\(\\mathrm{f}(z)\\), \\(\\mathrm{f}(\\mathrm{f}(z))\\) where \\(\\mathrm{f}(z)=z^2-2z\\). Show that \\(\\mathrm{f}(\\mathrm{f}(z))-\\mathrm{f}(z)=z(z-2)(z-3)(z+1)\\). \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"bii","prompt_latex":"\\(ABC\\) is a right-angled triangle (anticlockwise, right angle at \\(B\\), \\(BC=mBA\\) with \\(m>0\\)). By considering \\(\\dfrac{\\mathrm{f}(\\mathrm{f}(z))-\\mathrm{f}(z)}{\\mathrm{f}(z)-z}\\), show that \\((z-2)(z+1)=m\\mathrm{i}\\). \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"biii","prompt_latex":"In the case \\(z=x+2\\mathrm{i}\\) with \\(x>0\\), find \\(x\\) and \\(m\\). Hence obtain the complex number represented by \\(B\\). \\([5]\\)","correct_answer":null,"answer_type":null,"tolerance":null}
  ]$$::jsonb
);

-- Q9 [11] Differential Equations
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'e0250009-0000-0000-0000-000000000000',
  'aaaa0018-0000-0000-0000-000000000000',
  3,
  'DE for decontamination: C = 50 e^{q arctan t}',
  $$At time \(t\) minutes, the concentration of a chemical is \(C\) mg/L and a liquid agent flows in at \(\dfrac{1}{1+t^2}\) L/min. The rate of decrease of \(C\) is proportional to the product of \(C\) and the flow rate. Initially \(C=50\) mg/L; after 10 minutes \(C=20\) mg/L.$$,
  'range',
  '19.0',
  0.1,
  $$(a) \(\dfrac{dC}{dt}=-kC\cdot\dfrac{1}{1+t^2}\). Separating: \(\ln C = -k\tan^{-1}t + c_1\). With \(C(0)=50\): \(C=50e^{-k\tan^{-1}t}\). With \(C(10)=20\): \(k=\dfrac{\ln(5/2)}{\tan^{-1}10}\approx 0.62285\), so \(q=-0.62285\). (b) \(C(50)=50e^{-0.62285\tan^{-1}50}\approx 19.0\) mg/L. (c) As \(t\to\infty\), \(\tan^{-1}t\to\tfrac{\pi}{2}\), so \(C\to 50e^{-0.62285\pi/2}\approx 18.8\) mg/L. \(C\) decreases monotonically from 50 and approaches approximately 18.8 mg/L.$$,
  11,
  'RI H2 Math Prelim 2025 Paper 1',
  $$[
    {"label":"a","prompt_latex":"By setting up and solving a differential equation relating \\(C\\) and \\(t\\), show that \\(C=50e^{q\\tan^{-1}t}\\), giving the value of \\(q\\) correct to 5 decimal places. \\([7]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"b","prompt_latex":"Determine the value of \\(C\\) when \\(t=50\\). \\([1]\\)","correct_answer":"19.0","answer_type":"range","tolerance":0.1},
    {"label":"c","prompt_latex":"Sketch the graph of \\(C\\) against \\(t\\) and state what happens to \\(C\\) in the tank for large values of \\(t\\). \\([3]\\)","correct_answer":null,"answer_type":null,"tolerance":null}
  ]$$::jsonb
);

-- Q10 [15] Definite Integral
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'e0250010-0000-0000-0000-000000000000',
  'aaaa0016-0000-0000-0000-000000000000',
  3,
  'Substitution u=sqrt(2x-1), area with y=1/2, volume of revolution',
  $$Consider the curve \(y = 2 - \dfrac{x}{\sqrt{2x-1}}\) and the parabola \(x = 2(y-1)^2+1\).$$,
  'range',
  '4.518',
  0.001,
  $$(a) \(u=\sqrt{2x-1}\Rightarrow x=\tfrac{u^2+1}{2}\), \(\dfrac{dx}{du}=u\). So \(\displaystyle\int\dfrac{x}{\sqrt{2x-1}}\,dx=\int\dfrac{u^2+1}{2}\,du\). (b)(i) Asymptote \(x=\tfrac{1}{2}\); turning point \((1,1)\); \(x\)-intercepts at \(x=4\pm2\sqrt{3}\) (approx \(0.536\) and \(7.46\)). (b)(ii) Area \(=\displaystyle\int_1^3\!\left(\tfrac{3}{2}-\dfrac{x}{\sqrt{2x-1}}\right)dx\). With \(u=\sqrt{2x-1}\) (\(u:1\to\sqrt{5}\)): \[=\left[\tfrac{3x}{2}\right]_1^3-\int_1^{\sqrt{5}}\tfrac{u^2+1}{2}\,du=3-\left[\tfrac{u^3}{6}+\tfrac{u}{2}\right]_1^{\sqrt{5}}=\dfrac{11-4\sqrt{5}}{3}\] (c)(i) \(y=1\pm\sqrt{\dfrac{x-1}{2}}\). (c)(ii) Parabola opening right, vertex \((1,1)\), \(x\)-intercept at \(x=3\). (c)(iii) \[V=\pi\int_1^4\!\left(2-\dfrac{x}{\sqrt{2x-1}}\right)^2\!dx-\pi\int_1^3\!\left(1-\sqrt{\dfrac{x-1}{2}}\right)^2\!dx\approx 4.518 \text{ units}^3\]$$,
  15,
  'RI H2 Math Prelim 2025 Paper 1',
  $$[
    {"label":"a","prompt_latex":"Using the substitution \\(u=\\sqrt{2x-1}\\), show that \\(\\displaystyle\\int\\frac{x}{\\sqrt{2x-1}}\\,dx=\\int\\frac{u^2+1}{2}\\,du\\). \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"bi","prompt_latex":"The diagram shows \\(y=2-\\dfrac{x}{\\sqrt{2x-1}}\\). Indicate the asymptote, the turning point, and the \\(x\\)-intercepts. \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"bii","prompt_latex":"Region \\(R\\) is bounded by the curve \\(y=2-\\dfrac{x}{\\sqrt{2x-1}}\\) and the lines \\(x=1\\), \\(x=3\\), \\(y=\\dfrac{1}{2}\\). Find the exact area of \\(R\\). \\([5]\\)","correct_answer":"\\frac{11-4\\sqrt{5}}{3}","answer_type":"exact","tolerance":null},
    {"label":"ci","prompt_latex":"Express \\(x=2(y-1)^2+1\\) in the form \\(y=\\mathrm{f}(x)\\). \\([1]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"cii","prompt_latex":"On the same diagram as (b)(i), sketch the graph of \\(x=2(y-1)^2+1\\). \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"ciii","prompt_latex":"Region \\(S\\) is bounded by the curves \\(y=2-\\dfrac{x}{\\sqrt{2x-1}}\\), \\(x=2(y-1)^2+1\\), the lines \\(x=1\\), \\(x=4\\) and the \\(x\\)-axis. Find the volume generated when \\(S\\) is rotated through \\(2\\pi\\) radians about the \\(x\\)-axis, correct to 3 decimal places. \\([3]\\)","correct_answer":"4.518","answer_type":"range","tolerance":0.001}
  ]$$::jsonb
);

-- Q11 [8] Parametric Equations
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'e0250011-0000-0000-0000-000000000000',
  'aaaa0017-0000-0000-0000-000000000000',
  3,
  'Parametric curve tangent/normal area and parallel normal condition',
  $$A curve \(C\) has parametric equations \[x=2\cos\theta+\cos 2\theta,\quad y=2\sin\theta-\sin 2\theta,\] where \(0<\theta<2\pi\) and \(\theta\neq\dfrac{2\pi}{3},\dfrac{4\pi}{3}\). The point \(P\) with parameter \(p\) lies on \(C\); lines \(M_p\) and \(N_p\) are the tangent and normal at \(P\).$$,
  'exact',
  $$\frac{\sqrt{3}}{2}$$,
  NULL,
  $$(a) \(\dfrac{dx}{d\theta}=-2\sin\theta-2\sin 2\theta\), \(\dfrac{dy}{d\theta}=2\cos\theta-2\cos 2\theta\). Using sum-to-product formulae: \[\frac{dy}{dx}=\frac{2\sin\!\tfrac{3\theta}{2}\sin\!\tfrac{\theta}{2}}{-2\sin\!\tfrac{3\theta}{2}\cos\!\tfrac{\theta}{2}} = -\tan\!\tfrac{\theta}{2}\] (b) At \(p=\tfrac{\pi}{3}\): \(P=(\tfrac{1}{2},\tfrac{\sqrt{3}}{2})\), gradient of \(M_p=-\tfrac{1}{\sqrt{3}}\). Tangent: \(y-\tfrac{\sqrt{3}}{2}=-\tfrac{1}{\sqrt{3}}(x-\tfrac{1}{2})\Rightarrow Q=(2,0)\). Normal: \(y-\tfrac{\sqrt{3}}{2}=\sqrt{3}(x-\tfrac{1}{2})\Rightarrow R=(0,0)\). Area of \(\triangle PQR=\tfrac{1}{2}\cdot|QR|\cdot y_P=\tfrac{1}{2}\cdot 2\cdot\tfrac{\sqrt{3}}{2}=\dfrac{\sqrt{3}}{2}\). (c) Gradient of \(N_s=\dfrac{1}{\tan(s/2)}\). Parallel: \(-\tan\!\dfrac{p}{2}=\dfrac{1}{\tan(s/2)}\Rightarrow 1+\tan\!\dfrac{s}{2}\tan\!\dfrac{p}{2}=0\Rightarrow \tan\!\left(\dfrac{s-p}{2}\right)\) undefined, so \(\dfrac{s-p}{2}=\dfrac{\pi}{2}\), giving \(s-p=\pi\).$$,
  8,
  'RI H2 Math Prelim 2025 Paper 1',
  $$[
    {"label":"a","prompt_latex":"Using \\(\\sin A+\\sin B=2\\sin\\frac{A+B}{2}\\cos\\frac{A-B}{2}\\) and \\(\\cos A-\\cos B=-2\\sin\\frac{A+B}{2}\\sin\\frac{A-B}{2}\\), show that the gradient of \\(M_p\\) is \\(-\\tan\\dfrac{p}{2}\\). \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"b","prompt_latex":"For \\(p=\\dfrac{\\pi}{3}\\), \\(M_p\\) and \\(N_p\\) cut the \\(x\\)-axis at \\(Q\\) and \\(R\\) respectively. Find the area of \\(\\triangle PQR\\). \\([4]\\)","correct_answer":"\\frac{\\sqrt{3}}{2}","answer_type":"exact","tolerance":null},
    {"label":"c","prompt_latex":"Point \\(S\\) has parameter \\(s\\) on \\(C\\) and \\(N_s\\) is its normal. Given \\(p\\neq\\dfrac{\\pi}{3},\\pi\\) and \\(p<s\\), and that \\(M_p\\parallel N_s\\), use \\(\\tan(A-B)=\\dfrac{\\tan A-\\tan B}{1+\\tan A\\tan B}\\) to find an equation relating \\(p\\) and \\(s\\). \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null}
  ]$$::jsonb
);

-- Paper 2 questions (e0251001--e0251010)

-- P2 Q1 [8] Inequalities
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'e0251001-0000-0000-0000-000000000000',
  'aaaa0005-0000-0000-0000-000000000000',
  2,
  'Rational inequality and graphical method for ln|x| < |x|-5',
  $$$$,
  'exact',
  '',
  NULL,
  $$(a) \(\dfrac{x^2-5x+6}{x^2-4} < \dfrac{2x-3}{x+2}\), \(x \neq \pm 2\). Since \(\dfrac{(x-2)(x-3)}{(x-2)(x+2)} = \dfrac{x-3}{x+2}\) for \(x \neq 2\), we get \(\dfrac{x-3}{x+2} < \dfrac{2x-3}{x+2}\), i.e. \(\dfrac{-x}{x+2} < 0\), i.e. \(x(x+2)>0\). Solution: \(x<-2\) or \(0<x<2\) or \(x>2\) (excluding \(x=\pm2\)).
(b)(i) Sketch \(y=\ln x\) (asymptote \(x=0\)) and \(y=x-5\) on the same axes. Intersections at \(x=0.00678\) (3 s.f.) and \(x=6.94\) (3 s.f.).
(b)(ii) Reflecting the sketch for \(\ln|x|<|x|-5\): \(x<-6.94\) or \(-0.00678<x<0\) or \(0<x<0.00678\) or \(x>6.94\).$$,
  8,
  'RI H2 Math Prelim 2025 Paper 2',
  $$[
    {"label":"a","prompt_latex":"Without using a calculator, solve the inequality \\(\\dfrac{x^2-5x+6}{x^2-4} < \\dfrac{2x-3}{x+2}\\). \\([4]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"bi","prompt_latex":"Sketch on the same diagram the graphs of \\(y = \\ln x\\) and \\(y = x-5\\), giving the equations of any asymptotes and the \\(x\\)-coordinates of the points of intersection between the two graphs. \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"bii","prompt_latex":"Hence solve the inequality \\(\\ln|x| < |x|-5\\). \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null}
  ]$$::jsonb
);

-- P2 Q2 [10] Maclaurin Series
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'e0251002-0000-0000-0000-000000000000',
  'aaaa0014-0000-0000-0000-000000000000',
  3,
  'Triangle AC small-angle expansion; Maclaurin series for 2xy + ln y = ln 3',
  $$In a triangle \(ABC\), \(AB = 2\), angle \(CAB = x\) radians and angle \(CBA = \dfrac{\pi}{6}\) radians.$$,
  'exact',
  '',
  NULL,
  $$(a)(i) \(\angle ACB = \pi - \dfrac{\pi}{6} - x = \dfrac{5\pi}{6} - x\). By the Sine Rule: \(\dfrac{AC}{\sin\frac{\pi}{6}} = \dfrac{2}{\sin\!\left(\frac{5\pi}{6}-x\right)}\). Since \(\sin\!\left(\dfrac{5\pi}{6}-x\right) = \dfrac{1}{2}\cos x + \dfrac{\sqrt{3}}{2}\sin x\), we obtain \(AC = \dfrac{2}{\cos x + \sqrt{3}\sin x}\) (shown).
(a)(ii) For small \(x\): \(\cos x \approx 1-\dfrac{x^2}{2}\), \(\sin x \approx x\). So \(AC \approx \dfrac{2}{1+\sqrt{3}x - \frac{1}{2}x^2} = 2\!\left(1+\sqrt{3}x-\tfrac{1}{2}x^2\right)^{-1}\). Expanding: \(\approx 2\!\left[1-(\sqrt{3}x-\tfrac{1}{2}x^2)+(\sqrt{3}x)^2+\ldots\right] = 2-2\sqrt{3}x+7x^2\). So \(a=2\), \(b=-2\sqrt{3}\), \(c=7\).
(b) Differentiating \(2xy+\ln y=\ln 3\) implicitly: \(2x\dfrac{dy}{dx}+2y+\dfrac{1}{y}\dfrac{dy}{dx}=0\). Differentiating again and multiplying by \(y^2\) gives \((2xy^2+y)\dfrac{d^2y}{dx^2}+4y^2\dfrac{dy}{dx}-\!\left(\dfrac{dy}{dx}\right)^2=0\) (shown). At \(x=0\): \(y=3\), \(\dfrac{dy}{dx}=-18\), \(\dfrac{d^2y}{dx^2}=324\). Hence \(y = 3 - 18x + 162x^2 + \ldots\)$$,
  10,
  'RI H2 Math Prelim 2025 Paper 2',
  $$[
    {"label":"ai","prompt_latex":"Show that \\(AC = \\dfrac{2}{\\cos x + \\sqrt{3}\\sin x}\\). \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"aii","prompt_latex":"Given that \\(x\\) is a sufficiently small angle, show that \\(AC \\approx a + bx + cx^2\\), where \\(a\\), \\(b\\) and \\(c\\) are constants to be determined. \\([3]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"b","prompt_latex":"It is given that \\(2xy + \\ln y = \\ln 3\\). Show that \\((2xy^2 + y)\\dfrac{\\mathrm{d}^2 y}{\\mathrm{d}x^2} + 4y^2\\dfrac{\\mathrm{d}y}{\\mathrm{d}x} - \\left(\\dfrac{\\mathrm{d}y}{\\mathrm{d}x}\\right)^2 = 0\\). Hence find the Maclaurin series for \\(y\\), up to and including the term in \\(x^2\\). \\([5]\\)","correct_answer":null,"answer_type":null,"tolerance":null}
  ]$$::jsonb
);

-- P2 Q3 [10] Sequences and Series
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'e0251003-0000-0000-0000-000000000000',
  'aaaa0007-0000-0000-0000-000000000000',
  3,
  'Recurrence u_{n+1}=(8u_n-14)/(u_n-1); convergence of combined sequence W',
  $$The terms of the sequence \(U\) are given by \(u_1 = k\) and \(u_{n+1} = \dfrac{8u_n - 14}{u_n - 1}\), \(n \geq 1\). The \(n\)th term of sequence \(V\) is \(v_n = \dfrac{a^n}{b} + \dfrac{b}{a(1-a^n)} - \dfrac{a}{n+1}\), where \(a, b\) are non-zero real constants and \(a \neq \pm 1\). The \(n\)th term of sequence \(W\) is \(w_n = u_n\) when \(n\) is even, and \(w_n = v_n\) when \(n\) is odd. \(W\) converges when \(U\) and \(V\) converge to the same limit; otherwise \(W\) diverges.$$,
  'exact',
  '',
  NULL,
  $$(a)(i) For \(k=3\): the terms are increasing and converging to 7.
(a)(ii) For \(k=10\): the terms are decreasing and converging to 7.
(b) For a constant sequence, \(u_{n+1}=u_n=k\), so \(k = \dfrac{8k-14}{k-1} \Rightarrow k^2-9k+14=0 \Rightarrow (k-2)(k-7)=0\). Hence \(k=2\) or \(k=7\).
(c) As \(n\to\infty\), \(\dfrac{a}{n+1}\to 0\). If \(|a|>1\), \(\dfrac{a^n}{b}\) is unbounded, so \(V\) diverges. If \(-1<a<1\) and \(a\neq 0\), then \(a^n\to 0\), giving \(v_n \to \dfrac{0}{b}+\dfrac{b}{a(1-0)}-0 = \dfrac{b}{a}\). Range of \(a\): \((-1,0)\cup(0,1)\); limiting value \(L = \dfrac{b}{a}\).
(d) From (a)(ii), \(u_n\to 7\). For \(W\) to converge: \(L=\dfrac{b}{a}=7\) with \(-1<a<1\), \(a\neq 0\), so \(b=7a\) and \(-7<b<7\), \(b\neq 0\). Range of \(b\): \((-7,0)\cup(0,7)\). Since the limiting value of \(w_n\) is 7 (non-zero), \(\displaystyle\sum_{r=1}^{\infty} w_r\) diverges (a necessary condition for convergence is \(w_r\to 0\)).$$,
  10,
  'RI H2 Math Prelim 2025 Paper 2',
  $$[
    {"label":"ai","prompt_latex":"For \\(k=3\\), describe the behaviour of the sequence \\(U\\). \\([1]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"aii","prompt_latex":"For \\(k=10\\), describe the behaviour of the sequence \\(U\\). \\([1]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"b","prompt_latex":"Find the possible value(s) of \\(k\\) if the sequence \\(U\\) is a constant sequence. \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"c","prompt_latex":"For some values of \\(a\\), \\(v_n \\to L\\) as \\(n \\to \\infty\\). Find, with justification, the range of values of \\(a\\) for \\(L\\) to exist, and state the value of \\(L\\) in terms of \\(a\\) and \\(b\\). \\([3]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"d","prompt_latex":"For \\(k=10\\), by using parts (a)(ii) and (c), find the range of values of \\(b\\) for the sequence \\(W\\) to converge. Hence explain whether \\(\\displaystyle\\sum_{r=1}^{\\infty} w_r\\) is a convergent series. \\([3]\\)","correct_answer":null,"answer_type":null,"tolerance":null}
  ]$$::jsonb
);

-- P2 Q4 [12] Vector (Plane)
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'e0251004-0000-0000-0000-000000000000',
  'aaaa0010-0000-0000-0000-000000000000',
  3,
  'Slope plane through A,B,C; path in plane, obstacle avoidance, sensor range, parallel plane',
  $$In a computer game, a slope is modelled as a plane \(p\) containing \(A(1,0,-3)\), \(B(1,4,-15)\) and \(C(2,3,-14)\). Griffles travels from \(A\) along a path \(\mathbf{r} = \begin{pmatrix}1\\0\\-3\end{pmatrix} + \lambda\begin{pmatrix}1\\m\\n\end{pmatrix}\). In the rest of the question \(m=\dfrac{1}{3}\), \(n=-3\). The base of an obstacle is the line segment \(BC\). A laser sensor at \(E(5,2,1)\) activates when an object is within 5 units.$$,
  'exact',
  '',
  NULL,
  $$(a) \(\overrightarrow{AB} = 4\begin{pmatrix}0\\1\\-3\end{pmatrix}\), \(\overrightarrow{AC} = \begin{pmatrix}1\\3\\-11\end{pmatrix}\). Normal \(\propto \begin{pmatrix}0\\1\\-3\end{pmatrix}\times\begin{pmatrix}1\\3\\-11\end{pmatrix} = \begin{pmatrix}(-11+9)\\(-3+0)\\(0-1)\end{pmatrix} = \begin{pmatrix}-2\\-3\\-1\end{pmatrix} \propto \begin{pmatrix}2\\3\\1\end{pmatrix}\). Check: \(\begin{pmatrix}1\\0\\-3\end{pmatrix}\cdot\begin{pmatrix}2\\3\\1\end{pmatrix} = 2+0-3 = -1\) (shown).
(b) Direction of path \(\begin{pmatrix}1\\m\\n\end{pmatrix}\) is perpendicular to normal \(\begin{pmatrix}2\\3\\1\end{pmatrix}\): \(2+3m+n=0\), i.e. \(3m+n=-2\).
(c) Path \(l_1\): \(\mathbf{r}=\begin{pmatrix}1\\0\\-3\end{pmatrix}+\mu\begin{pmatrix}3\\1\\-9\end{pmatrix}\). Line \(BC\): \(\mathbf{r}=\begin{pmatrix}1\\4\\-15\end{pmatrix}+\alpha\begin{pmatrix}1\\-1\\1\end{pmatrix}\), \(0\leq\alpha\leq 1\). Equating gives \(3\mu-\alpha=0\), \(\mu+\alpha=4\), \(-9\mu-\alpha=-12\). Solving: \(\mu=1\), \(\alpha=3\). Since \(\alpha=3>1\), the intersection is outside segment \(BC\), so Griffles does not collide.
(d) \(\overrightarrow{AE} = 2\begin{pmatrix}2\\1\\2\end{pmatrix}\). Shortest distance from \(E\) to \(l_1\) is \(\dfrac{|{\overrightarrow{AE}}\times\begin{pmatrix}3\\1\\-9\end{pmatrix}|}{|\begin{pmatrix}3\\1\\-9\end{pmatrix}|} = \dfrac{2\sqrt{698}}{\sqrt{91}} \approx 5.54 > 5\). So the sensor is not activated.
(e) Take point \(A(1,0,-3)\) on \(p\). Reflection of \(A\) in \(E\): \(A'=2E-A=(9,4,5)\). Plane \(q\) through \(A'\) with normal \(\begin{pmatrix}2\\3\\1\end{pmatrix}\): \(\begin{pmatrix}9\\4\\5\end{pmatrix}\cdot\begin{pmatrix}2\\3\\1\end{pmatrix}=18+12+5=35\). Cartesian equation: \(2x+3y+z=35\).$$,
  12,
  'RI H2 Math Prelim 2025 Paper 2',
  $$[
    {"label":"a","prompt_latex":"Show that \\(p\\) has equation \\(\\mathbf{r}\\cdot\\begin{pmatrix}2\\\\3\\\\1\\end{pmatrix}=-1\\). \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"b","prompt_latex":"Find an equation relating \\(m\\) and \\(n\\). \\([1]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"c","prompt_latex":"By considering the line segment \\(BC\\), show that Griffles is able to successfully navigate the obstacle without colliding into it. \\([3]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"d","prompt_latex":"Show that Griffles does not activate the sensor. \\([3]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"e","prompt_latex":"Find the cartesian equation of plane \\(q\\), which is parallel to \\(p\\) such that \\(E\\) is equidistant from \\(p\\) and \\(q\\). \\([3]\\)","correct_answer":null,"answer_type":null,"tolerance":null}
  ]$$::jsonb
);

-- P2 Q5 [7] Discrete Random Variable
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'e0251005-0000-0000-0000-000000000000',
  'bbbb0003-0000-0000-0000-000000000000',
  2,
  'Discrete RV P(X=x)=k(x^2+x): expectation, variance and difference probability',
  $$A discrete random variable \(X\) has probability distribution \(\mathrm{P}(X=x) = k(x^2+x)\) for \(x=1,2,3,4,5\), where \(k\) is a constant.$$,
  'exact',
  '',
  NULL,
  $$(a) \(\sum_{x=1}^{5}k(x^2+x) = k(2+6+12+20+30) = 70k = 1 \Rightarrow k = \dfrac{1}{70}\) (shown).
(b) \(\mathrm{E}(X) = \dfrac{1}{70}[1(2)+2(6)+3(12)+4(20)+5(30)] = \dfrac{280}{70} = 4\). \(\mathrm{E}(X^2) = \dfrac{1}{70}[1(2)+4(6)+9(12)+16(20)+25(30)] = \dfrac{1204}{70} = \dfrac{86}{5}\). \(\mathrm{Var}(X) = \dfrac{86}{5} - 16 = \dfrac{6}{5} = 1.2\).
(c) \(\mathrm{P}(|X_1-X_2|\geq 3) = 2[\mathrm{P}(X_1=1,X_2=4)+\mathrm{P}(X_1=1,X_2=5)+\mathrm{P}(X_1=2,X_2=5)]\)
\(= 2\!\left[\dfrac{2}{70}\cdot\dfrac{20}{70}+\dfrac{2}{70}\cdot\dfrac{30}{70}+\dfrac{6}{70}\cdot\dfrac{30}{70}\right] = \dfrac{560}{4900} = \dfrac{4}{35}\).$$,
  7,
  'RI H2 Math Prelim 2025 Paper 2',
  $$[
    {"label":"a","prompt_latex":"Show that \\(k = \\dfrac{1}{70}\\). \\([1]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"b","prompt_latex":"Find the exact values of \\(\\mathrm{E}(X)\\) and \\(\\mathrm{Var}(X)\\). \\([3]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"c","prompt_latex":"Two independent observations \\(X_1\\) and \\(X_2\\) are taken of \\(X\\). Find the probability that the difference between the two observations is at least 3. \\([3]\\)","correct_answer":"\\frac{4}{35}","answer_type":"exact","tolerance":null}
  ]$$::jsonb
);

-- P2 Q6 [8] Permutation and Combination
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'e0251006-0000-0000-0000-000000000000',
  'bbbb0001-0000-0000-0000-000000000000',
  2,
  'Circular and line charm arrangements; 6cm keychain with size constraint',
  $$Kitty has 5 small, 3 medium and 2 large spherical charms, each uniquely designed. The diameters of small, medium and large charms are 0.5 cm, 1 cm and 2 cm respectively.$$,
  'exact',
  '',
  NULL,
  $$(a) Treat the three size-groups as 3 blocks in a circle: \((3-1)!=2\) circular arrangements. Within blocks: \(5!\), \(3!\), \(2!\) arrangements. Total \(= 2 \times 5! \times 3! \times 2! = 2 \times 120 \times 6 \times 2 = 2880\).
(b) Arrange the 5 non-small charms (3 medium + 2 large) first: \(5!\) ways. Place the 5 small charms in 5 of the 6 gaps created: \(\dbinom{6}{5}\times 5! = 720\) ways. Total \(= 120 \times 720 = 86400\).
(c) Chain length 6 cm; let \(s\), \(m\), \(l\) be counts of small (0.5 cm), medium (1 cm), large (2 cm): \(0.5s + m + 2l = 6\). With \(s\leq 5\), \(m\leq 3\), \(l\leq 2\), at least one of each size, the valid combinations are:
Case (1L, 2M, 4S): \(\dbinom{2}{1}\dbinom{3}{2}\dbinom{5}{4}\times 7! = 2\times3\times5\times5040 = 151200\).
Case (1L, 3M, 2S): \(\dbinom{2}{1}\dbinom{3}{3}\dbinom{5}{2}\times 6! = 2\times1\times10\times720 = 14400\).
Case (2L, 1M, 2S): \(\dbinom{2}{2}\dbinom{3}{1}\dbinom{5}{2}\times 5! = 1\times3\times10\times120 = 3600\).
Total \(= 151200 + 14400 + 3600 = 169200\).$$,
  8,
  'RI H2 Math Prelim 2025 Paper 2',
  $$[
    {"label":"a","prompt_latex":"Kitty arranges all the charms in a circle on a corkboard with charms of the same size next to each other. How many ways are there? \\([2]\\)","correct_answer":"2880","answer_type":"exact","tolerance":null},
    {"label":"b","prompt_latex":"Kitty arranges all the charms in a line at the base of a photo frame with none of the small charms next to each other. How many ways are there? \\([2]\\)","correct_answer":"86400","answer_type":"exact","tolerance":null},
    {"label":"c","prompt_latex":"Kitty makes a keychain with a 6 cm chain (one end attached to a keyring), fully threaded with charms and no gaps, with at least one charm of each size. How many different ways can she make the keychain? \\([4]\\)","correct_answer":"169200","answer_type":"exact","tolerance":null}
  ]$$::jsonb
);

-- P2 Q7 [9] Normal Distribution
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'e0251007-0000-0000-0000-000000000000',
  'bbbb0008-0000-0000-0000-000000000000',
  3,
  'Rays N(100,sigma^2) and Luffles N(120,16): sigma range, combined mass, Mega Jumbo Pack',
  $$A snack company produces two types of potato chips. The mass (grams) of a regular packet of Rays follows \(\mathrm{N}(100,\,\sigma^2)\) and the mass of a regular packet of Luffles follows \(\mathrm{N}(120,\,16)\). All masses are independent of one another.$$,
  'exact',
  '',
  NULL,
  $$(a) \(\mathrm{P}(R \leq 100-\sigma^2) < 0.2\). Standardising: \(\mathrm{P}\!\left(Z \leq \dfrac{-\sigma^2}{\sigma}\right) = \mathrm{P}(Z \leq -\sigma) < 0.2\). From GC, \(\mathrm{P}(Z \leq -0.8416) = 0.2\), so \(-\sigma < -0.8416\), giving \(\sigma > 0.842\) (3 s.f.).
(b) With \(\sigma=3\): \(R_1+R_2+L_1+L_2+L_3 \sim \mathrm{N}(2\times100+3\times120,\; 2\times9+3\times16) = \mathrm{N}(560,\,66)\). \(\mathrm{P}(\text{total} > 550) = \mathrm{P}\!\left(Z > \dfrac{550-560}{\sqrt{66}}\right) = \mathrm{P}(Z > -1.231) \approx 0.891\) (3 s.f.).
(c) MJP mass \(M = (24-n)R + nL\). \(\mathrm{E}(M) = (24-n)\times100 + n\times120 = 2400+20n\). \(\mathrm{Var}(M) = (24-n)\times9 + n\times16 = 216+7n\). \(M-20L \sim \mathrm{N}(2400+20n-2400,\; 216+7n+400\times16) = \mathrm{N}(20n,\; 6616+7n)\). Require \(\mathrm{P}(M-20L>500)\geq 0.1\): \(\dfrac{500-20n}{\sqrt{6616+7n}} \leq 1.282\), giving \(n \geq 19.73\). Minimum \(n = 20\).$$,
  9,
  'RI H2 Math Prelim 2025 Paper 2',
  $$[
    {"label":"a","prompt_latex":"If the probability of the mass of a randomly chosen packet of Rays not exceeding \\((100-\\sigma^2)\\) grams is less than 0.2, find the possible range of values of \\(\\sigma\\). \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"b","prompt_latex":"Given \\(\\sigma=3\\), find the probability that the total mass of 2 randomly chosen regular packets of Rays and 3 randomly chosen packets of Luffles is greater than 0.55 kg. \\([3]\\)","correct_answer":"0.891","answer_type":"range","tolerance":0.001},
    {"label":"c","prompt_latex":"Given \\(\\sigma=3\\), the Mega Jumbo Pack consists of \\((24-n)\\) regular packets of Rays and \\(n\\) regular packets of Luffles. The probability of the mass of a Mega Jumbo Pack exceeding 20 times the mass of a regular packet of Luffles by more than 500 g is at least 0.1. Find the minimum value of \\(n\\). \\([4]\\)","correct_answer":"20","answer_type":"exact","tolerance":null}
  ]$$::jsonb
);

-- P2 Q8 [7] Correlation and Linear Regression
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'e0251008-0000-0000-0000-000000000000',
  'bbbb0006-0000-0000-0000-000000000000',
  2,
  'Coffee price vs cups sold: outlier, y=a+b/x regression model',
  $$A cafe owner studied the effect of selling price \(\$x\) on average cups sold per day \(y\) over 7 years. \[\begin{array}{c|ccccccc} x & 2.0 & 2.2 & 2.5 & 3.0 & 4.0 & 4.4 & 4.5 \\ \hline y & 280 & 250 & 190 & 150 & 90 & 100 & 70 \end{array}\]$$,
  'exact',
  '',
  NULL,
  $$(a) Scatter diagram: plot the 7 data points with axes labelled.
(b) Point \(P = (4.4, 100)\) lies above the decreasing trend of the other 6 points. For the remaining 6 points, as \(x\) increases, \(y\) decreases by decreasing amounts, which is consistent with the hyperbolic model \(y = a + \dfrac{b}{x}\).
(c) Let \(t = \dfrac{1}{x}\). Regressing \(y\) on \(t\) for the 6 points: \(r \approx 0.997\) (3 s.f.), \(a \approx -101\) (3 s.f.), \(b \approx 757\) (3 s.f.).
(d) When \(x = 4.4\): \(y \approx \dfrac{756.86}{4.4} - 100.82 \approx 71.2\) (3 s.f.). This estimate is reliable because (1) \(x=4.4\) lies within the data range \([2.0,\,4.5]\) (interpolation, not extrapolation), and (2) the PMCC \(r = 0.997\) is very close to 1, indicating a strong positive linear correlation between \(\dfrac{1}{x}\) and \(y\).$$,
  7,
  'RI H2 Math Prelim 2025 Paper 2',
  $$[
    {"label":"a","prompt_latex":"On the grid provided, draw a scatter diagram of the data. \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"b","prompt_latex":"Indicate the wrongly-stated point by labelling it \\(P\\) on your diagram. Explain why the scatter diagram for the remaining points may be consistent with a model of the form \\(y = a + \\dfrac{b}{x}\\). \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"c","prompt_latex":"Omitting \\(P\\), calculate the product moment correlation coefficient and the least squares estimates of \\(a\\) and \\(b\\) for the model \\(y = a + \\dfrac{b}{x}\\). \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"d","prompt_latex":"Use the model \\(y = a + \\dfrac{b}{x}\\) with your values of \\(a\\) and \\(b\\) to estimate the wrongly-stated value of \\(y\\). Give two reasons why this estimate is reliable. \\([3]\\)","correct_answer":null,"answer_type":null,"tolerance":null}
  ]$$::jsonb
);

-- P2 Q9 [13] Hypothesis Testing
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'e0251009-0000-0000-0000-000000000000',
  'bbbb0005-0000-0000-0000-000000000000',
  3,
  'GJC 2.4km run: two-tail z-test for males; one-tail test for females with minimum n',
  $$The mean time for male students at GJC to complete a 2.4 km run is known to be 11.3 minutes with standard deviation 2.2 minutes. A random sample of 8 Year 5 male students had times (minutes): 11, 11.5, 10.8, 11.2, 11.4, 11, 11.8, 12.5. The PE department tests at the 2.5% significance level whether the mean time has changed.$$,
  'exact',
  '',
  NULL,
  $$(a) Let \(\mu\) be the population mean time (minutes) for male GJC students to complete a 2.4 km run. \(H_0: \mu = 11.3\) vs \(H_1: \mu \neq 11.3\).
(b) Assumption: times follow a normal distribution (sample size small). Under \(H_0\): \(\bar{X} \sim \mathrm{N}\!\left(11.3, \dfrac{2.2^2}{8}\right)\). Two-tail test at 2.5% significance; critical values \(c_1 = 9.56\), \(c_2 = 13.0\) (3 s.f.). Critical region: \(\bar{X} < 9.56\) or \(\bar{X} > 13.0\). Sample mean \(\bar{x} = 11.4\). Since \(9.56 < 11.4 < 13.0\), do not reject \(H_0\). There is insufficient evidence at the 2.5% significance level that the population mean run time for male GJC students has changed.
(c) For female test: \(H_0: \mu_Y = 14.5\) vs \(H_1: \mu_Y < 14.5\). Unbiased estimate of population variance: \(s^2 = \dfrac{n}{n-1}(1.5^2)\). Under \(H_0\), by CLT: \(\bar{Y} \sim \mathrm{N}\!\left(14.5, \dfrac{1.5^2}{n-1}\right)\) approximately. Reject \(H_0\) when \(\mathrm{P}(\bar{Y} \leq 14.2) \leq 0.03\): \(\dfrac{-0.3\sqrt{n-1}}{1.5} \leq -1.881\), so \(\sqrt{n-1} \geq 9.404\), giving \(n \geq 89.44\). Hence \(n \geq 90\), \(n \in \mathbb{Z}^+\).$$,
  13,
  'RI H2 Math Prelim 2025 Paper 2',
  $$[
    {"label":"a","prompt_latex":"Write down the null and alternative hypotheses for this test, defining any symbols you use. \\([2]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"b","prompt_latex":"Stating a necessary assumption, find the critical region for this test. Hence state the conclusion of the test in context. \\([6]\\)","correct_answer":null,"answer_type":null,"tolerance":null},
    {"label":"c","prompt_latex":"The PE department also tests at the 3% significance level whether the mean time for female GJC students is less than 14.5 minutes. A large random sample of \\(n\\) females has sample mean 14.2 minutes and sample standard deviation 1.5 minutes. Given that the department concludes the mean time is less than 14.5 minutes, find the range of values of \\(n\\). \\([5]\\)","correct_answer":null,"answer_type":null,"tolerance":null}
  ]$$::jsonb
);

-- P2 Q10 [14] Binomial Distribution
INSERT INTO questions (id, topic_id, difficulty, name, prompt_latex, answer_type, correct_answer, tolerance, solution_latex, marks, source, parts)
VALUES (
  'e0251010-0000-0000-0000-000000000000',
  'bbbb0007-0000-0000-0000-000000000000',
  3,
  'Balls without/with replacement: hypergeometric probability and binomial distribution',
  $$A bag contains 4 identical red and 6 identical blue balls.$$,
  'exact',
  '',
  NULL,
  $$(a)(i) By symmetry, \(\mathrm{P}(\text{last ball is red}) = \mathrm{P}(\text{first ball is red}) = \dfrac{4}{10} = \dfrac{2}{5}\).
(a)(ii) \(\mathrm{P}(\text{2 blue} \mid \text{at least 3 red in first 5}) = \dfrac{\mathrm{P}(\text{3R, 2B})}{\mathrm{P}(\text{3R, 2B})+\mathrm{P}(\text{4R, 1B})} = \dfrac{\binom{4}{3}\binom{6}{2}}{\binom{4}{3}\binom{6}{2}+\binom{4}{4}\binom{6}{1}} \div \binom{10}{5}/\binom{10}{5} = \dfrac{60}{60+6} = \dfrac{10}{11}\).
(b) Let \(R \sim \mathrm{B}\!\left(20, \dfrac{2}{5}\right)\) (with replacement).
(i) \(\mathrm{P}(R=4) = \dbinom{20}{4}\!\left(\dfrac{2}{5}\right)^4\!\left(\dfrac{3}{5}\right)^{16} \approx 0.0350\) (3 s.f.).
(ii) \(\mathrm{P}(4 < R \leq 8) = \mathrm{P}(R \leq 8) - \mathrm{P}(R \leq 4) \approx 0.545\) (3 s.f.).
(iii) Let \(S \sim \mathrm{B}\!\left(7, \dfrac{3}{5}\right)\). \(\mathrm{P}(\text{8th pick is 6th blue}) = \mathrm{P}(S=5)\times\dfrac{3}{5} = \dbinom{7}{5}\!\left(\dfrac{3}{5}\right)^5\!\left(\dfrac{2}{5}\right)^2\!\times\dfrac{3}{5} \approx 0.157\) (3 s.f.).
(iv) \(\mathrm{E}(R) = 8\), \(\mathrm{Var}(R) = 4.8\). By CLT with \(n=50\): \(\bar{R} \sim \mathrm{N}\!\left(8, \dfrac{4.8}{50}\right) = \mathrm{N}(8, 0.096)\) approximately. \(\mathrm{P}(\bar{R} > 8.5) \approx 0.0533\) (3 s.f.).$$,
  14,
  'RI H2 Math Prelim 2025 Paper 2',
  $$[
    {"label":"ai","prompt_latex":"In the first game, balls are picked one at a time without replacement. Find the probability that the last ball picked is red. \\([1]\\)","correct_answer":"\\frac{2}{5}","answer_type":"exact","tolerance":null},
    {"label":"aii","prompt_latex":"Find the probability that in the first five picks, exactly 2 blue balls are picked given that at least 3 red balls are picked. \\([3]\\)","correct_answer":"\\frac{10}{11}","answer_type":"exact","tolerance":null},
    {"label":"bi","prompt_latex":"In the second game, each ball picked is placed back before the next pick. The player makes 20 random picks. Find the probability that the colour red is recorded exactly 4 times. \\([2]\\)","correct_answer":"0.0350","answer_type":"range","tolerance":0.0005},
    {"label":"bii","prompt_latex":"Find the probability that the colour red is recorded more than 4 times but not more than 8 times. \\([2]\\)","correct_answer":"0.545","answer_type":"range","tolerance":0.001},
    {"label":"biii","prompt_latex":"Find the probability that the 8th pick is the 6th time the colour blue is recorded. \\([2]\\)","correct_answer":"0.157","answer_type":"range","tolerance":0.001},
    {"label":"biv","prompt_latex":"The second game is played by 50 randomly chosen players. Estimate the probability that the average number of times the colour red is recorded is more than 8.5. \\([4]\\)","correct_answer":"0.0533","answer_type":"range","tolerance":0.0005}
  ]$$::jsonb
);
