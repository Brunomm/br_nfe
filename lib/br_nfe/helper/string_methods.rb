# -*- encoding: utf-8 -*-
module BrNfe
	module StringMethods

		def br_nfe_escape_html
			CGI::escapeHTML(self)
		end
		 
		def to_valid_format_nf
			remove_accents.upcase
		end

		def remove_accents
			ActiveSupport::Inflector.transliterate(self)
		end

		def max_size(size=255)
			self.truncate(size, omission: '')
		end
	end
end

[String].each do |klass|
	klass.class_eval { include BrNfe::StringMethods }
end
