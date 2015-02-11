# katex-pandoc-filter

Check out this repo, install deps via `npm i` (TODO: publish this fork to npm)

Example usage:

```bash
echo '$\int_1^\infty x^{-2}dx$ converges but not this: $$\int_1^\infty x^{-1}dx$$' | pandoc --filter ./filter-shim.js --include-in-header ./head.html 
```

TODO: put display math on its own centered line

TODO: style katex errors better?  Or only complain to stderr and leave math node as-is?  That would allow using this filter with another fallback like `--mathjax` or `--filter` [mathjax-pandoc-filter][1] producing svg?

[1]: https://github.com/lierdakil/mathjax-pandoc-filter
