# -*- encoding: utf-8 -*-
module BrNfe
	module StringMethods
		 
		def to_valid_format
			ActiveSupport::Inflector.transliterate(self).upcase
		end
	end
end

[String].each do |klass|
	klass.class_eval { include BrNfe::StringMethods }
end
