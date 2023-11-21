<post-metadata>
  <post-title>Abstract syntax</post-title>
  <post-date>On Oct 24, 2023</post-date>
  <post-tags>pl-theory</post-tags>
</post-metadata>
<div id="post-excerpt">
An abstract syntax tree, or ast for short, is an ordered tree whose leaves are
variables, and whose interior nodes are operators whose arguments are its
children [Harper; 2016].
</div>

Here are two programs that can parse to the same AST:

<pre class="language-rust">
fn main() {
    let e1 = 3 * 4;
    let e2 = 2 + e1;
    println!("{}", e2);
}
</pre>

<pre class="language-ocaml">
let _ =
  let e1 = 3 * 4 in
  let e2 = 2 + e1 in
  print_endline e2
</pre>

<pre class="graphviz">
digraph {
  fontname="Helvetica,Arial,sans-serif"
  node [fontname="Helvetica,Arial,sans-serif"]
  edge [fontname="Helvetica,Arial,sans-serif"]

  label="2 + (3 * 4)"

  plus [label="+"] ;
  times [label="*"] ;
  num_2 [label="2"] ;
  num_3 [label="3"] ;
  num_4 [label="4"] ;

  plus ;
  plus -> num_2 ;
  plus -> times ;

  times -> num_3 ;
  times -> num_4 ;
}
</pre>

## Structural induction

TODO

Variables are given meaning by *substitution*:

<pre class="display-math">
\documentclass[preview=true,12pt]{standalone}
\usepackage{newtx}
\begin{document}

\begin{enumerate}
\item $\left[ \it{b} / \it{x}\right] \it{x} = \it{b}$ and $\left[ \it{b} /
\it{x}\right] \it{y} = \it{y}$ if $\it{x} \neq \it{y}$

\item $\left[ \it{b} / \it{x}\right] \it{o}(a_1; \dots a_n) = o(\left[ b /
x\right] a_1; \dots \left[ b / x\right] a_n) $
\end{enumerate}

\end{document}
</pre>
