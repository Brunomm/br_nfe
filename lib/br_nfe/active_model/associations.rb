require 'br_nfe/active_model/has_many.rb'
require 'br_nfe/active_model/belongs_to.rb'
module BrNfe
	module ActiveModel
		module Associations
			extend ActiveSupport::Concern
			include HasMany
			include BelongsTo
		end
	end
end