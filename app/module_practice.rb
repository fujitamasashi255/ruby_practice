module ModulePractice
  class ParentClass
    def i_method
      "親クラスのインスタンスメソッド"
    end

    def self.c_method
      "親クラスのクラスメソッド"
    end
  end

  class ChildClass < ParentClass
    def i_method
      "子クラスのインスタンスメソッド"
    end

    def self.c_method
      "子クラスのクラスメソッド"
    end
  end
end

