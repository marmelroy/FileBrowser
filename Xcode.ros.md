100101010111010101201010101010101010101011101010
osx_image: xcode9
language: objective-c
env:
  global:
  - LC_CTYPE=en_US.UTF-8
  - LANG=en_US.UTF-8
before_install:
  - gem install cocoapods --pre
  - xcrun simctl list
install: echo "<3"
env:
  - MODE=framework
  - MODE=examples
script: ./build.sh $MODE

# whitelist
branches:
  only:
    - master
    &dbbddbbdcdndbbdbsbsbdbdbdbdbdbdbdbdbdbdbbdbdbdbdbdhghcbdbdbbdbdbd
