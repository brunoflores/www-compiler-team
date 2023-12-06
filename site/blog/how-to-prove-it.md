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

### Quantifiers

We often want to say either that <imath>P(x)</imath> is true for _every_ value
of <imath>x</imath> or that it is true for _at least one_ value of <imath>x</imath>.

<imath>\\boldsymbol{\\rightarrow}</imath> When the truth set of
<imath>P(x)</imath> is equal to <imath>U</imath>, we say
<imath>\\forall x. P(x)</imath>.

<imath>\\boldsymbol{\\rightarrow}</imath> When the truth set is not
<imath>\\varnothing</imath>, we say <imath>\\exists x. P(x)</imath>.

When translating an English statement into symbols, look for words _everyone_,
_someone_, _everything_, _something_.

1. Someone didn't do the homework: <imath>\\exists x.\ \\neg P(x).</imath>
2. Everything in that store is either overpriced or poorly made:
   <imath>\\forall x.\ O(x) \\vee PM(x)</imath>.
3. Nobody's perfect: <imath>\\forall x.\ \\neg P(x)</imath>.
4. Susan likes everyone who dislikes Joe: Let <imath>j</imath> stand for Joe,
   and <imath>s</imath> stand for Susan:
   <imath>\\forall x.\ (\\neg L(x, j) \\rightarrow L(s, x))</imath>.
5. <imath>A \\subseteq B</imath>:
   <imath>\\forall x.\ (x \\in A \\rightarrow x \\in B)</imath>.
6. <imath>A \\cap B \\subseteq B \\setminus C</imath>:
   <imath>\\forall x.\ [(x \\in A \\wedge x \\in B) \\rightarrow (x \\in B \\wedge
   x \\notin C)]</imath>.
7. Some students are married: Let <imath>S(x)</imath> stand for
   "<imath>x</imath> is a student". Let <imath>M(x,y)</imath> stand for "x is
   married to y". We can now represent the entire statement by the formula:
   <imath>\\exists x.\ (S(x) \\wedge \\exists y.\ M(x, y)))</imath>.
8. All parents are married: Let <imath>P(x,y)</imath> stand for
   "<imath>x</imath> is a parent of <imath>y</imath>".
   <imath>\\exists y.\ P(x,y)</imath> means that "<imath>x</imath> is a
   parent". Statement is <imath>\\forall x. (\\exists y.\ P(x,y) \\rightarrow
   \\exists z.\ M(x,z))</imath>.
9. Everybody in the dorm has a roommate he or she doesn't like:
   <imath>\\forall x.\ (D(x) \\rightarrow \\exists y.\ (R(x,y) \\wedge \\neg
   L(x, y)))</imath>.
10. Nobody likes a sore loser: <imath>\\forall x.\ (S(x) \\rightarrow \\neg
    \\exists y.\ L(y,x))</imath>. To say that nobody likes <imath>x</imath>, we
    write <imath>\\neg (\\text{somebody likes }x)</imath>.

### Equivalences Involving Quantifiers

**Quantifier Negation laws**

<pre class="display-math">
\begin{gather*}
\neg \exists x. P(x)\quad \text{is equivalent to}\quad \forall x. \neg P(x). \\
\neg \forall x. P(x)\quad \text{is equivalent to}\quad \exists x. \neg P(x).
\end{gather*}
</pre>

> We can often re-express a negative statement as an equivalent, but easier to
> understand, positive statement.

1. <imath>A \\subseteq B.</imath> \
   <imath>\\neg \\forall x.\ (x \\in A \\rightarrow x \\in B).</imath>
   1. <imath>\\exists x.\ \\neg (x \\in A \\rightarrow x \\in B)</imath>
      (quantifier negation law),
   2. <imath>\\exists x.\ \\neg (x \\notin A \\vee x \\in B)</imath>
      (conditional law),
   3. <imath>\\exists x.\ (x \\in A \\wedge x \\notin B)</imath> (De Morgan's
      law).

Thus, to say that <imath>A \\nsubseteq B</imath> is to say "there's something in
<imath>A</imath> that is not in <imath>B</imath>".

<pre class="display-math">
Suppose $\mathcal{F}$ is a family of sets. Then the \textit{intersection} and
\textit{union} of $\mathcal{F}$ are the sets $\bigcap$ $\mathcal{F}$ and
$\bigcup$ $\mathcal{F}$ defined as follows:

\begin{align*}
&\bigcap \mathcal{F} = \{ x\ |\ \forall A \in \mathcal{F}\ (x \in A) \}
  = \{ x\ |\ \forall A\ (A \in \mathcal{F} \rightarrow x \in A) \}. \\
&\bigcup \mathcal{F} = \{ x\ |\ \exists A \in \mathcal{F}\ (x \in A) \}
  = \{ x\ |\ \exists A\ (A \in \mathcal{F} \wedge x \in A) \}.
\end{align*}
</pre>

Intersection and union of family of sets are **generalizations** of the
definitions of the intersection and union of two sets!

<pre class="display-math">
Notice that if A and B are any two sets and $\mathcal{F}$ = \{A,\ B\}, then

\begin{align*}
&\bigcap \mathcal{F} = A \cap B. \\
&\bigcup \mathcal{F} = A \cup B.
\end{align*}
</pre>

### Proof Strategies

How to figure out and write up the proof of a theorem will depend mostly on the
logical form of the conclusion.

<pre class="display-math">
\setlength{\parindent}{15pt}

\indent \textbf{To prove a goal of the form} $P \rightarrow Q$: \\
\indent Assume $P$ is true and then prove $Q$. \\
\\
\textit{Scratch work} \\
\\

Before using strategy:

\begin{table}
\centering
\begin{tabular}{c c}
\underline{Givens} & \underline{Goal} \\
--- & $P \rightarrow Q$ \\
--- & \\
\end{tabular}
\end{table}

After using strategy:

\begin{table}
\centering
\begin{tabular}{c c}
\underline{Givens} & \underline{Goal} \\
--- & $Q$ \\
--- & \\
$P$ & \\
\end{tabular}
\end{table}

\textit{Form of final proof:} \\
\\
\indent Suppose $P$. \\
\indent \indent [Proof of $Q$ goes here.] \\
\indent Therefore $P \rightarrow Q$.
</pre>

There is a second method for proving goals of the form <imath>P \\rightarrow
Q</imath>. Any conditional statement <imath>P \\rightarrow Q</imath> is
equivalent to its contrapositive <imath>\\neg Q \\rightarrow \\neg P</imath>
(both have the same truth value).



<pre class="display-math">
\setlength{\parindent}{15pt}

\indent \textbf{To prove a goal of the form} $P \rightarrow Q$: \\
\indent Assume $Q$ is false and then prove that $P$ is false. \\
\\
\textit{Scratch work} \\
\\

Before using strategy:

\begin{table}
\centering
\begin{tabular}{c c}
\underline{Givens} & \underline{Goal} \\
--- & $P \rightarrow Q$ \\
--- & \\
\end{tabular}
\end{table}

After using strategy:

\begin{table}
\centering
\begin{tabular}{c c}
\underline{Givens} & \underline{Goal} \\
--- & $\neg P$ \\
--- & \\
$\neg Q$ & \\
\end{tabular}
\end{table}

\textit{Form of final proof:} \\
\\
\indent Suppose $Q$ is false. \\
\indent \indent [Proof of $\neg P$ goes here.] \\
\indent Therefore $P \rightarrow Q$.
</pre>

#### Proofs Involving Negations and Conditionals

<pre class="display-math">
\setlength{\parindent}{15pt}

\indent \textbf{To prove a goal of the form} $\neg P$: \\
\indent If possible, re-express the goal in some other form and then use one of
the proof strategies for this other goal form.
</pre>

If a goal of the form <imath>\\neg P</imath> cannot be re-expressed as a
positive statement, do a _proof by contradiction_:

<pre class="display-math">
\setlength{\parindent}{15pt}

\indent \textbf{To prove a goal of the form} $\neg P$: \\
\indent Assume $P$ is true and try to reach a contradiction. One you have
reached a contradiction, you can conclude that $P$ must be false. \\
\\
\textit{Scratch work} \\
\\

Before using strategy:

\begin{table}
\centering
\begin{tabular}{c c}
\underline{Givens} & \underline{Goal} \\
--- & $\neg P$ \\
--- & \\
\end{tabular}
\end{table}

After using strategy:

\begin{table}
\centering
\begin{tabular}{c c}
\underline{Givens} & \underline{Goal} \\
--- & Contradiction \\
--- & \\
$P$ & \\
\end{tabular}
\end{table}

\textit{Form of final proof:} \\
\\
\indent Suppose $P$ is true. \\
\indent \indent [Proof of contradiction goes here.] \\
\indent Thus, $P$ is false.
</pre>
