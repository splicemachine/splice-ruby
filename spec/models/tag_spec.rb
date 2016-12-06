describe Tag do
  let(:model) { described_class }

  describe 'CRUD operations' do
    subject(:item) { create model }

    it_behaves_like 'model create'
    it_behaves_like 'model update', :name, 'New Tag Name'
    it_behaves_like 'model destroy'
  end

  describe 'Associations' do
    it_behaves_like 'habtm association', User
  end
end