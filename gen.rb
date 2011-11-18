require 'rubygems'
require 'forgery'
require 'ruby-debug'

LONGEST_METHOD = 41

klasses = Forgery.constants.map do |sym|
  ("Forgery::" + sym.to_s).constantize
end.
reject do |klass|
  !klass.is_a?(Class) || !klass.ancestors.include?(Forgery)
end

klasses.each do |klass|
  puts klass.name + ":-\n\n"
  
  k_methods = klass.public_methods - Forgery.methods
  
  k_methods.each do |m|
    meth = klass.method(m)
    
    examples = (1..3).map { meth.call.inspect rescue "???" }.uniq.join('|||') + '~~~'
    examples = examples[0...90].sub(/\|\|\|[^|~]*$/, '').gsub(/\|\|\|/, ', ').sub(/~~~/, '')
    examples += (examples.length >= 90 ? '...'  : '')
    
    puts "#{klass.name}.#{m.to_s}".ljust(LONGEST_METHOD + 2) + " # => #{examples}"
    
    if meth.arity != 0
      puts "#{klass.name}.#{m.to_s}(\n  \n" + ")".ljust(LONGEST_METHOD + 2) + " # => #{examples}"
    end
  end
  
  puts "\n\n"
end
