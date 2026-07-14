-- Migration 082: make cleanly-gradable "find" tutorial/exam parts typeable
-- Previously these parts were answer_type=null (rendered as un-typeable "show" parts) purely
-- by the house convention for brittle answers, even though they ask "find/determine/solve".
-- This migration enables typed submission for the 24 parts whose answers are ROBUSTLY gradable
-- by the existing answerChecker (numeric/complex eval, symbolic 2-point eval, inequality-chain
-- matching, and \pm two-value sets), plus multi-box answers[] for vector/coordinate components.
-- Genuinely non-unique answers (indefinite integrals, DE general solutions, vector line/plane
-- EQUATIONS, probability distributions, worded/justified answers) are deliberately LEFT null.
-- Idempotent: each statement replaces the whole parts JSONB for the question with the final state.

-- Vector of given magnitude and direction (cc21d001)
UPDATE questions SET parts = $migr$[
  {
    "label": "a",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Find the vector \\(\\mathbf{p}\\).",
    "correct_answer": "\\frac{12}{7}\\mathbf{i}-\\frac{18}{7}\\mathbf{j}+\\frac{36}{7}\\mathbf{k}",
    "answers": [
      {
        "key": "i",
        "label": "\\mathbf{i}",
        "correct_answer": "\\frac{12}{7}",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "j",
        "label": "\\mathbf{j}",
        "correct_answer": "-\\frac{18}{7}",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "k",
        "label": "\\mathbf{k}",
        "correct_answer": "\\frac{36}{7}",
        "answer_type": "exact",
        "tolerance": null
      }
    ]
  }
]$migr$::jsonb
WHERE id = 'cc21d001-0000-0000-0000-000000000000';

-- Intersection of two cevians (cc21d00b)
UPDATE questions SET parts = $migr$[
  {
    "label": "a",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Find \\(\\overrightarrow{OE}\\) in terms of \\(\\mathbf{a}\\) and \\(\\mathbf{b}\\).",
    "correct_answer": "\\frac{18}{23}\\mathbf{a}+\\frac{20}{23}\\mathbf{b}",
    "answers": [
      {
        "key": "a",
        "label": "\\text{coeff. of }\\mathbf{a}",
        "correct_answer": "\\frac{18}{23}",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "b",
        "label": "\\text{coeff. of }\\mathbf{b}",
        "correct_answer": "\\frac{20}{23}",
        "answer_type": "exact",
        "tolerance": null
      }
    ]
  }
]$migr$::jsonb
WHERE id = 'cc21d00b-0000-0000-0000-000000000000';

-- Perpendicularity, reflection and geometric meaning (cc21d008)
UPDATE questions SET parts = $migr$[
  {
    "label": "i",
    "tolerance": null,
    "answer_type": null,
    "prompt_latex": "Show that \\(AB\\) is perpendicular to \\(OP\\).",
    "correct_answer": null
  },
  {
    "label": "ii",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Determine the position vector of the point \\(D\\) in terms of \\(\\mathbf{a}\\) and \\(\\mathbf{b}\\), where \\(D\\) is the reflection of \\(O\\) about the line \\(AB\\).",
    "correct_answer": "\\mathbf{a}+\\mathbf{b}",
    "answers": [
      {
        "key": "a",
        "label": "\\text{coeff. of }\\mathbf{a}",
        "correct_answer": "1",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "b",
        "label": "\\text{coeff. of }\\mathbf{b}",
        "correct_answer": "1",
        "answer_type": "exact",
        "tolerance": null
      }
    ]
  },
  {
    "label": "iii",
    "tolerance": null,
    "answer_type": null,
    "prompt_latex": "(a) Give the geometrical meaning of \\(\\dfrac{1}{|\\mathbf{b}|}|\\mathbf{a}\\cdot\\mathbf{b}|\\). (b) Give the geometrical meaning of \\(|\\mathbf{a}\\times\\mathbf{b}|\\).",
    "correct_answer": null
  }
]$migr$::jsonb
WHERE id = 'cc21d008-0000-0000-0000-000000000000';

-- Cross-product relation and possible values (cc21d00a)
UPDATE questions SET parts = $migr$[
  {
    "label": "i",
    "tolerance": null,
    "answer_type": null,
    "prompt_latex": "Show that \\(3\\mathbf{b}-2\\mathbf{c}=\\lambda\\mathbf{a}\\), where \\(\\lambda\\) is a constant.",
    "correct_answer": null
  },
  {
    "label": "ii",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "It is now given that \\(\\mathbf{a}\\) and \\(\\mathbf{c}\\) are unit vectors, that \\(|\\mathbf{b}|=4\\) and that the angle between \\(\\mathbf{b}\\) and \\(\\mathbf{c}\\) is \\(60^\\circ\\). Using a suitable scalar product, find exactly the two possible values of \\(\\lambda\\).",
    "correct_answer": "\\pm 2\\sqrt{31}"
  }
]$migr$::jsonb
WHERE id = 'cc21d00a-0000-0000-0000-000000000000';

-- Intersection of two cevians (line method) (cc21e002)
UPDATE questions SET parts = $migr$[
  {
    "label": "a",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Find \\(\\overrightarrow{OE}\\) in terms of \\(\\mathbf{a}\\) and \\(\\mathbf{b}\\).",
    "correct_answer": "\\frac{18}{23}\\mathbf{a}+\\frac{20}{23}\\mathbf{b}",
    "answers": [
      {
        "key": "a",
        "label": "\\text{coeff. of }\\mathbf{a}",
        "correct_answer": "\\frac{18}{23}",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "b",
        "label": "\\text{coeff. of }\\mathbf{b}",
        "correct_answer": "\\frac{20}{23}",
        "answer_type": "exact",
        "tolerance": null
      }
    ]
  }
]$migr$::jsonb
WHERE id = 'cc21e002-0000-0000-0000-000000000000';

-- Angle between two diagonals of a cube (cc21e003)
UPDATE questions SET parts = $migr$[
  {
    "label": "a-i",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Find \\(\\overrightarrow{OF}\\) in terms of \\(\\mathbf{i}\\), \\(\\mathbf{j}\\) and \\(\\mathbf{k}\\).",
    "correct_answer": "5\\mathbf{i}+5\\mathbf{j}+5\\mathbf{k}",
    "answers": [
      {
        "key": "i",
        "label": "\\mathbf{i}",
        "correct_answer": "5",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "j",
        "label": "\\mathbf{j}",
        "correct_answer": "5",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "k",
        "label": "\\mathbf{k}",
        "correct_answer": "5",
        "answer_type": "exact",
        "tolerance": null
      }
    ]
  },
  {
    "label": "a-ii",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Find \\(\\overrightarrow{AG}\\) in terms of \\(\\mathbf{i}\\), \\(\\mathbf{j}\\) and \\(\\mathbf{k}\\).",
    "correct_answer": "-5\\mathbf{i}+5\\mathbf{j}+5\\mathbf{k}",
    "answers": [
      {
        "key": "i",
        "label": "\\mathbf{i}",
        "correct_answer": "-5",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "j",
        "label": "\\mathbf{j}",
        "correct_answer": "5",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "k",
        "label": "\\mathbf{k}",
        "correct_answer": "5",
        "answer_type": "exact",
        "tolerance": null
      }
    ]
  },
  {
    "label": "b",
    "tolerance": 0.1,
    "answer_type": "range",
    "prompt_latex": "Find the angle between the diagonals \\(OF\\) and \\(AG\\), in degrees.",
    "correct_answer": "70.5"
  }
]$migr$::jsonb
WHERE id = 'cc21e003-0000-0000-0000-000000000000';

-- Equation involving z and its conjugate (cc241002)
UPDATE questions SET parts = $migr$[
  {
    "label": "a",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Solve the equation \\(zz^{*}-2z+2z^{*}=5-4i\\).",
    "correct_answer": "\\pm 2+\\mathrm{i}"
  }
]$migr$::jsonb
WHERE id = 'cc241002-0000-0000-0000-000000000000';

-- Simultaneous equations in complex numbers (cc241004)
UPDATE questions SET parts = $migr$[
  {
    "label": "a",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Solve the simultaneous equations \\(iz+2w=1\\) and \\(4z+(3-i)w^{*}=-6\\), giving \\(z\\) and \\(w\\) in the form \\(a+bi\\) where \\(a\\) and \\(b\\) are real.",
    "correct_answer": "z=-2+\\mathrm{i},\\ w=1+\\mathrm{i}",
    "answers": [
      {
        "key": "z",
        "label": "z",
        "correct_answer": "-2+\\mathrm{i}",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "w",
        "label": "w",
        "correct_answer": "1+\\mathrm{i}",
        "answer_type": "exact",
        "tolerance": null
      }
    ]
  },
  {
    "label": "b",
    "tolerance": null,
    "answer_type": null,
    "prompt_latex": "Solve the simultaneous equations \\(z=w+2i-1\\) and \\(z^{2}-iw+\\dfrac{5}{2}=0\\), giving \\(z\\) and \\(w\\) in the form \\(x+yi\\) where \\(x\\) and \\(y\\) are real.",
    "correct_answer": null
  }
]$migr$::jsonb
WHERE id = 'cc241004-0000-0000-0000-000000000000';

-- Real roots via real/imaginary comparison (cc241008)
UPDATE questions SET parts = $migr$[
  {
    "label": "i",
    "tolerance": null,
    "answer_type": null,
    "prompt_latex": "For \\(w=a+bi\\) where \\(a\\) and \\(b\\) are real, obtain an expression for \\(b\\) in terms of \\(a\\) and \\(k\\). Explain why \\(w\\) is either purely real or purely imaginary.",
    "correct_answer": null
  },
  {
    "label": "ii",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Using your result in part (i), or otherwise, find the real roots of the equation \\(2w^{2}+2ww^{*}+iw-iw^{*}-1=0\\).",
    "correct_answer": "\\pm\\frac{1}{2}"
  }
]$migr$::jsonb
WHERE id = 'cc241008-0000-0000-0000-000000000000';

-- Modulus equation and cube roots on a circle (50250007)
UPDATE questions SET parts = $migr$[
  {
    "label": "a",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Find the complex number \\(z\\) which satisfies the equation \\(\\dfrac{4|z|}{15-z^{*}}=5\\mathrm{i}\\). \\([3]\\)",
    "correct_answer": "15-20i"
  },
  {
    "label": "bi",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "The complex number \\(w\\) is such that \\((w-\\mathrm{i})^{3}=-\\mathrm{i}\\). Given that one possible value of \\(w\\) is \\(2\\mathrm{i}\\), find the two other possible values of \\(w\\). Give your answers in cartesian form \\(a+b\\mathrm{i}\\). \\([4]\\)",
    "correct_answer": "\\pm\\frac{\\sqrt{3}}{2}+\\frac{1}{2}\\mathrm{i}"
  },
  {
    "label": "bii",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "The points \\(W_{1}\\), \\(W_{2}\\) and \\(W_{3}\\) on the Argand diagram represent the three roots of the equation \\((w-\\mathrm{i})^{3}=-\\mathrm{i}\\), and the point \\(A\\) represents the complex number \\(k\\mathrm{i}\\), where \\(k\\) is a positive real number. Show that the points \\(W_{1}\\), \\(W_{2}\\) and \\(W_{3}\\) lie on a circle with centre \\(A\\) for some value of \\(k\\), stating the value of \\(k\\). \\([2]\\)",
    "correct_answer": "1"
  }
]$migr$::jsonb
WHERE id = '50250007-0000-0000-0000-000000000000';

-- Hypothesis testing — one-tailed z-test and minimum sample size (cafe1012)
UPDATE questions SET parts = $migr$[
  {
    "label": "a",
    "tolerance": null,
    "answer_type": null,
    "prompt_latex": "What does it mean for the sample to be a random sample? \\([1]\\)",
    "correct_answer": null
  },
  {
    "label": "b",
    "tolerance": 0.005,
    "answer_type": "range",
    "prompt_latex": "Find unbiased estimates of the population mean and variance. \\([2]\\)",
    "correct_answer": "\\bar{x}=1.508,\\ s^2=0.000781",
    "answers": [
      {
        "key": "mean",
        "label": "\\text{unbiased mean}",
        "correct_answer": "1.508",
        "answer_type": "range",
        "tolerance": 0.005
      },
      {
        "key": "var",
        "label": "\\text{unbiased variance}",
        "correct_answer": "0.000781",
        "answer_type": "range",
        "tolerance": 0.00005
      }
    ]
  },
  {
    "label": "c",
    "tolerance": null,
    "answer_type": null,
    "prompt_latex": "Test at 5\\% significance whether machine A produces overweight bags. State your hypotheses clearly and define any symbols used. \\([5]\\)",
    "correct_answer": null
  },
  {
    "label": "d",
    "tolerance": null,
    "answer_type": null,
    "prompt_latex": "Explain the meaning of the \\(p\\)-value obtained in context. \\([1]\\)",
    "correct_answer": null
  },
  {
    "label": "e",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Machine B bags follow \\(N(\\mu, 0.00198)\\). A sample of \\(n\\) bags has mean 1.489 kg. Find the minimum integer value of \\(n\\) for which there is sufficient evidence at the 5\\% level that \\(\\mu \\neq 1.5\\) kg. \\([3]\\)",
    "correct_answer": "63"
  }
]$migr$::jsonb
WHERE id = 'cafe1012-0000-0000-0000-000000000000';

-- Complex number — modulus, argument, Argand diagram, rhombus (cafe1006)
UPDATE questions SET parts = $migr$[
  {
    "label": "a",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Find \\(|p|\\) and \\(\\arg(p)\\) in exact form. \\([2]\\)",
    "correct_answer": "|p|=2,\\ \\arg(p)=\\frac{\\pi}{4}",
    "answers": [
      {
        "key": "mod",
        "label": "|p|",
        "correct_answer": "2",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "arg",
        "label": "\\arg(p)",
        "correct_answer": "\\frac{\\pi}{4}",
        "answer_type": "exact",
        "tolerance": null
      }
    ]
  },
  {
    "label": "b",
    "tolerance": null,
    "answer_type": null,
    "prompt_latex": "Sketch \\(P\\) and \\(Q\\) on an Argand diagram. \\([2]\\)",
    "correct_answer": null,
    "solution_graph": {
      "points": [
        {
          "x": 1.41421,
          "y": 1.41421,
          "kind": "point",
          "label": "P"
        },
        {
          "x": -1,
          "y": 1.73205,
          "kind": "point",
          "label": "Q"
        }
      ],
      "x_label": "\\mathrm{Re}",
      "x_range": [
        -2.2,
        2.2
      ],
      "y_label": "\\mathrm{Im}",
      "y_range": [
        -0.4,
        2.4
      ],
      "segments": [
        {
          "to": [
            1.41421,
            1.41421
          ],
          "from": [
            0,
            0
          ],
          "style": "dashed"
        },
        {
          "to": [
            -1,
            1.73205
          ],
          "from": [
            0,
            0
          ],
          "style": "dashed"
        }
      ]
    }
  },
  {
    "label": "c",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Use the Argand diagram to deduce \\(\\operatorname{Re}(q)\\) and \\(\\operatorname{Im}(q)\\) in exact form. Enter \\(\\operatorname{Im}(q)\\). \\([2]\\)",
    "correct_answer": "\\sqrt{3}"
  },
  {
    "label": "d",
    "tolerance": null,
    "answer_type": null,
    "prompt_latex": "The point \\(R\\) represents \\(p + q\\). What shape is the quadrilateral \\(OPRQ\\)? \\([1]\\)",
    "correct_answer": null
  },
  {
    "label": "e",
    "tolerance": null,
    "answer_type": null,
    "prompt_latex": "By considering \\(\\arg(p + q)\\) or otherwise, show that \\(\\tan\\!\\left(\\dfrac{11\\pi}{24}\\right) = \\sqrt{6} + \\sqrt{3} + \\sqrt{2} + 2\\). \\([3]\\)",
    "correct_answer": null
  }
]$migr$::jsonb
WHERE id = 'cafe1006-0000-0000-0000-000000000000';

-- Rational inequality & trigonometric application (cc215007)
UPDATE questions SET parts = $migr$[
  {
    "label": "a",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Without using a calculator, solve \\(\\dfrac{3x-1}{1-2x^2}\\ge 1\\).",
    "correct_answer": "-2\\le x<-\\frac{1}{\\sqrt{2}} \\text{ or } \\frac{1}{2}\\le x<\\frac{1}{\\sqrt{2}}"
  },
  {
    "label": "b",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Hence find the solution of \\(\\dfrac{3\\sin\\theta-1}{\\cos 2\\theta}\\ge 1\\), where \\(-\\dfrac{\\pi}{2}\\le\\theta\\le\\dfrac{\\pi}{2}\\).",
    "correct_answer": "-\\frac{\\pi}{2}\\le\\theta<-\\frac{\\pi}{4} \\text{ or } \\frac{\\pi}{6}\\le\\theta<\\frac{\\pi}{4}"
  }
]$migr$::jsonb
WHERE id = 'cc215007-0000-0000-0000-000000000000';

-- Inequality by substitution (cc215002)
UPDATE questions SET parts = $migr$[
  {
    "label": "a",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Using an algebraic method, solve the inequality \\(f(x)\\le\\dfrac{2}{3}\\).",
    "correct_answer": "x\\le-9 \\text{ or } x>\\frac{3}{2}"
  },
  {
    "label": "b",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Hence find the exact range of values of \\(x\\) for which \\(f(\\ln x)\\le\\dfrac{2}{3}\\).",
    "correct_answer": "0<x\\le e^{-9} \\text{ or } x>e^{\\frac{3}{2}}"
  },
  {
    "label": "c",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Hence find the exact range of values of \\(x\\) for which \\(f\\left(\\left|x+\\dfrac{1}{2}\\right|\\right)\\le\\dfrac{2}{3}\\).",
    "correct_answer": "x>1 \\text{ or } x<-2"
  }
]$migr$::jsonb
WHERE id = 'cc215002-0000-0000-0000-000000000000';

-- Modulus inequality with substitution (cc215005)
UPDATE questions SET parts = $migr$[
  {
    "label": "a",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Solve \\(\\left|\\dfrac{x}{2}+3\\right|>3-x^2\\).",
    "correct_answer": "x>0 \\text{ or } x<-\\frac{1}{2}"
  },
  {
    "label": "b",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Hence solve \\(\\left|\\dfrac{e^{x}}{2}-3\\right|>3-e^{2x}\\).",
    "correct_answer": "x>\\ln 0.5"
  }
]$migr$::jsonb
WHERE id = 'cc215005-0000-0000-0000-000000000000';

-- Rational curve, asymptotes & no-real-roots (surd range) (cc211007)
UPDATE questions SET parts = $migr$[
  {
    "label": "i",
    "answers": [
      {
        "key": "obl",
        "label": "\\text{oblique}",
        "tolerance": null,
        "answer_type": "exact",
        "correct_answer": "y=x+7"
      },
      {
        "key": "vert",
        "label": "\\text{vertical}",
        "tolerance": null,
        "answer_type": "exact",
        "correct_answer": "x=-2"
      }
    ],
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Find the equations of the asymptotes of \\(C\\).",
    "correct_answer": "y=x+7, x=-2"
  },
  {
    "label": "ii",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Find, leaving your answers in exact form, the range of values of \\(k\\) for which the equation \\(k=\\dfrac{x^2+9x+16}{x+2}\\) has no real roots.",
    "correct_answer": "5-2\\sqrt{2}<k<5+2\\sqrt{2}"
  },
  {
    "label": "iii",
    "tolerance": null,
    "answer_type": null,
    "prompt_latex": "Sketch \\(C\\), showing the equations of the asymptotes, the coordinates of the stationary points, and the coordinates of the points of intersection of \\(C\\) with the \\(x\\)- and \\(y\\)-axes.",
    "correct_answer": null,
    "solution_graph": {
      "curves": [
        {
          "expr": "(x^2+9*x+16)/(x+2)",
          "label": "y=\\dfrac{x^2+9x+16}{x+2}",
          "domain": [
            -10,
            -2.1
          ]
        },
        {
          "expr": "(x^2+9*x+16)/(x+2)",
          "domain": [
            -1.9,
            4
          ]
        }
      ],
      "points": [
        {
          "x": -0.586,
          "y": 7.83,
          "kind": "min",
          "label": "(-0.586,\\ 7.83)"
        },
        {
          "x": -3.414,
          "y": 2.17,
          "kind": "max",
          "label": "(-3.41,\\ 2.17)"
        },
        {
          "x": 0,
          "y": 8,
          "kind": "intercept",
          "label": "(0,\\ 8)"
        },
        {
          "x": -6.56,
          "y": 0,
          "kind": "intercept",
          "label": "(-6.56,\\ 0)"
        },
        {
          "x": -2.44,
          "y": 0,
          "kind": "intercept",
          "label": "(-2.44,\\ 0)"
        }
      ],
      "x_range": [
        -10,
        4
      ],
      "y_range": [
        -6,
        16
      ],
      "asymptotes": [
        {
          "x": -2,
          "kind": "vertical",
          "label": "x=-2"
        },
        {
          "expr": "x+7",
          "kind": "oblique",
          "label": "y=x+7"
        }
      ]
    }
  }
]$migr$::jsonb
WHERE id = 'cc211007-0000-0000-0000-000000000000';

-- Rational curve, asymptotes & no-real-roots (cc211006)
UPDATE questions SET parts = $migr$[
  {
    "label": "i",
    "answers": [
      {
        "key": "obl",
        "label": "\\text{oblique}",
        "tolerance": null,
        "answer_type": "exact",
        "correct_answer": "y=x+2"
      },
      {
        "key": "vert",
        "label": "\\text{vertical}",
        "tolerance": null,
        "answer_type": "exact",
        "correct_answer": "x=2"
      }
    ],
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Find the equation(s) of the asymptote(s) of \\(C\\).",
    "correct_answer": "y=x+2, x=2"
  },
  {
    "label": "ii",
    "tolerance": null,
    "answer_type": null,
    "prompt_latex": "Sketch the curve \\(C\\), labelling the equation(s) of its asymptote(s) and the coordinates of any axial intercepts and turning points.",
    "correct_answer": null,
    "solution_graph": {
      "curves": [
        {
          "expr": "x^2/(x-2)",
          "label": "y=\\dfrac{x^2}{x-2}",
          "domain": [
            -6,
            1.9
          ]
        },
        {
          "expr": "x^2/(x-2)",
          "domain": [
            2.1,
            12
          ]
        }
      ],
      "points": [
        {
          "x": 0,
          "y": 0,
          "kind": "max",
          "label": "(0,\\ 0)"
        },
        {
          "x": 4,
          "y": 8,
          "kind": "min",
          "label": "(4,\\ 8)"
        }
      ],
      "x_range": [
        -6,
        12
      ],
      "y_range": [
        -12,
        20
      ],
      "asymptotes": [
        {
          "x": 2,
          "kind": "vertical",
          "label": "x=2"
        },
        {
          "expr": "x+2",
          "kind": "oblique",
          "label": "y=x+2"
        }
      ]
    }
  },
  {
    "label": "iii",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Hence find the range of values of \\(k\\) for which the equation \\(x^2=k\\left(x^2-4\\right)\\) has no real roots.",
    "correct_answer": "0<k\\le1"
  }
]$migr$::jsonb
WHERE id = 'cc211006-0000-0000-0000-000000000000';

-- Determine a, b from asymptote & stationary point (cc211008)
UPDATE questions SET parts = $migr$[
  {
    "label": "i",
    "answers": [
      {
        "key": "a",
        "label": "a",
        "tolerance": null,
        "answer_type": "exact",
        "correct_answer": "-4"
      },
      {
        "key": "b",
        "label": "b",
        "tolerance": null,
        "answer_type": "exact",
        "correct_answer": "1"
      }
    ],
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Determine the values of \\(a\\) and \\(b\\).",
    "correct_answer": "a=-4, b=1"
  },
  {
    "label": "ii",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Find the equation of the other asymptote of \\(C\\).",
    "correct_answer": "y=x-5"
  },
  {
    "label": "iii",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Find, without using a calculator, the set of values that \\(y\\) cannot take.",
    "correct_answer": "-12<y<0"
  },
  {
    "label": "iv",
    "tolerance": null,
    "answer_type": null,
    "prompt_latex": "Sketch \\(C\\), showing clearly any axial intercepts, asymptotes and stationary points.",
    "correct_answer": null,
    "solution_graph": {
      "curves": [
        {
          "expr": "(x^2-4*x+4)/(x+1)",
          "label": "y=\\dfrac{x^2-4x+4}{x+1}",
          "domain": [
            -12,
            -1.1
          ]
        },
        {
          "expr": "(x^2-4*x+4)/(x+1)",
          "domain": [
            -0.9,
            10
          ]
        }
      ],
      "points": [
        {
          "x": -4,
          "y": -12,
          "kind": "max",
          "label": "(-4,\\ -12)"
        },
        {
          "x": 2,
          "y": 0,
          "kind": "min",
          "label": "(2,\\ 0)"
        },
        {
          "x": 0,
          "y": 4,
          "kind": "intercept",
          "label": "(0,\\ 4)"
        }
      ],
      "x_range": [
        -12,
        10
      ],
      "y_range": [
        -16,
        10
      ],
      "asymptotes": [
        {
          "x": -1,
          "kind": "vertical",
          "label": "x=-1"
        },
        {
          "expr": "x-5",
          "kind": "oblique",
          "label": "y=x-5"
        }
      ]
    }
  },
  {
    "label": "v",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Deduce the number of real roots of the equation \\(\\left(4-x^2\\right)(x+1)^2=\\left(x^2-4x+4\\right)^2\\).",
    "correct_answer": "2"
  }
]$migr$::jsonb
WHERE id = 'cc211008-0000-0000-0000-000000000000';

-- MCQ: knowing versus guessing (cc222007)
UPDATE questions SET parts = $migr$[
  {
    "label": "i",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Find the probability, in terms of \\(p\\), that Alice selects the correct answer.",
    "correct_answer": "\\frac{4p+1}{5}"
  },
  {
    "label": "ii",
    "tolerance": null,
    "answer_type": null,
    "prompt_latex": "Describe what the event \\(K'\\cap C\\) represents in the context of this question.",
    "correct_answer": null
  },
  {
    "label": "iii",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Given that \\(\\mathrm{P}(K'\\mid C)=\\dfrac{1}{16}\\), find the value of \\(p\\).",
    "correct_answer": "\\frac{3}{4}"
  }
]$migr$::jsonb
WHERE id = 'cc222007-0000-0000-0000-000000000000';

-- Rational curve & modulus transformations (cc213005)
UPDATE questions SET parts = $migr$[
  {
    "label": "i",
    "answers": [
      {
        "key": "v1",
        "label": "\\text{vertical}",
        "tolerance": null,
        "answer_type": "exact",
        "correct_answer": "x=3"
      },
      {
        "key": "v2",
        "label": "\\text{vertical}",
        "tolerance": null,
        "answer_type": "exact",
        "correct_answer": "x=-1"
      },
      {
        "key": "h",
        "label": "\\text{horizontal}",
        "tolerance": null,
        "answer_type": "exact",
        "correct_answer": "y=-1"
      }
    ],
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Find the equations of the asymptotes of the curve.",
    "correct_answer": "x=3, x=-1, y=-1"
  },
  {
    "label": "ii",
    "tolerance": null,
    "answer_type": null,
    "prompt_latex": "Find where the curve cuts the axes.",
    "correct_answer": null
  },
  {
    "label": "iii",
    "tolerance": null,
    "answer_type": "exact",
    "prompt_latex": "Find the stationary point of the curve.",
    "correct_answer": "\\left(1,\\ -\\frac{1}{4}\\right)",
    "answers": [
      {
        "key": "x",
        "label": "x",
        "correct_answer": "1",
        "answer_type": "exact",
        "tolerance": null
      },
      {
        "key": "y",
        "label": "y",
        "correct_answer": "-\\frac{1}{4}",
        "answer_type": "exact",
        "tolerance": null
      }
    ]
  },
  {
    "label": "iv",
    "tolerance": null,
    "answer_type": null,
    "prompt_latex": "Hence sketch the graph of \\(y\\), and use it to obtain the graphs of \\(y=\\left|\\dfrac{2x-x^2}{x^2-2x-3}\\right|\\) and \\(y=\\dfrac{2|x|-x^2}{x^2-2|x|-3}\\).",
    "correct_answer": null,
    "solution_graph": {
      "curves": [
        {
          "expr": "(2*x-x^2)/(x^2-2*x-3)",
          "label": "y=\\dfrac{2x-x^2}{x^2-2x-3}",
          "domain": [
            -8,
            -1.1
          ]
        },
        {
          "expr": "(2*x-x^2)/(x^2-2*x-3)",
          "domain": [
            -0.9,
            2.9
          ]
        },
        {
          "expr": "(2*x-x^2)/(x^2-2*x-3)",
          "domain": [
            3.1,
            8
          ]
        }
      ],
      "points": [
        {
          "x": 0,
          "y": 0,
          "kind": "intercept",
          "label": "(0,\\ 0)"
        },
        {
          "x": 2,
          "y": 0,
          "kind": "intercept",
          "label": "(2,\\ 0)"
        },
        {
          "x": 1,
          "y": -0.25,
          "kind": "max",
          "label": "\\left(1,-\\tfrac{1}{4}\\right)"
        }
      ],
      "x_range": [
        -8,
        8
      ],
      "y_range": [
        -8,
        6
      ],
      "asymptotes": [
        {
          "x": -1,
          "kind": "vertical",
          "label": "x=-1"
        },
        {
          "x": 3,
          "kind": "vertical",
          "label": "x=3"
        },
        {
          "expr": "-1",
          "kind": "horizontal",
          "label": "y=-1"
        }
      ]
    }
  }
]$migr$::jsonb
WHERE id = 'cc213005-0000-0000-0000-000000000000';
