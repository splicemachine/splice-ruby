RSpec.shared_examples 'model create' do
  it 'is created' do
    expect{ create(model) }.to change(model, :count).by(1)
  end
end

RSpec.shared_examples 'model update' do |field, value|

  it 'is updated' do
    old_field = item.send(field)
    expect{item.update field => value}.to change{item.send(field)}.from(old_field).to(value)
  end
end

RSpec.shared_examples 'model readonly update' do |field, value|
  before { item.update field => value }

  it 'is not updated' do
    expect(model.where(id: item.id)[0].send(field)).not_to eq value
  end
end

RSpec.shared_examples 'model destroy' do
  before { item.save }

  it 'is destroyed' do
    expect{ item.destroy }.to change(model, :count).by(-1)
  end
end

RSpec.shared_examples 'model create_with' do |find_by_field, find_by_value, field, value|
  it 'creates with value' do
    expect{ model.create_with(field => value).find_or_create_by(find_by_field => find_by_value) }.to change(model, :count).by(1)
    expect(model.order(id: :desc)[0][find_by_field]).to eq(find_by_value)
  end

  it 'returns an existing model' do
    model.create!(find_by_field => find_by_value)
    expect{ model.create_with(field => value).find_or_create_by(find_by_field => find_by_value) }.to change(model, :count).by(0)
  end
end


RSpec.shared_examples 'model validation' do |*fields|
  let(:new_item) { model.new }

  it 'is not created if it is not valid' do
    expect(new_item).to_not be_valid
    fields.each do |field|
      expect(new_item.errors[field].any?).to be_truthy
    end
  end
end

RSpec.shared_examples 'belongs_to association' do |model_associated, required = false|
  let (:item) { create model }
  let (:item_associated) { create model_associated }
  let (:model_association) { model_associated.to_s.downcase }

  it "adds #{model_associated}" do
    item.send("#{model_association}=", item_associated)
    item.save
    expect(model.where(id: item.id)[0].send(model_association)).to eq item_associated
  end

  if required
    it "does not remove #{model_associated}" do
      item.send("#{model_association}=", item_associated)
      item.save
      item.send("#{model_association}=", nil)
      expect(item).to_not be_valid
    end
  end
end

RSpec.shared_examples 'has_one association' do |model_associated, required = false|
  let (:item) { create model }
  let (:item_associated) { create model_associated }
  let (:model_association) { model_associated.to_s.downcase }

  before do
    item.send("#{model_association}=", item_associated)
    item.save
  end

  it "adds #{model_associated}" do
    expect(model.where(id: item.id)[0].send(model_association)).to eq item_associated
  end

  if required
    it "does not remove #{model_associated}" do
      item.send("#{model_association}=", nil)
      expect(item).to_not be_valid
    end
  end
end

RSpec.shared_examples 'has_many association' do |model_associated, required = false|
  let (:item) { create model }
  let (:item_associated) { create model_associated }
  let (:model_association) { model_associated.model_name.plural }

  before do
    item.send(model_association) << item_associated
  end

  it "adds #{model_associated}" do
    if required
      expect(item.send(model_association).count).to eq 2
      expect(item.send(model_association)[1]).to eq item_associated
    else
      expect(item.send(model_association).count).to eq 1
      expect(item.send(model_association)[0]).to eq item_associated
    end
  end

  it "removes #{model_associated}" do
    item.send(model_association).delete(item_associated)
    if required
      expect(item.send(model_association).count).to eq 1
      expect(item.send(model_association)[0]).to_not be_nil
    else
      expect(item.send(model_association).count).to eq 0
      expect(item.send(model_association)[0]).to be_nil
    end
  end

  it "destroys dependent #{model_associated}" do
    item.destroy
    expect(item.send(model_association).count).to eq 0
    expect(item.send(model_association)[0]).to be_nil
  end
end

RSpec.shared_examples 'habtm association' do |model_associated, required = false|
  let (:item) { create model }
  let (:item_associated) { create model_associated }
  let (:model_association) { model_associated.model_name.plural }

  it "adds #{model_associated}" do
    item.send(model_association) << item_associated
    if required
      expect(item.send(model_association).count).to eq 2
    else
      expect(item.send(model_association).count).to eq 1
    end
    expect(item.send(model_association).order(id: :desc)[0]).to eq item_associated
  end

  it "creates #{model_associated}" do
    item.send(model_association).send(:create, item_associated.attributes.except('id', 'created_at', 'updated_at'))
    expect(item.send(model_association).count).to eq 1
  end

  it "removes #{model_associated}" do
    item.send(model_association) << item_associated
    item.send(model_association).delete(item_associated)
    if required
      expect(item.send(model_association).count).to eq 1
      expect(item.send(model_association)[0]).to_not be_nil
    else
      expect(item.send(model_association).count).to eq 0
      expect(item.send(model_association)[0]).to be_nil
    end
  end
end

RSpec.shared_examples 'has_many through association' do |model_associated, model_through|
  let (:item) { create model }
  let (:base_model_association) { model.to_s.downcase }
  let (:model_association) { model_associated.to_s.downcase }
  let (:model_association_pl) { model_associated.model_name.plural  }
  let (:model_through_association) { model_through.to_s.downcase }
  let (:model_through_association_pl) { model_through.model_name.plural }

  let! (:item_through) { create model_through, base_model_association => item }
  let! (:item_associated) { create model_associated, model_through_association => item_through}

  it "creates #{model_associated}" do
    expect(item.send(model_association_pl).count).to eq 1
  end

  it "deletes #{model_associated}" do
    item.send(model_through_association_pl).send(:destroy_all)
    expect(item.send(model_association_pl).count).to eq 0
  end

end


RSpec.shared_examples 'polymorphic association' do |model_association, *models_associated|
  let (:item) { create model }

  models_associated.each do |model_associated|
    it "has an association with #{model_associated}" do
      item_associated = create model_associated
      item.send "#{model_association}=", item_associated
      expect(item.send(model_association)).to be_an(model_associated)
    end
  end
end

RSpec.shared_examples 'join and include query' do |model_associated|
  let! (:item) { create model }
  let (:item_associated) { create model_associated }
  let (:model_association) { model_associated.model_name.plural }

  before do
    item.send(model_association) << item_associated
  end

  it ".joins #{model_associated}" do
    item_relation = model.send(:where, {id: item.id})
    item_relation.joins(model_association.downcase.to_sym).each do |item_object|
      expect(item_object.send(model_association).count).to eq 1
    end
  end

  it ".includes #{model_associated}" do
    model.send(:where, {id: item.id}).includes(model_association.downcase.to_sym).each do |item_object|
     expect(item_object.send(model_association).count).to eq 1
    end
  end
end

RSpec.shared_examples 'pessimistic locking' do
  let (:item) { create model }

  it 'locks table row' do
    ActiveRecord::Base.transaction do
      locked_item = model.find(item.id).lock!
      expect(locked_item.update_attributes({})).to eq true
    end
  end
end


RSpec.shared_examples 'selector' do |scope_action, group_by: nil, options: {}|
  describe ".#{scope_action}" do
    let!(:item_1) { create model, options }
    let!(:item_2) { create model, options}

    it 'returns items' do
      return_result = case scope_action
      when :all_records
        [item_1, item_2]
      when :ordered
        [item_2, item_1]
      when :reverse_ordered
        [item_1, item_2]
      when :limited
        [item_1]
      when :selected
        [item_1, item_2]
      when :grouped
        { item_1.send(group_by) => 2 }
      when :having_grouped
        { item_1.try(group_by) => 1, item_2.try(group_by) => 1 }
      when :offsetted
        [item_2]
      end

      result = model.send(scope_action)
      if scope_action == :grouped || scope_action == :having_grouped
        result = result.count
      end

      expect(result).to eq return_result
    end
  end
end

RSpec.shared_examples 'selector all with update' do |field, options = {}|
  let!(:item_1) { create model }
  let!(:item_2) { create model }

  describe ".all after update" do
    it 'returns item' do
      item_2.update(options)
      expect(model.where(id: item_2.id)[0].send(field)).to eq item_2.send(field)
    end
  end

end

RSpec.shared_examples 'find selector' do
  let!(:item_1) { create model }
  let!(:item_2) { create model }

  describe ".find" do
    it 'returns item' do
      expect(model.send(:find, item_2.id)).to eq item_2
    end
  end

  describe ".find array" do
    it 'returns items' do
      expect(model.send(:find, [item_1.id, item_2.id])).to eq [item_1, item_2]
    end
  end

  describe ".find_in_batches" do
    it 'returns all items' do
      model.send(:find_in_batches) do |batch|
        expect(batch).to eq [item_1, item_2]
      end
    end
  end
end


RSpec.shared_examples 'having selector' do
  let!(:item_1) { create model }
  let!(:item_2) { create model }

  describe ".find" do
    it 'returns item' do
      expect(model.send(:find, item_2.id)).to eq item_2
    end
  end

  describe ".find array" do
    it 'returns items' do
      expect(model.send(:find, [item_1.id, item_2.id])).to eq [item_1, item_2]
    end
  end

  describe ".find_in_batches" do
    it 'returns all items' do
      model.send(:find_in_batches) do |batch|
        expect(batch).to eq [item_1, item_2]
      end
    end
  end
end

RSpec.shared_examples 'distinct selector' do |field|
  let!(:item_1) { create model, field => 1 }
  let!(:item_2) { create model, field => 2 }
  let!(:item_3) { create model, field => 2 }
  let!(:item_4) { create model, field => 3 }

  it "returns unique values" do
    expect(model.select(field).distinct.map(&field).map(&:to_i).sort).to eq([1, 2, 3])
  end
end

RSpec.shared_examples 'eager_load selector' do |association|
  let!(:main_item) { create model }

  before do
    main_item.send(association).create!
    @sub_item1 = main_item.send(association).order(id: :desc)[0]
    main_item.send(association).create!
    @sub_item2 = main_item.send(association).order(id: :desc)[0]
    main_item.send(association).create!
    @sub_item3 = main_item.send(association).order(id: :desc)[0]
  end

  it "loads the associated items" do
    expect(model.eager_load(association).where(id: main_item.id)[0].send(association).to_a).to eq([@sub_item1, @sub_item2, @sub_item3])
  end
end

RSpec.shared_examples 'extending scope' do
  let!(:item_1) { create model }
  let!(:item_2) { create model }
  let!(:item_3) { create model }
  let!(:item_4) { create model }
  let!(:item_5) { create model }
  let!(:item_6) { create model }

  it "allows extending a scope" do
    scope = model.all.extending do
      def page(number)
        per_page = 4
        limit(per_page).offset((number - 1) * per_page)
      end
    end
    expect(scope.page(2).to_a).to eq([item_5, item_6])
  end
end

RSpec.shared_examples 'none relation' do |association|
  it "returns an empty active record relation" do
    expect(model.none.to_a).to eq([])
  end
end

RSpec.shared_examples 'preload selector' do |association|
  let!(:main_item) { create model }

  before do
    main_item.send(association).create!
    @sub_item1 = main_item.send(association).order(id: :desc)[0]
    main_item.send(association).create!
    @sub_item2 = main_item.send(association).order(id: :desc)[0]
    main_item.send(association).create!
    @sub_item3 = main_item.send(association).order(id: :desc)[0]
  end

  it "loads the associated items" do
    expect(model.preload(association).where(id: main_item.id)[0].send(association).to_a).to eq([@sub_item1, @sub_item2, @sub_item3])
  end
end

RSpec.shared_examples 'references selector' do |association|
  let!(:main_item) { create model }

  before do
    main_item.send(association).create!(created_at: 1.week.ago)
    @sub_item1 = main_item.send(association).order(id: :desc)[0]
    main_item.send(association).create!(created_at: 2.weeks.ago)
    @sub_item2 = main_item.send(association).order(id: :desc)[0]
    main_item.send(association).create!(created_at: 3.weeks.ago)
    @sub_item3 = main_item.send(association).order(id: :desc)[0]
  end

  it "loads the associated items with an SQL query fragment" do
    expect(model.includes(association).where("#{association}.created_at >= ?", 16.days.ago).references(association)[0].send(association)).to eq([@sub_item1, @sub_item2])
  end
end

RSpec.shared_examples 'reverse_order selector' do
  let!(:item1) { create model, name: 'name1' }
  let!(:item2) { create model, name: 'name2' }
  let!(:item3) { create model, name: 'name3' }

  it "reverses the order of returned items" do
    expect(model.order(:name).reverse_order).to eq([item3, item2, item1])
  end
end

RSpec.shared_examples 'find_by selector' do |field, value1, value2|
  let!(:item1) { create model, field => value1 }
  let!(:item2) { create model, field => value2 }

  it "returns the item with the correct value" do
    expect(model.find_by(field => value1)).to eq(item1)
  end
end

RSpec.shared_examples 'range conditions' do
  let!(:item1) { create model, created_at: 1.day.ago }
  let!(:item2) { create model, created_at: 2.days.ago }
  let!(:item3) { create model, created_at: 4.days.ago }

  it "returns the item with the correct value" do
    expect(model.where(created_at: 3.days.ago..DateTime.now)).to eq([item1, item2])
  end
end

RSpec.shared_examples 'subset conditions' do
  let!(:item1) { create model, name: 'name1' }
  let!(:item2) { create model, name: 'name2' }
  let!(:item3) { create model, name: 'name3' }
  let!(:item4) { create model, name: 'name4' }

  it "returns the items with the correct values" do
    expect(model.where(name: ['name1', 'name2', 'name4'])).to eq([item1, item2, item4])
  end
end

RSpec.shared_examples 'find_or_create_by selector' do |field, value|
  it "creates a new object when it doesn't exist" do
    expect(model.find_or_create_by(field => value).send(field)).to eq(value)
  end

  it "returns an existing object" do
    item1 = create(model, field => value)
    expect(model.find_or_create_by(field => value)).to eq(item1)
  end
end

RSpec.shared_examples 'find_or_create_by! selector' do |field, value|
  it "creates a new object when it doesn't exist" do
    expect(model.find_or_create_by!(field => value).send(field)).to eq(value)
  end

  it "returns an existing object" do
    item1 = create(model, field => value)
    expect(model.find_or_create_by!(field => value)).to eq(item1)
  end
end

RSpec.shared_examples 'find_or_initialize_by selector' do |field, value|
  it "initializes a new object when it doesn't exist" do
    expect(model.find_or_initialize_by(field => value).attributes).to eq(model.new(field => value).attributes)
  end

  it "returns an existing object" do
    item1 = create(model, field => value)
    expect(model.find_or_initialize_by(field => value)).to eq(item1)
  end
end

RSpec.shared_examples 'select_all selector' do
  let!(:item) { create model }
  it "returns an array of hashes with results from the database" do
    expect(model.connection.select_all("SELECT * FROM #{model.table_name} WHERE id = #{item.id}").to_a[0].slice('id', 'name', 'description')).to eq({"id" => item.id, "name" => item.name, "description" => item.description})
  end
end

RSpec.shared_examples 'pluck selector' do |field|
  let!(:item1) { create model, field => 'val1' }
  let!(:item2) { create model, field => 'val2' }
  let!(:item3) { create model, field => 'val3' }

  it "returns an array of values for the field" do
    expect(model.pluck(field)).to eq(['val1', 'val2', 'val3'])
  end
end

RSpec.shared_examples 'ids selector' do
  let!(:item1) { create model }
  let!(:item2) { create model }
  let!(:item3) { create model }

  it "returns an array of values for the field" do
    expect(model.ids).to eq([item1.id, item2.id, item3.id])
  end
end

RSpec.shared_examples 'exists? selector' do |field, value, other_value|
  let!(:item) { create model, field => value }

  it "returns true when object exists" do
    expect(model.where(field => value).exists?).to eq(true)
  end

  it "returns false when object doesn't exist" do
    expect(model.where(field => other_value).exists?).to eq(false)
  end
end

RSpec.shared_examples 'minimum selector' do |field, values|
  it "returns the minimal value for selected field" do
    minimum = values.min
    values.each do |value|
      create(model, field => value)
    end
    expect(model.minimum(field)).to eq(minimum)
  end
end

RSpec.shared_examples 'raw sql selector' do |field, value|
  it "returns the expected results" do
    create(model, field => value)
    sql = "SELECT * FROM #{model.table_name} ORDER BY #{model.table_name}.id DESC FETCH NEXT 1 ROWS ONLY"
    results = ActiveRecord::Base.connection.execute(sql)
    expect(results[0][field.to_s]).to eq(value)
  end
end
