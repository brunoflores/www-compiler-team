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

<pre class="language ocaml">
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

<pre class="language ocaml type">
function f -> (function x -> (f (x+1) - 1))
</pre>

The function above has type <imath>\\texttt{(int -> int) -> (int -> int)}</imath>.

### Definitions

The following function application,

<pre class="language ocaml">
(function y -> y+1) (1+2)
</pre>

Can also be written as,

<pre class="language ocaml">
let y = 1+2 in y+1
</pre>

The <imath>\\texttt{let}</imath> construct introduces *local bindings of values
to identifiers*.

Local bindings using <imath>\\texttt{let}</imath> also introduct *sharing* of
(possibly time-consuming) evaluations. When evaluating <imath>\\texttt{let x =
}e_1\\texttt{ in }e_2</imath>, <imath>e_1</imath> gets evaluated only once.

The <imath>\\texttt{let}</imath> construct also have a global form for toplevel
declarations, as in:

<pre class="language ocaml type">
let successor = function x -> x+1
</pre>

Or even,

<pre class="language ocaml type">
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

<pre class="language ocaml">
let newton f epsilon =
  let rec until p change x =
            if p x then x
            else until p change (change x) in
  let satisfied y = abs (f y) <. epsilon in
  let improve y = y -. ((f y) /. (deriv f y epsilon)) in
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

#### Patterns and pattern-matching

Patterns and pattern-matching are strongly related to types. A *pattern*
indicates the *shape* of a value.

> Patterns are "values with holes".

A single variable (formal parameter) is a pattern (with no shape specified: it
matches any value). When a value is *matched against* a pattern, the patten acts
as a filter. The function body <imath>\\texttt{(function x -> ...)}</imath> does
(trivial) pattern matching.

Pattern-matching will raise a compiler warning if not exhaustive. A run-time
exception will be reported if matching does not succeed.

Cases are examined in turn, from top to bottom,

<pre class="language ocaml">
let negate = function true -> false
                    | false -> true
</pre>

An equivalent definition would be,

<pre class="language ocaml">
let negate = function true -> false
                    | x -> true
</pre>

Also equivalent,

<pre class="language ocaml">
let negate = function true -> false
                    | _ -> true
</pre>

As an example of pattern-matching, consider the truth value table of
implication. These are all equivalent definitions:

<pre class="language ocaml">
let imply = function (true, true) -> true
                   | (true, false) -> false
                   | (false, true) -> true
                   | (false, false) -> true
</pre>

<pre class="language ocaml">
let imply = function (true, x) -> x
                   | (false, _) -> true
</pre>

<pre class="language ocaml">
let imply = function (true, false) -> false
                   | _ -> true
</pre>

Of course, pattern-matching on constants is not limited to booleans,

<pre class="language ocaml">
let is_yes = function "oui" -> true
                    | "si" -> true
                    | "ya" -> true
                    | "yes" -> true
                    | _ -> false
</pre>

#### Functions

The type constructor <imath>\\texttt{->}</imath> is predefied and cannot be
defined in ML's type system.

##### Functional composition

<pre class="language ocaml type">
let compose f g = function x -> f (g x)
</pre>

The type of <imath>\\texttt{compose}</imath> contains no more constraints than
the ones appearning in the definition: it is the *most general* type compatible
with these constraints,

<pre class="display-math">
\ttfamily
compose : ('a -> 'b) -> ('c -> 'a) -> 'c -> 'b
</pre>

These constraints are:

* the codomain of <imath>\\texttt{g}</imath> and the domain of
  <imath>\\texttt{f}</imath> must be the same;
* <imath>\\texttt{x}</imath> must belong to the domain of
  <imath>\\texttt{g}</imath>;
* <imath>\\texttt{compose f g x}</imath> will belong to the codomain of <imath>\\texttt{f}</imath>.

##### Currying

The currying transformation may be written in Caml under the form of a
higher-order function,

<pre class="language ocaml type">
let curry f = function x -> (function y -> (f (x, y)))
</pre>

And its inverse,

<pre class="language ocaml type">
let uncurry f = function (x, y) -> f x y
</pre>

### Lists

Lists in ML are *homogeneous*: a list cannot contain elements of different
types. ML provides a facility for introducing new types allowing the user to
define precisely the data structures needed by the program.

Lists are built with two *value constructors*:

* <imath>\\texttt{[]}</imath>, the empty list
* <imath>\\texttt{::}</imath>, the non-empty list constructor. It takes an
  element <imath>e</imath> and a list <imath>l</imath>, and builds a new list
  whose first element (head) is <imath>e</imath> and rest (tail) is
  <imath>l</imath>.

The special syntax <imath>\\texttt{[\$e_1\$; \$\\dots\$; \$e_n\$]}</imath>
is equivalent to <imath>e_1 :: (e_2 :: \\dots (e_n :: \\texttt{[]})
\\dots)</imath>.

An empty list is a "list of anything",

<pre class="language ocaml type">
[]
</pre>

The <imath>\\texttt{list}</imath> type is a *recursive* type. The
<imath>\\texttt{[]}</imath> constructor receives two arguments; the second
argument is itself a <imath>\\texttt{list}</imath>,

<pre class="language ocaml type">
function head -> function tail -> head :: tail
</pre>

The types <imath>\\texttt{list}</imath> and <imath>\\texttt{bool}</imath> are
*sum types*. They are defined with several alternatives,

* a list is either <imath>\\texttt{[]}</imath> or <imath>\\texttt{::}</imath> of
  ...
* a boolean value is either <imath>\\texttt{true}</imath> or
  <imath>\\texttt{false}</imath>

Sum types are the only types whose values need run-time tests in order to be
matched by a non-variable pattern.

The cartesian product is a *product* type (only one alternative). Product types
do not involve run-time tests during pattern-matching. The type of their values
suffices to indice statically whet their structure is.

#### Functions over lists

The <imath>\\texttt{map}</imath> function demonstrates function as argument,
list processing, and polymorphism,

<pre class="language ocaml type">
let rec map f =
  function [] -> []
         | head :: tail -> (f head) :: (map f tail)
</pre>

The following example is a list iterator. It takes a function <imath>f</imath>,
a base elent <imath>a</imath> and a list <imath>\\texttt{[\$x_1\$; \\dots;
\$x_n\$]}</imath>. It computes,

<imath>\\texttt{it\\_list}\  f\  a\  [x_1; \\dots; x_n] = f\  (\\dots
(f\  (f\  a\  x_1)\  x_2)\\dots)\  x_n</imath>

<pre class="language ocaml type">
let rec it_list f a =
  function [] -> a
         | head :: tail -> it_list f (f a head) tail
</pre>

### User-defined types
