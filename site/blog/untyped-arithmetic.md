<post-metadata>
  <post-title>Untyped Arithmetic Expressions</post-title>
  <post-date>On Dec 04, 2023</post-date>
  <post-tags>pl-theory</post-tags>
</post-metadata>

<div id="post-excerpt">
The first system studied in Benjamin C. Pierce's book Types And Programming
Languages is a language of booleans and numbers. It is used a vehicle for the
introduction of fundamental concepts for expressing and reasoning about the
syntax and semantics of programs.
</div>

<div id=generated-toc></div>

### Grammar

The grammar is presented in standard BNF notation:

<pre class="display-math">
\begin{align*}
\texttt{t}\ ::=&                              & \text{terms:} \\
               &\ \texttt{true}               & \text{constant true} \\
               &\ \texttt{false}              & \text{constant false} \\
               &\ \texttt{if t then t else t} & \text{conditional} \\
               &\ \texttt{0}                  & \text{constant zero} \\
               &\ \texttt{succ t}             & \text{successor} \\
               &\ \texttt{pred t}             & \text{predecessor} \\
               &\ \texttt{iszero t}           & \text{zero test}
\end{align*}
</pre>

This object language doesn't even have variables. The <imath>\\texttt{t}</imath>
symbol above is a _meta-variable_ ranging over _terms_.

The grammar above is a compact notation for the following inductive definition:

<pre class="display-math">
Definition [Terms, inductively]: The set of \textit{terms} is the smallest set
$\mathcal{T}$ such that

\begin{enumerate}
  \item \texttt{\{true, false, 0\}} $\subseteq$ $\mathcal{T}$;
  \item if\ \texttt{t$_1$} $\in$ $\mathcal{T}$,\ then\ \texttt{\{succ t$_1$,
pred t$_1$, iszero t$_1$\}} $\subseteq$ $\mathcal{T}$;
  \item if\ \texttt{t$_1$} $\in$ $\mathcal{T}$, \texttt{t$_2$} $\in$
  $\mathcal{T}$,\ and\ \texttt{t$_3$} $\in$ $\mathcal{T}$,\ then\ \texttt{if t$_1$
  then t$_2$ else t$_3$} $\in$ $\mathcal{T}$.
\end{enumerate}
</pre>

Another way is to use two-dimensional _inference rules_:

<pre class="display-math">
Definition [Terms, by inference rules]: The set of terms is defined by the
following rules:
\begin{gather*}
\inference{}{
  \texttt{true} \in \mathcal{T}
}[]
\qquad
\inference{}{
  \texttt{false} \in \mathcal{T}
}[]
\qquad
\inference{}{
  \texttt{0} \in \mathcal{T}
}[]
\\ \\
\inference{
  \texttt{t$_1$} \in \mathcal{T}
}{
  \texttt{succ t$_1$} \in \mathcal{T}
}[]
\qquad
\inference{
  \texttt{t$_1$} \in \mathcal{T}
}{
  \texttt{pred t$_1$} \in \mathcal{T}
}[]
\qquad
\inference{
  \texttt{t$_1$} \in \mathcal{T}
}{
  \texttt{iszero t$_1$} \in \mathcal{T}
}[]
\\ \\
\inference{
  \texttt{t$_1$} \in \mathcal{T}
  \quad
  \texttt{t$_2$} \in \mathcal{T}
  \quad
  \texttt{t$_3$} \in \mathcal{T}
}{
  \texttt{if t$_1$ then t$_2$ else t$_3$} \in \mathcal{T}
}[]
\end{gather*}
</pre>

> These are actually not "inference rules", but _rule schemas_, since their
> premises and conclusions may include meta-variables.

Formally, each schema represents the infinite set of _concrete rules_ that can
be obtained by replacing each meta-variable consistently by all phrases from the
appropriate syntactic category.

Yet another definition of the same set of terms in a more "concrete" style that
gives an explicit procedure for _generating_ the element of
<imath>\\mathcal{T}</imath>:


<pre class="display-math">
Definition [Terms, concretely]: For each natural number $i$, define a set
$\text{S}_i$ as follows:

\begin{align*}
\text{S}_0     =&\ \varnothing \\
\text{S}_{i+1} =&\ \qquad \texttt{\{true, false, 0\}} \\
         &\ \cup \quad \texttt{\{succ t$_1$, pred t$_1$, iszero t$_1$ | t$_1$
                        $\in$}\ \text{S}_1 \texttt{\}} \\
         &\ \cup \quad \texttt{\{if t$_1$ then t$_2$ else t$_3$ | t$_1$, t$_2$,
         t$_3$ $\in$}\ \text{S}_i \texttt{\}}. \\ \\

\text{Finally, let} \\

\text{S} =& \bigcup_i{S_i}.
\end{align*}
</pre>

The <imath>depth(\\texttt{t})</imath> is the smallest <imath>i</imath> such that
<imath>\\texttt{t} \\in \\text{S}_i</imath> according to the definition above:

<pre class="display-math">
\begin{alignat*}{2}
& depth(\texttt{true}) &&= 1 \\
& depth(\texttt{false}) &&= 1 \\
& depth(\texttt{0}) &&= 1 \\
& depth(\texttt{succ t$_1$}) &&= depth(\texttt{t$_1$}) + 1 \\
& depth(\texttt{pred t$_1$}) &&= depth(\texttt{t$_1$}) + 1 \\
& depth(\texttt{iszero t$_1$}) &&= depth(\texttt{t$_1$}) + 1 \\
& depth(\texttt{if t$_1$ then t$_2$ else t$_3$}) &&=
    \text{max}(depth(\texttt{t$_1$}),\ depth(\texttt{t$_2$}),\
    depth(\texttt{t$_3$})) + 1
\end{alignat*}
</pre>

### Semantic Styles

Similar to how the grammar is a precise definition of the syntax, the
_semantics_ of a language precisely defines how terms are evaluated.

Tree basic approaches to formalizing semantics:

1. _Operational semantics_ specifies the behaviour of a programming language by
   defining an _abstract machine_ for it. This "machine" uses the terms of the
   language as its machine code. A _transition function_ gives, for each state,
   the next state by performing a step of simplification on the term or declares
   that the machine has halted. The _meaning_ of a term
   <imath>\\texttt{t}</imath> is the final state that the machine reaches when
   started with <imath>\\texttt{t}</imath> as its initial state.
2. _Denotational semantics_ is a more abstract view of meaning. Instead of a
   sequence of machine states, the meaning of a term is some mathematical
   object. It consists of finding a collection of _semantic domains_ and then
   defining an _interpretation function_ mapping terms into elements of these
   domains (research area: _domain theory_).
3. _Axiomatic semantics_ is a more direct approach. Instead of first defining
   the behaviors of programs (by some operational or denotational semantics)
   and then deriving laws from this definition, axiomatic methods take the laws
   _themselves_ as the definition of the language. They focus on the process of
   reasoning about programs.

### Evaluation

Abstract syntax

<pre class="display-math-fresh">
\begin{isabelle}
\bterm
\end{isabelle}
</pre>

Concrete syntax

<pre class="display-math">
\begin{alignat*}{3}
& \graybox{\texttt{t}} ::= &&& \qquad \textit{terms:} \\
&&& \graybox{\texttt{true}} & \qquad \textit{constant true} \\
&&& \graybox{\texttt{false}} & \qquad \textit{constant false} \\
&&& \graybox{\texttt{if t then t else t}} & \qquad \textit{conditional}
\end{alignat*}
</pre>

Values are a subset of terms. They are possible final results of evaluation:

<pre class="display-math-fresh">
\begin{isabelle}
\begin{gather*}
\graybox{\isValueBTrue} \qquad
\graybox{\isValueBFalse}
\end{gather*}
\end{isabelle}
</pre>

Evaluation relation on terms: "<imath>\\texttt{t}</imath> evalutes to
<imath>\\texttt{t'}</imath> in one step".

<pre class="display-math-fresh">
\begin{isabelle}
\begin{alignat*}{3}
& \graybox{\EIfTrue} &&& \boxed{\texttt{t $\rightarrow$ t$'$}} \\
& \graybox{\EIfFalse} &&& \\
& \graybox{\EIf} &&& \\
\end{alignat*}
\end{isabelle}
</pre>

Evaluation is defined as two axioms and one inference rule.

> What these rules do _not_ say is just as important as what they do say.

Constants <imath>\\texttt{true}</imath> and <imath>\\texttt{false}</imath> do
not evaluate to anything. The interplay between the rules determines a
particular _evaluation strategy_.

Rules <imath>\\textsf{E-IfTrue}</imath> and
<imath>\\textsf{E-IfFalse}</imath> do the real work of evaluation (_computation
rules_), while <imath>\\textsf{E-If}</imath> helps determine where the work is
to be done (_congruence rules_).

<pre class="display-math-fresh">
\begin{isabelle}
\determinacy
\end{isabelle}
</pre>

A term t is is normal form if no evaluation rule applies to it:

<pre class="display-math-fresh">
\begin{isabelle}
\normalFormDef
\end{isabelle}
</pre>

Every value is in normal form:

<pre class="display-math-fresh">
\begin{isabelle}
\valueImpNormal
\end{isabelle}
</pre>

In this simple language, the converse is also true: every normal form is a
value.

<pre class="display-math-fresh">
\begin{isabelle}
\normalImpValue
\end{isabelle}
</pre>

**_Run-time errors_**: The above theorem is not the case in general. When normal
forms do not evaluate to a value, we might have a _run-time error_.

The _multi-step evaluation_ relation <imath>\\rightarrow^\\star</imath> is the
reflexive, transitive closure of one-step evaluation. That is, it is the
smallest relation such that:

1. if <imath>\\texttt{t} \\rightarrow \\texttt{t}^\\prime</imath>, then
   <imath>\\texttt{t} \\rightarrow^\\star \\texttt{t}^\\prime</imath>, and
2. <imath>\\texttt{t} \\rightarrow^\\star \\texttt{t}</imath> for all
   <imath>\\texttt{t}</imath>, and
3. if <imath>\\texttt{t} \\rightarrow^\\star \\texttt{t}^\\prime</imath> and
   <imath>\\texttt{t}^\\prime \\rightarrow^\\star \\texttt{t}^{\\prime
   \\prime}</imath>, then
   <imath>\\texttt{t} \\rightarrow^\\star \\texttt{t}^{\\prime \\prime}</imath>.

As inference rules:

<pre class="display-math-fresh">
\begin{isabelle}
\begin{gather*}
\graybox{\eOnce} \qquad \graybox{\eSelf} \qquad \graybox{\eTransitive}
\end{gather*}
\end{isabelle}
</pre>
