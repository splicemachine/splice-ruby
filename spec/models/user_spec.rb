describe User do
  let(:model) { described_class }

  it { should have_db_column(:email).of_type(:string) }
  # it { should validate_presence_of(:email) }

  it { should belong_to(:company) }
  it { should have_one(:profile) }
  it { should have_one(:address).through(:profile) }

  describe 'CRUD operations' do
    subject(:item) { create model }

    it_behaves_like 'model create'
    it_behaves_like 'model update', :name, 'New Name'
    it_behaves_like 'model destroy'
  end

  describe 'Associations' do
    it_behaves_like 'has_one association', Profile
    it_behaves_like 'belongs_to association', Company, true
    # it_behaves_like 'has_one through association', Address, Profile
  end

  describe 'Selectors' do
    it_behaves_like 'selector', :having_grouped, group_by: :email, options: { credit: 1 }

  end

  describe 'database actions' do
    let!(:company) { create :company }
    let!(:user) { create :user, company_id: company.id }
    let!(:profile) { create :profile, user_id: user.id }
    let!(:address) { create :address, addressable: profile }

    it "should be able to access address on profile" do
      expect(user.address).to eq(address)
    end

    it "should be able create if record not found" do
      new_user = company.users.where(name: 'New Name').first_or_create
      expect(company.users.count).to eq(2)
    end

    it "should be able access profiles" do
      expect(company.profiles.count).to eq(1)
    end
  end
end
