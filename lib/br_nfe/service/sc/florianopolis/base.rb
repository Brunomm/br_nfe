module BrNfe
	module Service
		module SC
			module Florianopolis
				class Base < BrNfe::Service::Base
					attr_accessor :aedf

					validates :aedf, length: {maximum: 7}, presence: true
					validates :aedf, numericality: {
						only_integer: true, 
						greater_than_or_equal_to: 100000, 
						less_than_or_equal_to: 9999999
					},  allow_blank: true
					
					def request
					end

					def content_xml
						'<?xml version="1.0" encoding="UTF-8" standalone="yes"?>'+xml_builder
					end
				end
			end
		end
	end
end