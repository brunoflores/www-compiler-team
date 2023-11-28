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

ASL is interesting because it is the purely functional kernel of OCaml.

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

<pre class="language ocaml">
top:
  | EOF
    { Decl ("it", Const 0) }
  | LET; x = IDENT; BE; e = expression; SEMIC; EOF
    { Decl (x, e)  }
  | e = expression; SEMIC; EOF
    { Decl ("it", e) }
</pre>
