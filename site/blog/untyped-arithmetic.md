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



### Evaluation

<pre class="display-math">
\begin{alignat*}{3}
& \textit{Syntax} &&& \\
& \graybox{\texttt{t}} ::= &&& \qquad \textit{terms:} \\
&&& \graybox{\texttt{true}} & \qquad \textit{constant true} \\
&&& \graybox{\texttt{false}} & \qquad \textit{constant false} \\
&&& \graybox{\texttt{if t then t else t}} & \qquad \textit{conditional} \\
\\
& \graybox{\texttt{v}} ::= &&& \qquad \textit{values:} \\
&&& \graybox{\texttt{true}} & \qquad \textit{true value} \\
&&& \graybox{\texttt{false}} & \qquad \textit{false value} \\
\end{alignat*}

\begin{alignat*}{3}
& \textit{Evaluation} &&& \boxed{\texttt{t $\rightarrow$ t$'$}} \\
& \graybox{\texttt{if true then t$_2$ else t$_3$} $\rightarrow$ t$_2$} &&&
\qquad \text{(E-IfTrue)} \\
& \graybox{\texttt{if false then t$_2$ else t$_3$} $\rightarrow$ t$_3$} &&&
\qquad \text{(E-IfFalse)} \\
& \graybox{
    \inference{
      \texttt{t$_1$ $\rightarrow$ t$_1'$}
    }{
      \begin{array}{@{}c@{}}
      \texttt{if t$_1$ then t$_2$ else t$_3$} \\
      \rightarrow \texttt{if t$_1'$ then t$_2$ else t$_3$}
      \end{array}
    }} &&& \qquad \text{(E-If)} \\
\end{alignat*}
</pre>
