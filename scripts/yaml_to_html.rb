#!/usr/bin/env ruby
# frozen_string_literal: true

require 'cgi'
require 'fileutils'
require 'optparse'
require 'pathname'
require 'psych'

def normalize_value(value)
  case value
  when nil
    nil
  when String
    stripped = value.strip
    stripped.empty? ? nil : stripped
  when Array
    normalized = value.map { |entry| normalize_value(entry) }.compact
    normalized.empty? ? nil : normalized
  when Hash
    normalized = value.each_with_object({}) do |(key, entry), result|
      normalized_entry = normalize_value(entry)
      result[key.to_s] = normalized_entry unless normalized_entry.nil?
    end
    normalized.empty? ? nil : normalized
  else
    value
  end
end

def load_yaml_record(path)
  record = Psych.safe_load(File.read(path), permitted_classes: [], aliases: false) || {}
  record.each_with_object({}) do |(key, value), result|
    result[key.to_s] = normalize_value(value)
  end
end

def html_escape(value)
  CGI.escapeHTML(value.to_s)
end

def format_value(value)
  case value
  when nil
    'N/A'
  when Array
    value.join(', ')
  when Hash
    if value.key?('min') || value.key?('max')
      min = value['min'] || '?'
      max = value['max'] || '?'
      "#{min} to #{max} bits"
    else
      value.map { |key, entry| "#{key}: #{entry}" }.join(', ')
    end
  else
    value.to_s
  end
end

def shared_styles
  <<~CSS
    :root {
      color-scheme: light;
      --bg: #ffffff;
      --ink: #111111;
      --muted: #444444;
      --line: #d8d8d8;
      --accent: #2b5dab;
      --table-stripe: #fafafa;
    }

    * { box-sizing: border-box; }

    body {
      margin: 0;
      font-family: Arial, Helvetica, sans-serif;
      color: var(--ink);
      background: var(--bg);
      line-height: 1.45;
    }

    a {
      color: var(--accent);
      text-decoration: underline;
    }

    .page {
      width: min(1100px, calc(100% - 2rem));
      margin: 0 auto;
      padding: 1.25rem 0 3rem;
    }

    .site-title {
      font-size: 2rem;
      font-weight: 700;
      margin: 0 0 1rem;
    }

    .breadcrumbs {
      margin: 0 0 1rem;
      color: var(--muted);
      font-size: 0.95rem;
    }

    h1 {
      margin: 0 0 1rem;
      font-size: 2rem;
      font-weight: 700;
    }

    h2 {
      margin: 1.5rem 0 0.5rem;
      font-size: 1.25rem;
    }

    p {
      margin: 0 0 1rem;
    }

    .mono {
      font-family: "Courier New", Courier, monospace;
    }

    table {
      width: 100%;
      border-collapse: collapse;
      margin-top: 1rem;
    }

    thead th {
      text-align: left;
      background: #f3f3f3;
      font-weight: 700;
    }

    th, td {
      padding: 0.55rem 0.75rem;
      border-bottom: 1px solid var(--line);
      vertical-align: top;
    }

    tbody tr:nth-child(even) {
      background: var(--table-stripe);
    }

    ul.reference-list {
      margin: 0.5rem 0 1rem;
      padding-left: 1.2rem;
    }

    @media (max-width: 720px) {
      .page {
        width: min(100% - 1rem, 100%);
      }

      th,
      td {
        padding: 0.5rem;
      }
    }
  CSS
end

def render_layout(title:, body:)
  <<~HTML
    <!DOCTYPE html>
    <html lang="en">
      <head>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>#{html_escape(title)}</title>
        <style>
    #{shared_styles}
        </style>
      </head>
      <body>
        <main class="page">
    #{body}
        </main>
      </body>
    </html>
  HTML
end

def render_index(records)
  rows = records.map do |record|
    algorithm_id = html_escape(record.fetch('id'))
    name = html_escape(record.fetch('name', 'N/A'))
    crypto_class = html_escape(record.fetch('cryptoClass', 'N/A'))

    <<~HTML
      <tr>
        <td><a href="algorithms/#{algorithm_id}.html">#{name}</a></td>
        <td><span class="mono">#{algorithm_id}</span></td>
        <td>#{crypto_class}</td>
      </tr>
    HTML
  end.join

  body = <<~HTML
    <h1 class="site-title"><a href="index.html">Software Package Data Exchange (SPDX)</a></h1>
    <h1>SPDX Cryptographic Algorithm List</h1>
    <p>This page follows the SPDX License List pattern: a simple index with linked identifiers and one detail page per entry.</p>
    <p>Note: You can sort this table in the SPDX License List website. This generated version keeps the same tabular structure, ordered by identifier.</p>
    <table>
      <thead>
        <tr>
          <th>Full name</th>
          <th>Identifier</th>
          <th>Crypto Class</th>
        </tr>
      </thead>
      <tbody>
    #{rows}
      </tbody>
    </table>
  HTML

  render_layout(title: 'SPDX Cryptographic Algorithm Catalog', body: body)
end

def render_references(references)
  return '<p>N/A</p>' if references.nil? || references.empty?

  items = references.map do |reference|
    escaped_reference = html_escape(reference)
    %(<li><a href="#{escaped_reference}">#{escaped_reference}</a></li>)
  end.join

  %(<ul class="reference-list">#{items}</ul>)
end

def render_algorithm_page(record)
  algorithm_id = html_escape(record.fetch('id'))
  name = html_escape(record.fetch('name', 'N/A'))
  crypto_class = html_escape(record.fetch('cryptoClass', 'N/A'))
  oid = html_escape(format_value(record['oid']))
  common_key_size = html_escape(format_value(record['commonkeySize']))
  specified_key_size = html_escape(format_value(record['specifiedkeySize']))
  references = record['reference']

  body = <<~HTML
    <h1 class="site-title"><a href="../index.html">Software Package Data Exchange (SPDX)</a></h1>
    <p class="breadcrumbs"><a href="../index.html">Home</a> &raquo; <a href="../index.html">Algorithms</a></p>
    <h1>#{name}</h1>

    <h2>Full name</h2>
    <p><span class="mono">#{name}</span></p>

    <h2>Short identifier</h2>
    <p><span class="mono">#{algorithm_id}</span></p>

    <h2>Crypto Class</h2>
    <p><span class="mono">#{crypto_class}</span></p>

    <h2>OID</h2>
    <p><span class="mono">#{oid}</span></p>

    <h2>Common key size</h2>
    <p><span class="mono">#{common_key_size}</span></p>

    <h2>Specified key size</h2>
    <p><span class="mono">#{specified_key_size}</span></p>

    <h2>Other web pages for this algorithm</h2>
    #{render_references(references)}
  HTML

  render_layout(title: "#{record.fetch('name', algorithm_id)} | SPDX Cryptographic Algorithm List", body: body)
end

def collect_records(input_dir)
  Dir.glob(input_dir.join('*.yaml').to_s).sort.map do |path|
    load_yaml_record(path).merge('sourcePath' => path)
  end
end

def write_output(records, output_dir)
  algorithms_dir = output_dir.join('algorithms')
  FileUtils.mkdir_p(algorithms_dir)

  File.write(output_dir.join('index.html'), render_index(records))

  records.each do |record|
    File.write(algorithms_dir.join("#{record.fetch('id')}.html"), render_algorithm_page(record))
  end
end

def validate_output(records, output_dir)
  errors = []
  index_path = output_dir.join('index.html')
  errors << "Missing index page: #{index_path}" unless index_path.file?

  if index_path.file?
    index_content = File.read(index_path)
    records.each do |record|
      errors << "Index missing row for #{record.fetch('id')}" unless index_content.include?(record.fetch('id'))
    end
  end

  records.each do |record|
    algorithm_path = output_dir.join('algorithms', "#{record.fetch('id')}.html")
    unless algorithm_path.file?
      errors << "Missing algorithm page: #{algorithm_path}"
      next
    end

    content = File.read(algorithm_path)
    expected_name = html_escape(record['name'].to_s)
    expected_crypto_class = html_escape(record['cryptoClass'].to_s)

    errors << "Algorithm page missing title text for #{record.fetch('id')}" unless expected_name.empty? || content.include?(expected_name)
    errors << "Algorithm page missing cryptoClass for #{record.fetch('id')}" unless expected_crypto_class.empty? || content.include?(expected_crypto_class)
  end

  errors
end

options = {
  input_dir: 'yaml',
  output_dir: 'html',
  validate: false
}

OptionParser.new do |parser|
  parser.banner = 'Usage: ruby scripts/yaml_to_html.rb [options]'

  parser.on('-i', '--input-dir PATH', 'Directory containing YAML files') do |value|
    options[:input_dir] = value
  end

  parser.on('-o', '--output-dir PATH', 'Directory where HTML files will be written') do |value|
    options[:output_dir] = value
  end

  parser.on('--validate', 'Validate the generated HTML output after building it') do
    options[:validate] = true
  end
end.parse!

input_dir = Pathname.new(options[:input_dir])
unless input_dir.directory?
  warn "Input directory not found: #{input_dir}"
  exit 1
end

records = collect_records(input_dir)
if records.empty?
  warn "No YAML files found in #{input_dir}"
  exit 1
end

output_dir = Pathname.new(options[:output_dir])
write_output(records, output_dir)
puts "Wrote #{records.length} algorithm pages plus index to #{output_dir}"

if options[:validate]
  validation_errors = validate_output(records, output_dir)
  if validation_errors.empty?
    puts "Validation passed for #{records.length} algorithms"
  else
    validation_errors.each { |error| warn error }
    exit 1
  end
end
