# Otterraft

Simple [YAML Frontmatter](https://pandoc.org/MANUAL.html#extension-yaml_metadata_block) parser for Ruby.

## Installation

Otterraft's installation is simple:

```console
gem install otterraft
```

If you'd rather install Otterraft using `bundler`, add a line for it in your Gemfile:

```ruby
gem 'otterraft'
```

## Usage

Otterraft is a simple YAML Frontmatter parser for Ruby. It can be used to parse YAML Frontmatter from a string.

```ruby
text = <<~MARKDOWN_TEXT
---
title: Hello, World!
date: 2021-01-01 12:00 JST
tags:
- hello
- world
- ruby
---

# Hello, World!
Lorem ipsum dolor sit amet, consectetur adipiscing elit.
- First item
- Second item
MARKDOWN_TEXT

Otterraft.parse(text)
# => { "title" => "Hello, World!", "date" => "2021-01-01 12:00 JST", "tags" => ["hello", "world", "ruby"] }
```

Otterraft can also be used to parse YAML Frontmatter from a file.
If you have a file named `hello.md` with the following content:

```markdown
---
title: How to use parse from file
date: 2024-12-31 23:59 JST
tags:
- how-to
- parse
---

# Hello, World!
Lorem ipsum dolor sit amet, consectetur adipiscing elit.
```

You can parse the file like this:

```ruby
Otterraft.parse_file('hello.md')
# => { "title" => "How to use parse from file", "date" => "2024-12-31 23:59 JST", "tags" => ["how-to", "parse"] }
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ydah/otterraft. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](./CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](./LICENSE.txt).

## Code of Conduct

Everyone interacting in the Otterraft project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](./CODE_OF_CONDUCT.md).
