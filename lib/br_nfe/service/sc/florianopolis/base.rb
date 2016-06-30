module BrNfe
	module Service
		module SC
			module Florianopolis
				class Base < BrNfe::Service::Base
					attr_accessor :aedf

					validates :aedf, presence: true
					
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