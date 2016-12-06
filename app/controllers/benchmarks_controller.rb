class BenchmarksController < ApplicationController

  def method_create
    Company.create!(name: "Company")
    head :ok, content_type: "text/html"
  end

  def method_update
    company = Company.first
    company.update!(name: "New Company Name")

    head :ok, content_type: "text/html"
  end

  def method_where
    # Create a company in console before testing it out
    companies = Company.where(id: params[:id])
    ids = companies.ids
    head :ok, content_type: "text/html"
  end

  def method_limit
    companies = Company.limit(1)
    ids = companies.ids
    head :ok, content_type: "text/html"
  end

  def method_offset
    companies = Company.offset(1)
    ids = companies.ids
    head :ok, content_type: "text/html"
  end

  def method_group
    companies = Company.grouped
    ids = companies.count
    head :ok, content_type: "text/html"
  end

    def method_select
    companies = Company.select :id
    ids = companies.ids
    head :ok, content_type: "text/html"
  end

end
