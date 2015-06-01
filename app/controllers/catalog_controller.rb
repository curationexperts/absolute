class CatalogController < ApplicationController
  include Worthwhile::CatalogController
  CatalogController.solr_search_params_logic += [:default_parameters]

  configure_blacklight do |config|
    config.add_facet_field solr_name("datastreams", :symbol), label: "Datastreams", if: :admin?
    config.add_facet_field solr_name("collection", :facetable), label: "Collection", helper_method: :display_collection
    config.facet_fields[solr_name("desc_metadata__language", :facetable)].helper_method = :display_language
    config.add_facet_field 'date_sort', label: "Publication Year", range: true
  end

  def export_ris
    doc = ActiveFedora::Base.find(params[:id])
    data = RISCreator.new(doc).export
    send_data data, filename: 'RIS_citation_' + params[:id] + ".ris"
  end
	
  protected

  def default_parameters(solr_params, _)
    unless has_search_parameters?
      solr_params[:fq] ||= []
      solr_params[:fq] << [ActiveFedora::SolrService.construct_query_for_rel(has_model: Collection.to_class_uri)]
    end
  end

end
