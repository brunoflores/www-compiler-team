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
today's implementation. I follow the **Part II** in the user's manual: "The Caml
Light language reference manual", which can still be downloaded from
[here](https://caml.inria.fr/caml-light/release.en.html).

### What can Caml Light do for us?

Examples in this section are drawn from the text "Functional programming using
Caml Light", by Michel Mauny. It can be downloaded from
[here](https://caml.inria.fr/pub/docs/fpcl/index.html).

<pre class="display-math">
\begin{align*}
successor &: N \mapsto N \\
          &: n \mapsto n+1
\end{align*}
</pre>
