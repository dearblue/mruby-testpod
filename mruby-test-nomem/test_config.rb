#!ruby

require "yaml"

config = YAML.load <<'YAML'
  common:
    gems:
    - :core: "mruby-sprintf"
    - :core: "mruby-print"
    - :core: "mruby-io"
  builds:
    host:
      build_dir: build/mruby-test-mrbnomem
      defines: MRB_INT64
      gems:
      - :core: "mruby-io"
YAML

config["builds"].each_pair do |n, c|
  MRuby::Build.new(n) do |conf|
    toolchain :clang

    conf.build_dir = c["build_dir"] || name

    enable_debug
    enable_test
    enable_cxx_abi if c["c++abi"]
    enable_cxx_exception if c["c++error"]

    cc.defines << [*c["defines"]]
    cc.flags << [*c["cflags"]]

    Array(config.dig("common", "gems")).each { |*g| gem *g }
    Array(c["gems"]).each { |*g| gem *g }

    gem File.dirname(__FILE__) do |g|
      if g.cc.command =~ /\b(?:g?ccc|clang)\d*\b/
        g.cc.flags << "-std=c11" unless c["c++abi"]
        g.cc.flags << "-pedantic"
        g.cc.flags << "-Wall"
      end
    end
  end
end
