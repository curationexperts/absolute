# Generated via
#  `rails generate curate:work Text`
require 'active_fedora/base'
class Text < ActiveFedora::Base
  include CurationConcern::Work
  include CurationConcern::WithGenericFiles
  include CurationConcern::WithLinkedResources
  include CurationConcern::WithLinkedContributors
  include CurationConcern::WithRelatedWorks
  include CurationConcern::Embargoable
  include ActiveFedora::RegisteredAttributes
  include CurationConcern::RemotelyIdentifiedByDoi::Attributes
  
  include CurationConcern::WithCaseBasicMetadata
  has_metadata "descMetadata", type: GenericWorkRdfDatastream
  
  include CurationConcern::WithDatastreamAttachments
  self.accept_datastream_attachments ["TEI", "TEIP5", "MODS"]
  


  class_attribute :human_readable_short_description
  self.human_readable_short_description = "Any Text work, preferably with TEI xml attached."

  attribute :files, multiple: true, form: {as: :file},
    hint: "CTRL-Click (Windows) or CMD-Click (Mac) to select multiple files."

end
