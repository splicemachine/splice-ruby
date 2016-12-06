describe Company do
  let(:model) { described_class }

  it { should have_db_column(:name).of_type(:string) }
  it { should have_many(:users) }
  it { should have_many(:profiles).through(:users) }
  it { should have_one(:address) }


  describe 'CRUD operations' do
    subject(:item) { create model }

    it_behaves_like 'model create'
    it_behaves_like 'model update', :name, 'New Company Name'
    it_behaves_like 'model readonly update', :description, 'Company Description'
    it_behaves_like 'model destroy'
    it_behaves_like 'model create_with', :name, 'New Company', :description, 'This Is A New Company'
  end

  describe 'Validation' do
    it_behaves_like 'model validation', :name
  end

  describe 'Associations' do
    it_behaves_like 'has_many association', User
    it_behaves_like 'polymorphic association', :address, Address
    it_behaves_like 'has_many through association', Profile, User
  end

  describe 'Selectors' do
    it_behaves_like 'selector', :all_records
    it_behaves_like 'selector', :ordered
    it_behaves_like 'selector', :reverse_ordered
    it_behaves_like 'selector', :limited
    it_behaves_like 'selector', :selected
    it_behaves_like 'selector', :grouped, group_by: :name, options: { name: 'New Name' }
    it_behaves_like 'selector', :offsetted

    it_behaves_like 'selector all with update', :name, { name: 'New Company' }

    it_behaves_like 'find selector'

    it_behaves_like 'join and include query', User

    it_behaves_like 'distinct selector', :name

    it_behaves_like 'eager_load selector', :users

    it_behaves_like 'preload selector', :users

    it_behaves_like 'references selector', :users

    it_behaves_like 'reverse_order selector'

    it_behaves_like 'find_by selector', :name, 'name1', 'name2'

    it_behaves_like 'range conditions'

    it_behaves_like 'subset conditions'

    it_behaves_like 'find_or_create_by selector', :name, 'Company1'

    it_behaves_like 'find_or_create_by! selector', :name, 'Company1'

    it_behaves_like 'find_or_initialize_by selector', :name, 'Company1'

    it_behaves_like 'select_all selector'

    it_behaves_like 'pluck selector', :name

    it_behaves_like 'ids selector'

    it_behaves_like 'exists? selector', :name, 'val1', 'val2'

    it_behaves_like 'minimum selector', :name, ['3', '5', '1', '4', '2']

    it_behaves_like 'raw sql selector', :name, 'TestName'
  end

  describe 'Additional functions' do
    it_behaves_like 'pessimistic locking'

    it_behaves_like 'extending scope'

    it_behaves_like 'none relation'
  end



  describe 'database actions' do
    let!(:company) { create :company }
    let!(:user1) { create :user, company_id: company.id }
    let!(:profile1) { create :profile, user_id: user1.id }
    let!(:user2) { create :user, company_id: company.id }
    let!(:profile2) { create :profile, user_id: user2.id }
    let!(:user3) { create :user, company_id: company.id }
    let!(:profile3) { create :profile, user_id: user3.id }

    it 'updates company name' do
      company_name = company.name
      expect{company.update(name: 'NewName')}.to change{company.reload.name}.from(company_name).to('NewName')
    end

    it "can get the average views for all it's profiles" do
      profile1.update_column(:views, 3)
      profile2.update_column(:views, 5)
      profile3.update_column(:views, 4)
      expect(company.average_profile_views).to eq(4)
    end

    it "can get the total views for all it's profiles" do
      profile1.update_column(:views, 37)
      profile2.update_column(:views, 53)
      profile3.update_column(:views, 17)
      expect(company.total_profile_views).to eq(107)
    end

    it "allows plucking profile ids" do
      expect(company.profiles.pluck(:id)).to eq([profile1.id, profile2.id, profile3.id])
    end

    it 'destroy the company and attached objects' do
      company.destroy!
      expect(Company.where(id: company.id).exists?).to eq(false)
      expect(User.where(id: user1.id).exists?).to eq(false)
      expect(User.where(id: user2.id).exists?).to eq(false)
      expect(User.where(id: user3.id).exists?).to eq(false)
      expect(Profile.where(id: profile1.id).exists?).to eq(false)
      expect(Profile.where(id: profile2.id).exists?).to eq(false)
      expect(Profile.where(id: profile3.id).exists?).to eq(false)
    end

    it 'should be able to create address' do
      # create_address wipes the addressable_id on the address on splice
      address = company.create_address!(street_name: 'SomeStreet', street_number: '123')

      expect(address.street_name).to eq('SomeStreet')
      expect(address.street_number).to eq('123')
      expect(address.addressable).to eq(company)
    end



  end
end
