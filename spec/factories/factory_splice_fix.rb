# Fix for bug where every new records returns id=0 instead of the actual id value
FactoryGirl.define do

  to_create do |instance|
    instance.save!
    instance.id = instance.class.order(id: :desc)[0].id
    instance
  end

end
