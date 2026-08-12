#!/usr/bin/env ruby
# Measures the style gradient described in docs/WRITING-GUIDE.md §1b.
#
#   ruby docs/style-gradient.rb            # every post and draft, by date
#   ruby docs/style-gradient.rb --check    # exit 1 if anything is out of band
#
# The point is not to hit the numbers exactly. It is to catch a post whose
# register belongs to a different year than its date.

require 'yaml'
require 'date'

# era => [sentence_min, sentence_max, emdash_per_1k_max]
BANDS = [
  [2021, 13.0, 18.0, 1.0],
  [2023, 15.0, 20.0, 2.0],
  [2025, 16.0, 21.0, 4.0],
  [9999, 17.0, 23.0, 5.0]
].freeze

# Rounding tolerance, so a post sitting exactly on a boundary isn't flagged.
TOL = 0.25

def band_for(year)
  BANDS.find { |cutoff, *| year <= cutoff }
end

def measure(path)
  raw = File.read(path)
  fm  = YAML.load(raw[/\A---\s*\n(.*?\n)---/m, 1], permitted_classes: [Time, Date])
  return nil unless fm && fm['date']

  body = raw.split(/^---\s*$/, 3)[2].to_s.gsub(/```.*?```/m, '')
  # Prose only: drop list items, headings, tables, blockquotes and TODO markers,
  # all of which have their own rhythm and would skew the average.
  prose = body.lines
              .reject { |l| l =~ /^\s*([-*>|#]|\d+\.)/ || l =~ /^TODO:/ || l.strip.empty? }
              .join(' ')
  sentences = prose.split(/(?<=[.!?])\s+/).map { |s| s.split.size }.reject { |n| n < 4 }
  return nil if sentences.empty?

  words = body.split.size
  {
    date:   fm['date'],
    name:   File.basename(path, '.md'),
    avg:    sentences.sum.to_f / sentences.size,
    count:  sentences.size,
    emdash: body.scan(/—/).size * 1000.0 / words
  }
end

rows = (Dir['_posts/*.md'] + Dir['_drafts/*.md']).filter_map { |f| measure(f) }
                                                 .sort_by { |r| r[:date] }
abort 'No posts or drafts found.' if rows.empty?

check   = ARGV.include?('--check')
failed  = 0

puts '  date      avg   sents  em/1k   band            file'
rows.each do |r|
  _, lo, hi, dash_max = band_for(r[:date].year)
  problems = []
  problems << 'sentences' if r[:avg] < lo - TOL || r[:avg] > hi + TOL
  problems << 'em-dashes' if r[:emdash] > dash_max + TOL
  failed += 1 unless problems.empty?

  puts format('  %s %5.1f %6d %6.1f   %4.1f-%4.1f/%3.1f    %-42s %s',
              r[:date].strftime('%Y-%m'), r[:avg], r[:count], r[:emdash],
              lo, hi, dash_max, r[:name][0, 42],
              problems.empty? ? '' : "<-- #{problems.join(', ')}")
end

puts
puts '  BY YEAR'
rows.group_by { |r| r[:date].year }.sort.each do |year, rs|
  puts format('  %d  n=%-2d  avg-sentence %4.1f   em-dash/1k %3.1f',
              year, rs.size, rs.sum { |r| r[:avg] } / rs.size,
              rs.sum { |r| r[:emdash] } / rs.size)
end

puts
puts '  Trend should rise, gently, on both columns. Dips are fine; a reversal'
puts '  across several years means a post is written in the wrong decade.'

if check && failed.positive?
  puts
  puts "  #{failed} post(s) outside their era band."
  exit 1
end
