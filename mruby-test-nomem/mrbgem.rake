#!ruby

MRuby::Gem::Specification.new("mruby-test-nomem") do |s|
  version = File.read(File.join(File.dirname(__FILE__), "README.md")).scan(/^ *[-*] version: *(\d+(?:.\w+)+)/i).flatten[-1]
  s.version = version if version
  s.summary = "test no memory"
  s.license = "CC0"
  s.author  = "dearblue"
  s.homepage = "https://github.com/dearblue/mruby-test-nomem"
  s.bins = %w(mrbnomem)

  if cc.command =~ /\b(?:g?cc|clang)d*\b/
    cc.flags << %w(-Wno-declaration-after-statement)
  end
end
