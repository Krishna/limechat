# Created by Satoshi Nakagawa.
# You can redistribute it and/or modify it under the Ruby's license or the GPL2.

module PersistenceHelper
  module PersistenceHelperClassMethods
    attr_reader :persistent_attrs
    def persistent_attr(*args)
      @persistent_attrs ||= []
      @persistent_attrs += args
      attr_accessor(*args)
    end
  end
  
  def self.included(receiver)
    receiver.extend(PersistenceHelperClassMethods)
  end

  
  def assign(v)
    set_persistent_attrs(v.get_persistent_attrs)
  end
  
  def dup
    n = self.class.new
    n.set_persistent_attrs(get_persistent_attrs)
    n
  end

  def set_persistent_attrs(hash)
    return unless hash
    return if hash.empty?
    return unless persistent_attrs
    persistent_attrs.each do |i|
      value = hash[i]
      method = i.to_s + '='
      self.__send__(method, value) if value != nil
    end
  end

  def get_persistent_attrs
    return {} unless persistent_attrs
    r = {}
    persistent_attrs.each {|i| r[i] = self.__send__(i)}
    r
  end
  
  
  private

  def persistent_attrs
    self.class.persistent_attrs
  end
end
