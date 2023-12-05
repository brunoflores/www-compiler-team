<post-metadata>
  <post-title>How to Prove It</post-title>
  <post-date>On Dec 05, 2023</post-date>
  <post-tags></post-tags>
</post-metadata>

<div id="post-excerpt">
Lorem.
</div>

<div id=generated-toc></div>

### Deductive Reasoning and Logical Connectives

The choice of proof structure is guided by the logical form of the statement
being proven. Three examples:

1. It will either rain or snow tomorrow. </br>
   It's too warm for snow. </br>
   Thereforre, it will rain.
2. If today is Sunday, then I don't have to go to work today. </br>
   Today is Sunday. </br>
   Therefore, I don't have to go to work today.
3. I will go to work either tomorrow or today. </br>
   I'm going to stay home today. </br>
   Therefore, I will go to work tomorrow.

<imath>\\boldsymbol{\\rightarrow}</imath> We arrive at a _conclusion_ from the
assumption that some other statements, called _premises_, are true.

<imath>\\boldsymbol{\\rightarrow}</imath> We say that an argument is _valid_ if
the premises cannot all be true without the conclusion being true as well.

Arguments 1 and 3 above share the same structure:

<pre class="display-math">
P or Q. \\
Not Q. \\
Therefore, P.
</pre>

This form, not the subject matter, is what makes these arguments valid.

<pre class="display-math">
\begin{tabular}{c c}
Symbol & Meaning \\
\hline
$\vee$ & or \\
$\wedge$ & and \\
$\neg$ & not
\end{tabular}
</pre>

<imath>\\boldsymbol{\\rightarrow}</imath> "Ungrammatical" vs "Grammatical"
expressions (_well-formed formulas_ or just _formulas_).

To determine the logical form of a statement you must think about what the
statement means, rather than just translating word by word into symbols!

<imath>\\boldsymbol{\\rightarrow}</imath> The statement
<imath>y \\in \\{ x\ |\ x^2 < 9 \\}</imath> is a statement about
<imath>y</imath>, but not <imath>x</imath>!

The **free variables** in a statement stand for objects that the statement says
something about. They are free to stand for anything. Note <imath>x</imath> is a
bound variable in the statement
<imath>y \\in \\{ x\ |\ x^2 < 9 \\}</imath> even though it is a free variable in
the statement <imath>x^2 < 9</imath>. The notation
<imath>\\{ x\ |\ \\dots \\}</imath> *binds* the variable <imath>x</imath>.

**Important distinction:**

* expressions that are mathematical statements;
* expressions that are names for mathematical objects.

For some statement <imath>P(x)</imath>, the *truth set* of <imath>P(x)</imath>
is the set of values of <imath>x</imath> for which <imath>P(x)</imath> is
true. In other words: it is the set defined by using the statement
<imath>P(x)</imath> as the elementhood test: <imath>\\{ x\ |\ P(x) \\}</imath>.

Suppose <imath>A</imath>is the truth set of a statement
<imath>P(x)</imath>. According to the definition of truth set, <imath>y \\in
A</imath> means the same thing as <imath>P(y)</imath>.

Free variables *range over* a *universe of discourse* for the
statement. Sometimes this universe can be determined from context. When not,
<imath>\\{ x \\in U\ |\ P(x) \\}</imath> reads "the set of all <imath>x</imath>
in <imath>U</imath> such that <imath>P(x)</imath>".

This explicit notation can be used to restrict attention to just a part of the
universe.

In general, <imath>y \\in \\{ x \\in A\ |\ P(x) \\}</imath> means the same thing
as <imath>y \\in A \\wedge P(y)</imath>.

> When a new mathematical concept has been defined, mathematicians are usually
> interested in studying any possible extremes of this concept.

The empty set has no elements. The statement <imath>x \\in \\varnothing</imath>
is an example of a statement that is always false, no matter what
<imath>x</imath> is.

### Operations on Sets

<pre class="display-math">
\begin{theorem}
For any sets A and B, (A $\cup$ B) $\setminus$  B $\subseteq$ A.
\end{theorem}

\begin{proof}
We must show that if something is an element of (A $\cup$ B) $\setminus$ B, then
it must also be an element of A. Suppose that x $\in$ (A $\cup$ B) $\setminus$
B. This means that x $\in$ A $\cup$ B and x $\notin$ B, or in other words x
$\in$ A $\vee$ x $\in$ B and x $\notin$ B. Note that these statements have the
logical form P $\vee$ Q and $\neg$ Q. We can conclude that x $\in$ A must be
true. Thus, anything that is an element of (A $\cup$ B) $\setminus$ B must be an
element of A, so (A $\cup$ B) $\setminus$  B $\subseteq$ A.
\end{proof}
</pre>
