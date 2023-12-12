<post-metadata>
  <post-title>ASL: A Small Language</post-title>
  <post-date>On Nov 27, 2023</post-date>
  <post-tags>pl-theory</post-tags>
</post-metadata>

<div id="post-excerpt">
In the book Functional Programming Using Caml Light, Michel Mauny presents a
simple language called ASL: A Small Language. It is the
<imath>\\lambda</imath>-calculus enriched with a conditional construct. In this
post, I reproduce its abstract syntax, statics and operational semantics.
</div>

<div id=generated-toc></div>

ASL is interesting because it is the purely functional kernel of OCaml. It even
allows *polymorphism* with a unification algorithm.

ASL programs are built up from numbers, variables, functional expressions
(<imath>\\lambda</imath>-abstractions), applications and conditionals. The
(ambiguous) concrete syntax of ASL expressions is:

<pre class="display-math">
\begin{align*}
\mathtt{Expr} ::=&\ \mathtt{INT} \\
               |&\  \mathtt{IDENT} \\
               |&\  \mathtt{"if"\ Expr\ "then"\ Expr\ "else"\ Expr\ "fi"} \\
               |&\  \mathtt{"("\ Expr\ ")"} \\
               |&\  \mathtt{"\backslash"\ IDENT\ "."\ Expr}
\end{align*}
</pre>

And the concrete syntax of declarations:

<pre class="display-math">
\begin{align*}
\mathtt{Decl} ::=&\ \mathtt{"let"\ IDENT\ "be"\ Expr\ ";"} \\
                |&\  \mathtt{Expr\ ";"} \\
\end{align*}
</pre>

Arithmetic binary operations are written in prefix position and belong to the
class <imath>\\texttt{IDENT}</imath>. The <imath>\\backslash</imath> symbol
plays the rule of the OCaml keyword <imath>\\texttt{function}</imath>.

### ASL abstract syntax trees

Variable names are encoded by numbers representing the *binding depth*. For
example, the identity function is represented as:

<imath>\\texttt{Abs("x",\ Var\ 1)}</imath>

<imath>\\texttt{Var\ n}</imath> should be read as "an occurrence of the variable
bound by the <imath>\\texttt{n}\\text{th}</imath> abstraction node encountered when
going toward the root of the abstract syntax tree".

Here we show how the following OCaml function would be represented in ASL
abstract syntax:

<imath>\\texttt{(function\ f\ ->\ (function\ x\ ->\ f x))}</imath>

<imath>\\texttt{Abs("f",\ Abs("x",\ App(Var\ 2,\ Var\ 1)))}</imath>

It should be viewed as the tree:

<pre class="display-math">
\ttfamily
\Tree [.Abs "f" [.Abs "x" [.App {Var 2} {Var 1} ] ] ]
</pre>

The numbers encoding variables in abstract syntax tree of functional expressions
are called "De Bruijn numbers". The characters that we attach to abstraction
nodes simply serve as documentation: they are not used by any of the semantic
analyses on trees.

The ASL abstract syntax tree is:

<pre class="display-math">
\begin{align*}
\mathtt{asl} ::=&\ \mathtt{Const\ of\ int} \\
               |&\  \mathtt{Var\ of\ int} \\
               |&\  \mathtt{Cond\ of\ asl\ *\ asl\ *\ asl} \\
               |&\  \mathtt{App\ of\ asl\ *\ asl} \\
               |&\  \mathtt{Abs\ of\ string\ *\ asl} \\
\\
\mathtt{top\_asl} ::=&\ \mathtt{Decl\ of\ string\ *\ asl}
\end{align*}
</pre>

### Parsing ASL programs

> The choice of the concrete aspect of the programs is simply a matter of taste.

The tokens of this language are:

<pre class="display-math">
\begin{align*}
\mathtt{token} ::=&\ \mathtt{LET}\
                 |\  \mathtt{BE}\
                 |\  \mathtt{LAMBDA}\
                 |\  \mathtt{DOT}\
                 |\  \mathtt{LPAR}\
                 |\  \mathtt{RPAR} \\
                 |&\ \mathtt{IF}\
                 |\  \mathtt{THEN}\
                 |\  \mathtt{ELSE}\
                 |\  \mathtt{FI}\
                 |\  \mathtt{SEMIC} \\
                 |&\ \mathtt{INT\ of\ int}\
                 |\  \mathtt{IDENT\ of\ string}
\end{align*}
</pre>

In my implementation of the parser I follow the book and return an abstract
syntax tree of type <imath>\\texttt{top\\_asl}</imath>. The parser must detect
unbound identifiers at parse-time.

Because in my implementation I use OCaml and Menhir for parsing generation, I
must choose a slightly different approach than what's used in the book.

With a binding context represented by a list of variable names, and given a
recursive function that looks for the position of the first occurrence
of a variable name in the context,

<pre class="">
binding_depth s n
         [] = raise Unbound
         head :: tail = if s=head then Var n
                        else binding_depth s (n+1) tail
</pre>

The parser (Menhir) specification represents ASL expressions as a function from
context to parsed expression and a new context
(<imath>\\texttt{ctx} \\rightarrow \\texttt{asl} \\times
\\texttt{ctx}</imath>). That allows us to parse a
<imath>\\lambda\\text{-abstraction}</imath> as a *function* that, when
applied to a binding context, will add the binder to that context and then apply
the (parsed) abstraction body to this extended context. The resulting expression
and context are returned:

<pre class="language ocaml">
expr:
  | LAMBDA; x = IDENT; DOT; e = expr
    { fun ctx ->
        let e', ctx' = e (x :: ctx) in
        Abs (x, e'), ctx' }
</pre>

At the leafs of this tree, where we try to parse <imath>\\texttt{IDENT
x}</imath> for some string <imath>\\texttt{x}</imath>, we want to return
<imath>\\texttt{Var n}</imath> for some
<imath>\\texttt{n}</imath> if the binder for <imath>\\texttt{x}</imath>
exists. We simply call <imath>\\texttt{binding\\_depth}</imath> in the given
context:

<pre class="language ocaml">
atom:
  | x = IDENT
    { fun ctx ->
        try binding_depth x ctx, ctx
        with Unbound s ->
      	  failwith @@ Format.sprintf "Unbound identifier: %s" s }
</pre>

What ties everything together is when the "top-most" (parsed) expressions are
applied to the global initial context, like so:

<pre class="language ocaml">
expression:
  | e = expr
    { let e', _ = e !Sem.global_env in e' }
</pre>

At points like the one above, we don't need the resulting context anymore and
discard it.

### Static typing, polymorphism and type synthesis

This is where I learned the most from this book. It suggests that static type
synthesis be seen as a game, and:

> When learning a game, we must:
>
> a. Learn the rules (what is allowed, and what is forbidden);
> b. Learn a winning strategy

In type synthesis, the rules of the game are a *type system*, and the winning
strategy is the type checking algorithm.

In ASL, a *type* is either:

* the type Number;
* or a type variable (<imath>\\alpha,\ \\beta,\ \\dots</imath>);
* or <imath>\\tau_2 \\rightarrow \\tau_2</imath>, where <imath>\\tau_1</imath>
  and <imath>\\tau_2</imath> are types.

In a type, a type variable is an *unknown*, i.e. a type that we are
computing. We use <imath>\\tau</imath>, <imath>\\tau'</imath>,
<imath>\\tau_1</imath>, <imath>\\dots</imath>, as *metavariables* representing
types.

<pre class="display-math">
\textbf{Example}\quad $(\alpha \rightarrow Number) \rightarrow \beta
\rightarrow \beta$\quad is a type.
</pre>

A _type scheme_ is a type where some variables are distinguished as being
_generic_: <imath>\\forall \\alpha, \\dots, \\alpha_n.\\tau</imath> where
<imath>\\tau</imath> is a type.

<pre class="display-math">
\textbf{Example}\quad $\forall \alpha.(\alpha \rightarrow Number) \rightarrow
\beta \rightarrow \beta$\quad is a type scheme.
</pre>

We use <imath>\\sigma,\ \\sigma',\ \\sigma_1,\ \\dots</imath> as metavariables
representing type schemes. We write <imath>FV(\\sigma)</imath> for the set of
_unknowns_ occurring in the type scheme <imath>\\sigma</imath>. Unknowns are
also called _free variables_ (not bound by a <imath>\\forall</imath>
quantifier). We also write <imath>BV(\\sigma)</imath> for the set of type
variables occurring in <imath>\\sigma</imath> which are not free. Bound type
variables are also said to be _generic_.

<pre class="display-math">
\textbf{Example}\quad If $\sigma$ denotes the type scheme $\forall
\alpha. (\alpha \rightarrow Number) \rightarrow \beta \rightarrow \beta$, then
we have:

\begin{center}
$FV(\sigma) = \{ \beta \}$
\end{center}

and

\begin{center}
$BV(\sigma) = \{ \alpha \}$
\end{center}
</pre>

A _substitution instance_ <imath>\\sigma'</imath> of a type scheme
<imath>\\sigma</imath> is the type scheme <imath>S(\\sigma)</imath> where
<imath>S</imath> is a substitution of types for _free_ type variables appearing
in <imath>\\sigma</imath>. Renaming of bound type variables may be necessary to
avoid capture.

A _generic instance_ of a type scheme is obtained by giving more precise values
to some generic variables, and (possibly) quantifying some of the new type
variables introduced. The type scheme <imath>\\sigma' = \\forall \\beta_1 \\dots
\\beta_m. \\tau'</imath> is said to be a _generic instance_ of <imath>\\sigma =
\\forall \\alpha_1 \\dots \\alpha_n. \\tau</imath> if there exists a
substitution <imath>S</imath> such that:

* the domain of <imath>S</imath> is included in
  <imath>\\{ \\alpha_1,\ \\dots\ ,\  \\alpha_n \\}</imath>;
* <imath>\\tau' = S(\\tau)</imath>;
* no <imath>\\beta_i</imath> occurs free in <imath>\\sigma</imath>.

The type system is expressed by means of _inference rules_:

* the numerator is called the _premises_;
* the denominator is called the _conclusion_.

<pre class="display-math">
\inference{P_1\ \dots\ P_n}{C}
</pre>

* "If <imath>P_1, \\dots</imath> and <imath>P_n</imath>, then
  <imath>C</imath>".
* "In order to prove <imath>C</imath>, it is sufficient to prove <imath>P_1,
  \\dots</imath> and <imath>P_n</imath>".

In the premises and the conclusions appear _judgments_ having the form:

<pre class="display-math">
$\Gamma \vdash e : \sigma$
</pre>

Such a judgment should be read as "under the typing environment
<imath>\\Gamma</imath>, the expression <imath>e</imath> has type scheme
<imath>\\sigma</imath>". **Typing environments** are sets of _typing hypotheses_
of the form <imath>x : \\sigma</imath>, where <imath>x</imath> is an
identifier name and <imath>\\sigma</imath> is a type scheme:

> **Typing environments** give types to the variables occurring _free_
> (i.e. unbound) in the expression.

The typing environment is managed as a _stack_. In the presentation of the type
system we represent this fact by _removing_ the typing hypothesis concerning an
identifier named <imath>x</imath> (if it exists) before adding a new typing
hypothesis concerning <imath>x</imath>.

We write <imath>\\Gamma - \\Gamma(x)</imath> for the set of typing hypothesis
obtained from <imath>\\Gamma</imath> by removing the typing hypothesis
concerning <imath>x</imath> (if it exists).

<pre class="display-math">
\begin{gather*}
\inference{}{
  \Gamma \vdash \texttt{Const}\ n : \text{Number}
}[(NUM)]
\\ \\
\inference{}{
  \Gamma \cup \{x : \sigma\} \vdash \texttt{Var}\ x : \sigma
}[(TAUT)]
\\ \\
\inference{
  \Gamma \vdash e : \sigma \qquad \sigma' = \text{GenInstance}(\sigma)
}
{
  \Gamma \vdash e : \sigma'
}[(INST)]
\\ \\
\inference{
  \Gamma \vdash e : \sigma \qquad \alpha \notin FV(\Gamma)
}{
  \Gamma \vdash e : \forall \alpha. \sigma
}[(GEN)]
\\ \\
\inference{
  \Gamma \vdash e_1 : \text{Number} \qquad \Gamma \vdash e_2 : \tau \qquad
  \Gamma \vdash e_3 : \tau
}{
  \Gamma \vdash \texttt{(if e$_1$ then e$_2$ else e$_3$ fi)} : \tau
}[(IF)]
\\ \\
\inference{
  \Gamma \vdash e_1 : \tau \rightarrow \tau' \qquad \Gamma \vdash e_2 : \tau
}{
  \Gamma \vdash (e_1\ e_2) : \tau'
}[(APP)]
\\ \\
\inference{
  (\Gamma - \Gamma(x)) \cup \{x : \tau\} \vdash e : \tau')
}{
  \Gamma \vdash (\lambda x.\ e) : \tau \rightarrow \tau'
}[(ABS)]
\\ \\
\inference{
  \Gamma \vdash e : \sigma \qquad (\Gamma - \Gamma(x)) \cup \{x : \sigma\}
  \vdash e' : \tau
}{
  \Gamma \vdash (\lambda x.\ e')\ e : \tau
}[(LET)]
\end{gather*}
</pre>

Let us write a new set of inference rules that we will read as an algorithm:

Any numeric constant is of type Number:

<pre class="display-math">
\inference{}{
  \Gamma \vdash \texttt{Const}\ n : \text{Number}
}[(NUM)]
</pre>

The types of identifiers are obtained by taking the generic instances of
type schemes appearing in the typing environment:

<pre class="display-math">
\inference{
  \tau = \text{GenInstance($\sigma$)}
}
{
  \Gamma \cup \{x : \sigma\} \vdash \texttt{Var}\ x : \tau
}[(INST)]
</pre>

The <imath>\\text{(INST)}</imath> rule is implemented by:

1. taking as <imath>\\tau</imath> the "most general generic instance" of
   <imath>\\sigma</imath> that is type;
2. making <imath>\\tau</imath> more specific by _unification_ when encountering
   equality constraints.

As an example of equality constraint between the types of two expressions,
typing a conditional requires the test part to be of type
<imath>\\text{Number}</imath>, and both alternatives to be of the same type
<imath>\\tau</imath>.

<pre class="display-math">
\inference{
  \Gamma \vdash e_1 : \text{Number} \qquad \Gamma \vdash e_2 : \tau \qquad
  \Gamma \vdash e_3 : \tau
}
{
  \Gamma \vdash \texttt{(if $e_1$ then $e_2$ else $e_3$ fi)} : \tau
}[(COND)]
</pre>

Typing an application produces also equality constraints that are to be solved
by unification:

<pre class="display-math">
\inference{
  \Gamma \vdash e_1 : \tau \rightarrow \tau' \qquad \Gamma \vdash e_2 : \tau
}
{
  \Gamma \vdash (e_1\ e_2) : \tau'
}[(APP)]
</pre>

Typing an abstraction "pushes" a typing hypothesis for the abstracted
identifier: unification will make it more precise during the typing of the
abstraction body:

<pre class="display-math">
\inference{
  (\Gamma - \Gamma (x)) \cup \{x : \forall.\ \tau\} \vdash e : \tau'
}
{
  \Gamma \vdash (\lambda x.\ e) : \tau \rightarrow \tau'
}[(ABS)]
</pre>

Typing a <imath>\\texttt{let}</imath> construct involves a generalization step:
we generalize as much as possible:

<pre class="display-math">
\inference{
  \Gamma \vdash e : \tau' \qquad \{\alpha_1, \dots, \alpha_n\} =
  FV(\tau') - FV(\Gamma) \qquad (\Gamma - \Gamma (x)) \cup \{x : \forall a_1 \dots
  a_n.\ \tau'\} \vdash e' : \tau
}
{
  \Gamma \vdash (\lambda x.\ e')\ e : \tau
}[LET]
</pre>

> This set of inference rules represents an algorithm because there is exactly
> one conclusion for each syntactic ASL construct (giving priority to the
> <imath>\\text{(LET)}</imath> rule over the regular application rule).

The algorithm is _syntax directed_ since, for a given expression, a type
deduction for that expression uses exactly one rule per sub-expression. **The
deduction possesses the same structure as the expression**.
