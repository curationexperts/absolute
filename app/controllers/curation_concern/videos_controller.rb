# Generated via
#  `rails generate curate:work Video`

class CurationConcern::VideosController < ApplicationController
  include Worthwhile::CurationConcernController
  set_curation_concern_type Video
end
