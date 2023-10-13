# frozen_string_literal: true

require 'spec_helper'
# 参照：https://docs.ruby-lang.org/en/3.0/syntax/pattern_matching_rdoc.html

RSpec.describe 'pattern matching' do
  describe 'array pattern: [<subpattern>, <subpattern>, <subpattern>, ...]' do
    context '<expression> in <pattern>' do
      it 'テスト1' do
        array = [1, "a", :hoge]

        # truthy
        expect((array in [*])).to be_truthy
        expect((array in [*, Symbol])).to be_truthy
        expect((array in [Integer, String, Symbol])).to be_truthy
        expect((array in [1, *, Symbol])).to be_truthy
        # falsy
        expect((array in [2, *, Symbol])).to be_falsy
        expect((array in ["a", 1, Symbol])).to be_falsy
        # array in array はエラー
      end

      it 'テスト2' do
        array = [{ name: "masashi", age: 35 }, { name: "gareth", age: 38 }]

        # falsy
        expect((array in [{ name: /m.*/, age: 30.. }])).to be_falsy
        # truthy
        expect(({ name: "masashi", age: 35 } in { name: /m.*/, age: 30.. })).to be_truthy
      end
    end
  end

  describe "find pattern: [*variable, <subpattern>, <subpattern>, <subpattern>, ..., *variable]" do
    it '<expression> => <pattern>' do
      [1, "a", :hoge] => [a, *b] # rest variables

      expect(a).to eq 1
      expect(b).to eq ["a", :hoge]
    end

    xit 'NoMatchingPatternError', :error do
      # 配列の場合、要素数が異なればNoMatchingPatternError
      # [1, "a", :hoge] => [2, b]・・・NoMatchingPatternError
    end
  end

  describe "hash pattern: {key: <subpattern>, key: <subpattern>, ...}" do
    context '<expression> in <pattern>' do
      it 'test1' do
        hash = { a: 1, b: "a", c: :hoge, d: { e: "e"} }

        # truthy
        expect((hash in { a: Integer, d: { e: }, **})).to be_truthy # rest variables
        expect((hash in { a: Integer, d: { e: } })).to be_truthy    # キーが足りなくてもOK
        expect((hash in { a: 1, b: "a", c: :hoge, d: { e: "e"}, **extra })).to be_truthy # 余分なrest variablesはOK

        # falsy
        expect((hash in { a: Integer, d: { e: }, f: })).to be_falsy # 存在しないキーがある時false
      end

      it '{} is the only exclusion from this rule. It matches only if an empty hash is given:' do
        hash = { a: 1, b: "a", c: :hoge, d: { e: "e" } }

        expect((hash in {})).to be_falsy
        expect(({} in {})).to be_truthy
      end
    end

    context '<expression> => <pattern>' do
      let!(:hash){ { a: 1, b: "B", c: :hoge, d: { e: "E" } } }

      it 'rest variables' do
        hash => { a:, d: { e: }, **rest }

        expect(a).to eq 1
        expect(e).to eq "E"
        expect(rest).to eq ({ b: "B", c: :hoge })
        expect(defined?(b)).to be_falsy
      end

      it 'no rest variables' do
        hash => { a:, d: { e: }}

        expect(a).to eq 1
        expect(e).to eq "E"
      end

      xit 'errors', :error do
        # hash => { a:, _A: }・・・NoMatchingPatternKeyError：key not found: :_A
        # hash => { a:, A: }・・・SyntaxError：key must be valid as local variables
      end
    end

    context 'case statement' do
      describe 'binding of the matched parts to local variables' do
        let!(:hash){ { a: 1, b: "B", c: :hoge, d: { e: "E" } } }
        
        it 'test1' do
          case hash
          in a:
          else a = 2
          end

          expect(a).to eq 1
        end

        it 'test2' do
          case hash
          in a: Integer
          else a = 2
          end

          expect(a).to be_nil
        end
      end
    end
  end

  describe "combination of patterns with |; (Alternative pattern)" do
    context '<expression> in <pattern>' do
      let!(:array){ [1, "a", :hoge] }
      it 'テスト1' do
        res = array in [2, "b", :fuga] | [1, "a", :hoge]

        expect(res).to be_truthy
      end

      it 'テスト2' do
        res = array in String | Array

        expect(res).to be_truthy
      end

      it 'strange behavior！！！！', :strange do
        res = array in String | Hash
        expect(res).to eq array
      end
    end

    describe 'Binding to variables currently does NOT work for alternative patterns joined with |:' do
      context '<expression> => <pattern>' do
        xit 'テスト1' do
          array = [1, "a", :hoge]
          # array => [*a, :fuga] | [1, *b] はエラー
        end

        describe 'Variables that start with _ are the only exclusions from this rule:' do
          it '配列' do
            array = [1, "a", :hoge]
            array => [_a, Integer, :fuga] | [1, *_b]

            expect(_a).to eq 1 # 注意！！！！！
            expect(_b).to eq ["a", :hoge]

            array => [_p, _q, _r, _s] | Array
            expect(_p).to be_nil # 注意！！！！

            # It is, though, not advised to reuse the bound value, as this pattern's goal is to signify a discarded value.
          end

          # Todo
          xit 'ハッシュ' do
            hash = { a: 1, b: "B", c: :hoge, d: { e: "E" } }
          end
        end


      end
    end
  end

  # Todo
  xdescribe 'variable pinning' do
    it 'テスト' do; end
  end
end