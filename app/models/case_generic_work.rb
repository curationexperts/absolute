class CaseGenericWork < ActiveFedora::Base
  include CurationConcern::CaseWork

  self.human_readable_type = "Other"
  self.human_readable_short_description = "Any type of work, with files associated and XML optionally attached."
  self.accept_datastream_attachments ["MODS", "TEI", "TEIP5", "VRA", "PBCore", "METS", "QDC"]
end
