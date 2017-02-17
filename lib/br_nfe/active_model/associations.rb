require 'br_nfe/active_model/has_many.rb'
require 'br_nfe/active_model/has_one.rb'
module BrNfe
	module ActiveModel
		module Associations
			extend ActiveSupport::Concern
			include HasMany
			include HasOne
		end
	end
end