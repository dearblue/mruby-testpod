# mruby-test-nomem

`malloc()` 可能な回数を制限して mruby の初期化と終了を行うだけのコマンドラインプログラムです。

テスト目的です。


## くみこみかた

`build_config.rb` に gem として追加し、mruby をビルドして下さい。

```ruby
MRuby::Build.new do |conf|
  conf.gem "mruby-test-nomem", github: "dearblue/mruby-test-nomem"
end
```


## つかいかた

  - mruby-2.0 と組み合わせた場合:

      - ```
        $ ./host/bin/mrbnomem
        usage: ./host/bin/mrbnomem <malloc lifetime>
        ./host/bin/mrbnomem: malloc lifetime to set 100 (by default).
        zsh: segmentation fault  ./host/bin/mrbnomem
        ```

      - ```
        $ ./host/bin/mrbnomem 1000
        ./host/bin/mrbnomem: malloc lifetime to set 1000.
        Out of memory
        zsh: abort      ./host/bin/mrbnomem 1000
        ```

      - ```
        $ ./host/bin/mrbnomem 3000
        ./host/bin/mrbnomem: malloc lifetime to set 3000.
        ./host/bin/mrbnomem: program is terminated normaly.
        ```

  - mruby にパッチをあてた場合:

    ```
    $ ./host/bin/mrbnomem 100
    ./host/bin/mrbnomem: malloc lifetime to set 100.
    ./host/bin/mrbnomem: not allocated mruby context.
    ./host/bin/mrbnomem: program is terminated normaly.
    ```

  - とりあえず valgrid を使ってぶん回す

    ```
    $ mkdir .logs; for i in `seq 0 2800`; do echo -n $i.; valgrind --leak-check=full ./host/bin/mrbnomem $i 2>&1 | cat > .logs/$i.log; done; echo
    ```


## Specification

  * Package name: mruby-test-nomem
  * Author: [dearblue](https://github.com/dearblue)
  * Project page: <https://github.com/dearblue/mruby-test-nomem>
  * Licensing: [Creative Commons Zero License](LICENSE)
