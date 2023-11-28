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
* or <imath>\\tau_2\ \\rightarrow\ \\tau_2</imath>, where <imath>\\tau_1</imath>
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
