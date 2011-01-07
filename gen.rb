require 'rubygems'
require 'forgery'
require 'ruby-debug'

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
    
    puts "#{klass.name}.#{m.to_s}".ljust(50) + " # => #{examples}"
    
    if meth.arity != 0
      puts "#{klass.name}.#{m.to_s}(\n  \n" + ")".ljust(50) + " # => #{examples}"
    end
  end
  
  puts "\n\n"
end
