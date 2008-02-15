class Object
  def blank?
    nil? || (respond_to?(:empty?) && empty?)
  end
end

class Fixnum
  def blank?
    false
  end
end

class NilClass
  def blank?
    true
  end
end

class TrueClass
  def blank?
    false
  end
end

class FalseClass
  def blank?
    false
  end
end

class String
  def blank?
    empty? || self =~ /^\s*$/
  end
end