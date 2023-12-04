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
\begin{enumerate}
  \item \texttt{\{true, false, 0\}} $\subseteq$ $\mathcal{T}$;
  \item if\ \texttt{t$_1$} $\in$ $\mathcal{T}$,\ then\ \texttt{\{succ t$_1$,
pred t$_1$, iszero t$_1$\}} $\subseteq$ $\mathcal{T}$;
  \item if\ \texttt{t$_1$} $\in$ $\mathcal{T}$, \texttt{t$_2$} $\in$
  $\mathcal{T}$,\ and\ \texttt{t$_3$} $\in$ $\mathcal{T}$,\ then\ \texttt{if t$_1$
  then t$_2$ else t$_3$} $\in$ $\mathcal{T}$.
\end{enumerate}
</pre>
