# coding: utf-8
require "ffi"

module WordcutFFI
  class TextRange < FFI::Struct
    layout :s, :size_t,
           :e, :size_t
  end

  extend FFI::Library

  ffi_lib "wordcutw"
  
  attach_function :wordcut_new_with_dict, [:string], :pointer
  attach_function :wordcut_into_text_ranges, [:pointer, :string, :pointer], :pointer
  attach_function :wordcut_into_strings, [:pointer, :string, :pointer], :pointer
  attach_function :wordcut_put_delimiters, [:pointer, :string, :string], :string
  attach_function :delete_wordcut, [:pointer], :void
  attach_function :delete_strings, [:pointer, :size_t], :void
end

module WordcutA
  TextRange = Struct.new(:s, :e)

  DEFAULT_THAI_DICT_PATH = File.expand_path('../../data/thai-dix.txt', __FILE__)
  
  class Wordcut
    def initialize(dict_path)
      @wordcut_p = FFI::AutoPointer.new(WordcutFFI.wordcut_new_with_dict(dict_path),
                                        WordcutFFI.method(:delete_wordcut))
    end

    def into_ranges(text)
      ranges = []
      FFI::MemoryPointer.new(:size_t, 1) do |range_cnt|
        ranges_p = WordcutFFI.wordcut_into_text_ranges(@wordcut_p, text, range_cnt)
        ranges = range_cnt.get_uint(0)
                   .times
                   .map {WordcutFFI::TextRange.new(ranges_p + _1 * WordcutFFI::TextRange.size)}
                   .map {TextRange.new(_1[:s], _1[:e])}
      end
      return ranges
    end

    def into_strings(text)
      words = []
      FFI::MemoryPointer.new(:size_t, 1) do |words_cnt_p|
        words_p = WordcutFFI::wordcut_into_strings(@wordcut_p, text, words_cnt_p)
        words_cnt = words_cnt_p.get_uint(0)
        words = words_p.get_array_of_string(0, words_cnt)
        WordcutFFI::delete_strings(words_p, words_cnt)
      end
      return words.map {_1.force_encoding("UTF-8")}
    end

    def put_delimiters(text, delim)
      WordcutFFI::wordcut_put_delimiters(@wordcut_p, text, delim).force_encoding("UTF-8")
    end
  end
end

# wordcut = WordcutA::Wordcut.new("thai.txt")
# p wordcut.into_ranges("กากาม")
# p wordcut.into_strings("กากาขาม")
# p wordcut.put_delimiters("กากาขามมาก", "---")
