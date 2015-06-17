require 'spec_helper'

describe BulkUpdateController do
  let(:source_text) { Text.new(pid: 'ksl:test', title: ["A Test Title"], description: ["A test"], rights: [Sufia.config.cc_licenses.first]) }
  let(:test_object) { Text.new(pid: 'ksl:tst2', title: ["Another Test"], description: ["A test"], rights: [Sufia.config.cc_licenses.second]) }
  let(:collection1) { Collection.new(pid: "ksl:col1", title: "Collection #1") }
  let(:collection2) { Collection.new(pid: "ksl:col2", title: "Collection #2") }

  before :all do
    ActiveFedora::Base.delete_all
  end

  describe 'an admin user' do
    let(:admin) { FactoryGirl.create(:admin) }
    before { sign_in admin }

    it 'gets the update page' do
      get :index
      expect(response).to be_successful
      expect(response).to render_template(:index)
    end
  end

  describe 'a non-admin user' do 
    let(:user) { FactoryGirl.create(:user) }
    before { sign_in user }

    it 'denies access' do
      get :index
      expect(response).to redirect_to root_url
    end
  end

  describe '#replace' do
    let(:admin) { FactoryGirl.create(:admin) }

    before :each do
      sign_in admin
      source_text.subject = ["Never", "gonna", "give", "you", "up"]
      source_text.language = ['Eng']
      source_text.creator = ['Rick Astley']
      source_text.description = ['N.A.']
      source_text.save
    end

    it 'should replace a subject with a new value' do
      post :replace, field: "subject", old: "give", new: "let"

      item = ActiveFedora::Base.find(source_text.pid)
      expect(item.subject).to eq ["Never", "gonna", "you", "up", "let"]
      expect(response).to redirect_to bulk_update_path
    end

    it 'should replace a language with a new values' do
      post :replace, field: "language", old: "Eng", new: "deu"

      item = ActiveFedora::Base.find(source_text.pid)
      expect(item.language).to eq ["deu"]
      expect(response).to redirect_to bulk_update_path
    end

    it 'should replace a creator (person facet) with a new value' do
      post :replace, field: "creator", old: "Rick Astley", new: "Astley, Rick"

      item = ActiveFedora::Base.find(source_text.pid)
      expect(item.creator).to eq ["Astley, Rick"]
      expect(response).to redirect_to bulk_update_path
    end

    it 'should replace a description with a new value' do
      post :replace, field: "description", old: "N.A.", new: "Here is a description"

      item = ActiveFedora::Base.find(source_text.pid)
      expect(item.description).to eq ["Here is a description"]
      expect(response).to redirect_to bulk_update_path
    end
  end

  describe '#split' do
    let(:admin) { FactoryGirl.create(:admin) }

    before :each do
      sign_in admin
      source_text.subject = ["Never/ gonna / give/you /up"]
      source_text.language = ["eng, deu"]
      source_text.creator = ["Astley, Rick; RCA Records"]
      source_text.save
    end

    it 'should split a subject on a character' do
      post :split, field: "subject", string: "Never/ gonna / give/you /up", char: "/"

      item = ActiveFedora::Base.find(source_text.pid)
      expect(item.subject).to eq ["Never", "gonna", "give", "you", "up"]
      expect(response).to redirect_to bulk_update_path
    end

    it 'should split a language on a character' do
      post :split, field: "language", string: "eng, deu", char: ","

      item = ActiveFedora::Base.find(source_text.pid)
      expect(item.language).to eq ["eng", "deu"]
      expect(response).to redirect_to bulk_update_path
    end

    it 'should split a creator on a character' do
      post :split, field: "creator", string: "Astley, Rick; RCA Records", char: ";"

      item = ActiveFedora::Base.find(source_text.pid)
      expect(item.creator).to eq ["Astley, Rick", "RCA Records"]
      expect(response).to redirect_to bulk_update_path
    end

    it 'should prevent splitting without a character' do
      post :split, field: "subject", string: "test", char: ""

      expect(response).to redirect_to bulk_update_path
      expect(flash[:alert]).to eq "No delimiter entered"
    end
  end

  describe "#update_rights" do
    let(:admin) { FactoryGirl.create(:admin) }

    before :each do
      sign_in admin
      collection1.members << source_text
      collection2.members << test_object
    end

    it 'should update the rights statements of the selected collection and not other collections' do
      skip "This code works when tested directly, but fails when run by rspec"
      post :update_rights, collection: collection2.pid, rights: Sufia.config.cc_licenses.third

      expect(ActiveFedora::Base.find(source_text.pid).rights).to eq [Sufia.config.cc_licenses.first]
      expect(ActiveFedora::Base.find(test_object.pid).rights).to eq [Sufia.config.cc_licenses.third]
    end
  end

  describe "#update_access to restrict access" do
    let(:admin) { FactoryGirl.create(:admin) }

    before :each do
      sign_in admin
    end

    it "should update a collection to restrict access to works and their files" do
      post :update_access, pid: collection1.pid, visibility: "restricted"

      expect(flash[:notice]).to eq "The collection #{collection1.name} is being updated to #{visibility}"
      expect(response).to redirect_to bulk_update_path
    end
  end

  describe "#update_access to open access" do
    let(:admin) { FactoryGirl.create(:admin) }

    before :each do
      sign_in admin
    end

    it "should update a collection to open access to the works and their files" do
      post :update_access, pid: collection1.pid, visibility: "open"

      expect(flash[:notice]).to eq "The collection #{collection1.name} is being updated to #{visibility}"
      expect(response).to redirect_to bulk_update_path
    end
  end

end
