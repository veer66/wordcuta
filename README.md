# Moved to https://codeberg.org/mekong-lang/wordcuta

# WordcutA

## Install

* Install [wordcutw](https://github.com/veer66/wordcutw)
* gem install wordcuta

## Example

```Ruby
require 'wordcuta'
wc = WordcutA::Wordcut.new(WordcutA::DEFAULT_THAI_DICT_PATH)
p wc.put_delimiters('กากาก้า', '|')
p wc.into_strings('กากา')
p wc.into_ranges('กากา')
```
