class BulkUpdateController < ApplicationController
  include Worthwhile::ThemedLayoutController
  include ApplicationHelper
  with_themed_layout '1_column'

  authorize_resource class: false

  def update
  end

  # This funcion replaves an :old value with a :new value
  def replace
    get_pids(get_query(params[:old])).each do |pid|
      item = ActiveFedora::Base.find(pid['id'])
      if item[params[:field]].include? params[:old]
        item[params[:field]] -= [params[:old]]
        item[params[:field]] << params[:new]
        item.save
        item.update_index
      end
    end
    redirect_to bulk_update_path
  end

  # This function takes a character and splits a field using that character as a delimiter
  def split
    if params[:char].nil? or params[:char].empty?
      flash[:alert] = "No delimiter entered"
      redirect_to bulk_update_path and return
    end

    get_pids(get_query(params[:string])).each do |pid|
      item = ActiveFedora::Base.find(pid['id'])
      if item[params[:field]].include? params[:string]
        item[params[:field]] << params[:string].split(params[:char]).collect(&:strip)
        item[params[:field]] -= [params[:string]]
        item.save
        item.update_index
      end
    end
    redirect_to bulk_update_path
  end

  # This function takes a collection PID and a rights statement and updates all collection
  # members to have the selected rights statement
  def update_rights
    collection = ActiveFedora::Base.find(params[:collection])
    collection.members.each do |member|
      member.rights = [params[:rights]]
      member.save
      member.update_index
    end
    redirect_to bulk_update_path
  end

  # This function updates the visibility of a collection and all of the items in that collection
  def update_access
    Resque.enqueue(UpdateAccessJob, params[:collection], params[:visibility] )
    redirect_to bulk_update_path
  end

private

  # Get the PIDs for a specified search
  def get_pids(query)
    response = remote_solr.get('select', params: { q: query, fl: "id", rows: 100000 } )
    pids = response['response']['docs']
  end

  # Get the solr query from the submitted parameters
  def get_query(parameter)
    response = "#{solr_field_name(params[:field])}:\"#{parameter}\""
    response += " collection_tesim:\"#{params[:collection]}\"" unless params[:collection].nil?
  end

  # map the passed in values to the correct solr name
  def solr_field_name(field)
    case field
    when "subject"
      return "desc_metadata__subject_sim"
    when "creator"
      return "desc_metadata__creator_sim"
    when "language"
      return "desc_metadata__language_sim"
    when "description"
      return "desc_metadata__description_tesim"
    end
  end

end
