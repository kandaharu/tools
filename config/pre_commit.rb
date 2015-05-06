#! /usr/bin/env ruby
# coding: utf-8

# コンソール上に表示する文字に色を付ける
require 'colorize'

# colorize の gem が入ってないときにとりあえず動くようにする。
unless String.instance_methods.include?(:colorize)
  class String
    def colorize(*_args)
      self
    end
  end
end

# == コミット対象に config フォルダ下のファイルが含まれているチェック
# 含まれていたら警告するメッセージを出力
# === 戻り値
# +true+:: コミットOK
# +false+:: コミットNG
def warn_including_config_file(files)
  config_files = files.select { |file| file.match %r{config/} }

  return true if config_files.empty?

  warn_message = <<-"EOS"
  [WARN] コミット対象のファイルに config フォルダ下のファイルが含まれています。
    #{config_files.join(', ')}
  EOS

  puts warn_message.colorize(:yellow)
  false
end

# == コミット可能かチェック
# === 戻り値
# +true+:: コミットOK
# +false+:: コミットNG
def commit?
  cached_files = `git diff --cached --name-only HEAD`
  files = [cached_files].flatten.each { |file| file.strip! }

  warn_including_config_file(files)
end

exit commit? ? 0 : 1
