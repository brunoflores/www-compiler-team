<h2 id="post-header">Implementation of Caml Light in OCaml</h2>

**What is Caml Light**? From the now deprecated web site,
[caml.inria.fr](https://caml.inria.fr/caml-light/index.en.html):

>  Caml Light is a lightweight, portable implementation of the core Caml
>  language that was developed in the early 1990's, as a precursor to
>  OCaml. [...]
>  Caml Light is implemented as a bytecode compiler, and fully
>  bootstrapped. The runtime system and bytecode interpreter is written in
>  standard C, hence Caml Light is easy to port to almost any 32 or 64 bit
>  platform.

Its last release was version 0.74, released in December 2, 1997.

My purpose with this project is to better understand an implementation of the
"core Caml". The core is essentially OCaml, without many of the features in
today's implementation. For the implementation, I follow **Part II** in the
user's manual: "The Caml Light language reference manual", which can still be
downloaded from [here](https://caml.inria.fr/caml-light/release.en.html).

## What can Caml Light do for us?

Examples in this section are drawn from the text "Functional programming using
Caml Light", by Michel Mauny. It can be downloaded from
[here](https://caml.inria.fr/pub/docs/fpcl/index.html).

Some fundamental points about ML dialects:

1. ML dialects are functional but not *purely functional*
2. ML languages are based on a sugared version of the lambda calculus
3. Evaluation regime is *by-value*
4. Type-checking is more precisely *type-synthesis*
5. The relative evaluation order of the functional expression and the argument
   expression is implementation-dependent

The different phases of the Caml evaluation process are:

1. Parsing
2. Type synthesis
3. Compiling
4. Loading
5. Executing
6. Printing the result of execution

<pre class="display-math">
\begin{align*}
successor : &\ N \longrightarrow N \\
            &\ n \longmapsto n+1
\end{align*}
</pre>

The functional composition:

<pre class="display-math">
\begin{align*}
\circ : &\ (A \Rightarrow B) \times (C \Rightarrow A) \longrightarrow
           (C \Rightarrow B) \\
        &\ (f, g) \longmapsto (x \longmapsto f\ (g\ x))
\end{align*}
</pre>

<pre class="language-ocaml">
(function x -> x+1) (2+3)
</pre>

Evaluation by rewriting:

<pre class="display-math">
\ttfamily

\begin{center}
(function x -> x) \underline{(2+3)} \\
\textdownarrow

\underline{(function x -> x) 5} \\

\textdownarrow

\underline{5+1} \\

\textdownarrow

6
\end{center}
</pre>

<pre class="display-math">
\ttfamily

\begin{center}
\underline{(function x -> x) (2+3)} \\
\textdownarrow

\underline{(2+3)} + 1 \\

\textdownarrow

\underline{5+1} \\

\textdownarrow

6
\end{center}
</pre>

The evaluation of the (well-typed) application <imath>e_1(e_2)</imath>, where
<imath>e_1</imath> and <imath>e_2</imath> denote arbitrary expressions, consists
in the following steps:

* Evaluate <imath>e_2</imath>, obtaining its value <imath>v</imath>
* Evalute <imath>e_1</imath> until it becomes a *functional value*. Because of
  the *well-typing hypothesis*:

<pre class="display-math">
\begin{align*}
f : &\ t_1 \longrightarrow t_2 \\
    &\ x \longmapsto e
\end{align*}
</pre>

* Evaluate <imath>e</imath> where <imath>v</imath> has been substituted for all
occurrences of <imath>x</imath>

### Types

> The universe of Caml values is partitioned into *types*. A type represents a
> collection of values.

Types are divided into two classes:

* Basic types
* Compound types

<pre class="display-math">
\begin{align*}
BasicType ::=&\  \mathtt{int} \\
            |&\  \mathtt{bool} \\
            |&\  \mathtt{string} \\
\\
Type      ::=&\  BasicType \\
            |&\  Type\  \texttt{->}\  Type \\
            |&\  Type\  \texttt{*}\  Type
\end{align*}
</pre>

### Functions

> The most important kind of values in functional programming are functional
> values.

Mathematically, a function <imath>f</imath> of type <imath>A \\rightarrow
B</imath>  is a rule of correspondence which associates with each element of
type <imath>A</imath> a unique member of type <imath>B</imath>.

Functions are values as other values.

<pre class="language-ocaml">
function f -> (function x -> (f (x+1) - 1))
</pre>

The function above has type <imath>\\texttt{(int -> int) -> (int -> int)}</imath>.

### Definitions

The following function application,

<pre class="language-ocaml">
(function y -> y+1) (1+2)
</pre>

Can also be written as,

<pre class="language-ocaml">
let y = 1+2 in y+1
</pre>

The <imath>\\texttt{let}</imath> construct introduces *local bindings of values
to identifiers*.

Local bindings using <imath>\\texttt{let}</imath> also introduct *sharing* of
(possibly time-consuming) evaluations. When evaluating <imath>\\texttt{let x =
}e_1\\texttt{ in }e_2</imath>, <imath>e_1</imath> gets evaluated only once.

The <imath>\\texttt{let}</imath> construct also have a global form for toplevel
declarations, as in:

<pre class="language-ocaml">
let successor = function x -> x+1
</pre>

Or even,

<pre class="language-ocaml">
let successor x = x+1
</pre>

### Basic types

#### Numbers

Caml Light provides two numeric types: integers (type
<imath>\\texttt{int}</imath>) and floating-point numbers (type
<imath>\\texttt{float}</imath>). Integers are limited to the range
<imath>-2^{30} \\dots 2^{30}</imath>. Integer arithmetic is taken modulo
<imath>2^{31}</imath>. Predefined operations on integers include:

<pre class="display-math">
\begin{align*}
\texttt{+} &\quad \text{addition} \\
\texttt{-} &\quad \text{subtraction and unary minus} \\
\texttt{*} &\quad \text{multiplication} \\
\texttt{/} &\quad \text{division} \\
\texttt{mod} &\quad \text{modulo}
\end{align*}
</pre>

A separate set of floating-point arithmetic operations is provided:

<pre class="display-math">
\begin{align*}
\texttt{+.} &\quad \text{addition} \\
\texttt{-.} &\quad \text{subtraction and unary minus} \\
\texttt{*.} &\quad \text{multiplication} \\
\texttt{/.} &\quad \text{division} \\
\texttt{sqrt} &\quad \text{square root} \\
\texttt{exp, log} &\quad \text{exponential and logarithm} \\
\texttt{sin, cos,}\dots &\quad \text{usual trigonometric operations}
\end{align*}
</pre>

Example:

<pre class="language-ocaml">
let newton f epsilon =
  let rec until p change x =
            if p x then x
            else until p change (change x) in
  let satisfied y = abs (f y) <. epsilon in
  let improve y = y -. (f y /. (deriv f y epsilon) in
  until satisfied improve
</pre>

#### Boolean values

The presence of the conditional construc implies the presence of boolean
value. The type <imath>\\texttt{bool}</imath> is composed of two values
<imath>\\texttt{true}</imath> and <imath>\\texttt{false}</imath>.

#### Equality

Equality has a special status in functional languages because of functional
values. It is impossible, in the general case, to decide the equality of
functional values. Equality stops on a run-time error when it encounters
functional values.

The type of equality is a *polymorphic type*, it may take several possible
forms. When testing equality of two numbers, then its type is
<imath>\\texttt{int -> int -> bool}</imath>, and when testing equality of
strings, its type is <imath>\\texttt{string -> string -> bool}</imath>.

The type of equality uses *type variables*,

<imath>\\texttt{'a -> 'a -> bool}</imath>

Any type can be substituted to type variables in order to produce specific
*instances* of types.

#### Conditional

Conditional expressions are of the form <imath>\\texttt{if } e_{test} \\texttt{
then } e_1 \\texttt{ else } e_2</imath>, where <imath>e_{test}</imath> is an
expression of type <imath>\\texttt{bool}</imath>, and <imath>e_1, e_2</imath>
are expressions possessing the same type.

#### Logical operators

Disjunction and conjunction are respectively written <imath>\\texttt{or}</imath>
and <imath>\\texttt{\\&}</imath>. They are not functions, since they evaluate
their second argument only if it is needed.

<pre class="display-math">
\begin{align*}
e_1 &\texttt{ or } e_2 & \text{is equivalent to}&\qquad \texttt{if }
e_1 \texttt{ then } \texttt{true} \texttt{ else } e_2 \\
e_1 &\texttt{ \& } e_2 & \text{is equivalent to}&\qquad \texttt{if }
e_1 \texttt{ then } e_2 \texttt{ else } \texttt{false}
\end{align*}

</pre>

The <imath>\\texttt{not}</imath> identifier receives a special treatment from
the parser: the application <imath>\\texttt{not f x}</imath> is recognized as
"<imath>\\texttt{not (f x)}</imath>" while "<imath>\\texttt{f g x}</imath>" is
identical to "<imath>\\texttt{(f g) x}</imath>".

#### String and characters

String constants (type <imath>\\texttt{string}</imath>) are written between
double-quotes. Single-character constants (type <imath>\\texttt{char}</imath>)
are written between backquotes. The most used string operation is string
concatenation, denoted by the <imath>\\texttt{\\textasciicircum}</imath>
character.

#### Tuples

##### Constructing tuples

It is possible to combine values into tuples (pairs, triples, ...). The *value
constructor* for tuples is the "," character (the comma).

The infix "<imath>\\texttt{\*}</imath>" identifier is the *type constructor* for
tuples. For instance, <imath>t_1 \\texttt{\*} t_2</imath> corresponds to the
mathematical cartesian product of types <imath>t_1</imath> and
<imath>t_2</imath>.

We can build tuples from any values: the tuple value constructor is *generic*.
