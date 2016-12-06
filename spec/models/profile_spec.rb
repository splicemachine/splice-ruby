describe Profile do
  let(:model) { described_class }

  describe 'Associations' do
    it_behaves_like 'habtm association', Tag
  end


  describe 'database actions' do
    let!(:profile1) { create :profile }
    let!(:profile2) { create :profile }
    let!(:profile3) { create :profile }
    let!(:profile4) { create :profile }

    it "should be able to create new tags for profiles" do
      tag = profile1.tags.where(name: 'BrandNewName').first_or_create
      expect(tag.name).to eq('BrandNewName')
    end

  end
end
