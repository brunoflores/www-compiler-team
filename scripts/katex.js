var katex = require("katex");
var fs = require("fs");
var input = fs.readFileSync(0);
var displayMode = process.env.DISPLAY != undefined;

var html = katex.renderToString(String.raw`${input}`, {
  throwOnError : true,
  output: "html",
  displayMode  : false // Inline mode
});

console.log(html)
