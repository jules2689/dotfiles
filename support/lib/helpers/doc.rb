module MethodAddedHook
  private

  def method_added(meth)
    method_added_hook(meth)
    super
  end

  def singleton_method_added(meth)
    method_added_hook(meth)
    super
  end

  def method_added_hook(meth)
    @@__last_defined_doc__ ||= nil
    return if !defined?(@@__last_defined_doc__) || @@__last_defined_doc__.nil?
    @@__class_docs__ ||= {}
    @@__class_docs__[self.to_s] ||= {}

    @@__class_docs__[self.to_s][meth] = @@__last_defined_doc__
    @@__last_defined_doc__ = nil
  end
end

class Module
  private
  prepend MethodAddedHook

  def doc(str, meth = nil)
    return @@__class_docs__[self.to_s][meth] = str if meth
    @@__last_defined_doc__ = str
  end

  def defdoc(str, meth, &block)
    @@__class_docs__[self.to_s][meth] = str
    define_method(meth, &block)
  end
end

module Kernel
  def get_doc(klass, meth)
    docs = klass.class_variable_get(:@@__class_docs__)
    docs[self.to_s][meth.to_sym] if docs && docs[self.to_s]
  end
end


class String
  # The following methods is taken from activesupport
  #
  # https://github.com/rails/rails/blob/d66e7835bea9505f7003e5038aa19b6ea95ceea1/activesupport/lib/active_support/core_ext/string/strip.rb
  #
  # All credit for this method goes to the original authors.
  # The code is used under the MIT license.
  #
  # Strips indentation by removing the amount of leading whitespace in the least indented
  # non-empty line in the whole string
  #
  def strip_heredoc
    self.gsub(/^#{self.scan(/^[ \t]*(?=\S)/).min}/, "".freeze)
  end
end
