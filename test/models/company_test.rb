require 'test_helper'

class CompanyTest < ActiveSupport::TestCase
  test "Company can be created" do
    company = Company.create(name: 'Company Name')
    assert_equal company.name, 'Company Name'
  end
end
