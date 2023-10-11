require 'spec_helper'

RSpec.describe ModulePractice do
  let!(:parent_class){ ModulePractice::ParentClass }
  let!(:child_class){ ModulePractice::ParentClass }

  describe 'object' do
    let!(:obj){ child_class.new }

    describe '特異メソッド' do
      # obj.singleton_class
      it '「特異クラス < 元のクラス」であること' do
        expect(obj.singleton_class.superclass).to eq obj.class
      end

      it '他のオブジェクトは特異メソッドを呼び出せないこと' do
        obj.define_singleton_method(:added_method){ "特異メソッド" }
        another_obj = child_class.new
        expect(another_obj.respond_to?(:added_method)).to be_falsy
      end

      # obj.define_singleton_method(:method){ ・・・ }
      it 'クラスに定義したインスタンスメソッドより特異メソッドが優先的に呼ばれること' do
        obj.define_singleton_method(:i_method){ "特異メソッド" }
        expect(obj.i_method).to eq "特異メソッド"
      end

      # module.instance_methods(false)
      it 'オブジェクトの特異メソッドが特異クラスに定義されたインスタンスメソッドであること' do
        obj.define_singleton_method(:i_method){ "特異メソッド" }
        s_methods = obj.singleton_class.instance_methods(false)
        expect(s_methods).to eq [:i_method]
      end
    end

    describe 'extend' do
      it 'クラスメソッド' do; end
    end
  end

  describe 'class' do
    describe 'include' do; end
    describe 'prepend' do; end
    describe 'monkey_patch' do; end
    describe 'refinements' do; end
  end

  describe 'module' do; end
end