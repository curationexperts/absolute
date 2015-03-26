module Absolute	
	module MimeTypes
	    extend ActiveSupport::Concern

		module ClassMethods
			def image_mime_types
				['image/png', 'image/jpeg', 'image/jpg', 'image/bmp', 'image/gif', 'image/tiff']
			end
			def jp2_mime_type
				['image/jp2']
			end
			def pdf_mime_types
				['application/pdf']
			end
			def video_mime_types
				['video/mpeg', 'video/mp4', 'video/webm', 'video/x-msvideo', 'video/avi', 'video/quicktime', 'application/mxf']
			end
			def audio_mime_types
				# audio/x-wave is the mime type that fits 0.6.0 returns for a wav file.
				# audio/mpeg is the mime type that fits 0.6.0 returns for an mp3 file.
				['audio/mp3', 'audio/mpeg', 'audio/wav', 'audio/x-wave', 'audio/x-wav', 'audio/ogg']
			end
			def office_document_mime_types
				['text/rtf',
				'application/msword',
				'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
				'application/vnd.oasis.opendocument.text',
				'application/vnd.ms-excel',
				'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
				'application/vnd.ms-powerpoint',
				'application/vnd.openxmlformats-officedocument.presentationml.presentation']
			end
		end

		included do
			include Hydra::Derivatives
		
			makes_derivatives do |obj|
				case obj.mime_type
				when *pdf_mime_types
					obj.transform_file :content, { thumbnail: { format: 'jpg', size: '338x493', datastream: 'thumbnail' } }
				when *office_document_mime_types
					obj.transform_file :content, { thumbnail: { format: 'jpg', size: '200x150>', datastream: 'thumbnail' } }, processor: :document
				when *audio_mime_types
					obj.transform_file :content, { mp3: { format: 'mp3', datastream: 'mp3' }, ogg: { format: 'ogg', datastream: 'ogg' } }, processor: :audio
				when *video_mime_types
					obj.transform_file :content, { webm: { format: 'webm', datastream: 'webm' }, mp4: { format: 'mp4', datastream: 'mp4' }, thumbnail: { format: 'jpg', datastream: 'thumbnail' } }, processor: :video
				when *image_mime_types
					obj.transform_file :content, { thumbnail: { format: 'jpg', size: '200x150>', datastream: 'thumbnail' } }
				when *jp2_mime_type
		            obj.transform_file :content, { thumbnail: { format: 'jpg', size: '200x150>', datastream: 'thumbnail' }, jp2: { format: 'jp2', datastream: 'jpeg2k' } }			
				end
			end
		end
	end
end
