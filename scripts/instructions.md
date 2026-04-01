## Generate HTML

Generate an HTML catalog plus one HTML file per algorithm:

```bash
ruby scripts/yaml_to_html.rb
```

This writes `html/index.html` and `html/algorithms/<id>.html`.

Generate and validate the HTML output:

```bash
ruby scripts/yaml_to_html.rb --validate