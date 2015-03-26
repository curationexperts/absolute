require_relative "absolute_mimetypes.rb"

module Absolute
	class GenericFile < Worthwhile::GenericFile		
		include Absolute::MimeTypes
	end
end
