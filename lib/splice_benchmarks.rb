require 'benchmark'
require 'database_cleaner'

module SpliceBenchmarks
  include Benchmark
  RUN_CIRCLE = 1000
  THREAD_COUNT = 1000
  THREAD_SAMPLE_COUNT = 10

  def self.profile
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start

    Benchmark.benchmark(CAPTION, 20, FORMAT) do |x|
      x.report('create: ') { RUN_CIRCLE.times {|i| Company.create!(name: "Company#{i}")} }
      DatabaseCleaner.clean

      company = Company.create!(name: 'Company');
      x.report('update: ') { RUN_CIRCLE.times {|i| company.update(name: "Was Updated #{i}") } }
      DatabaseCleaner.clean

      company = Company.create!(name: 'Company');
      x.report('find: ') { RUN_CIRCLE.times {|i| Company.find(company.id) } }
      DatabaseCleaner.clean

      company = Company.create!(name: 'Company');
      x.report('where: ') { RUN_CIRCLE.times {|i| Company.where(name: 'Company').to_a } }
      DatabaseCleaner.clean

      company = Company.create!(name: 'Company');
      3.times { User.create!(company: company) }
      company2 = Company.create!(name: 'Company2');
      3.times { User.create!(company: company2) }
      x.report('join: ') { RUN_CIRCLE.times {|i| User.joins(:company).where(companies: {name: 'Company'}).to_a } }
      DatabaseCleaner.clean

      company = Company.create!(name: 'Company');
      6.times { User.create!(company: company) }
      x.report('includes: ') { RUN_CIRCLE.times {|i| Company.includes(:users).to_a } }
      DatabaseCleaner.clean

      company = Company.create!(name: 'Company1');
      4.times { User.create!(company: company, credit: 10) }
      company2 = Company.create!(name: 'Company2');
      3.times { User.create!(company: company2, credit: 10) }
      x.report('group: ') { RUN_CIRCLE.times {|i| User.group('company_id').count } }
      DatabaseCleaner.clean

      company = Company.create!(name: 'Company1');
      4.times { User.create!(company: company, credit: 10) }
      company2 = Company.create!(name: 'Company2');
      3.times { User.create!(company: company2, credit: 10) }
      x.report('group+having: ') { RUN_CIRCLE.times {|i| User.having('SUM(credit) > 30').group('company_id').count } }
      DatabaseCleaner.clean

      4.times {|i| Company.create!(name: "Company #{Random.rand(i+10)}") }
      x.report('order: ') { RUN_CIRCLE.times {|i| Company.order(:name).to_a } }
      DatabaseCleaner.clean

      4.times {|i| Company.create!(name: "Company #{i}") }
      x.report('limit: ') { RUN_CIRCLE.times {|i| Company.limit(2).to_a } }
      DatabaseCleaner.clean

      4.times {|i| Company.create!(name: "Company #{i}") }
      x.report('select: ') { RUN_CIRCLE.times {|i| Company.select(:name, :created_at).to_a } }
      DatabaseCleaner.clean

      2.times {|i| Company.create!(name: "Company1") }
      4.times {|i| Company.create!(name: "Company2") }
      3.times {|i| Company.create!(name: "Company3") }
      x.report('distinct: ') { RUN_CIRCLE.times {|i| Company.select(:name).distinct.to_a } }
      DatabaseCleaner.clean

      8.times {|i| Company.create!(name: "Company #{i}") }
      x.report('offset: ') { RUN_CIRCLE.times {|i| Company.offset(4).to_a } }
      DatabaseCleaner.clean
    end
    DatabaseCleaner.clean
  end

  def self.threads
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start

    Benchmark.benchmark(CAPTION, 20, FORMAT) do |x|
      x.report('Threads: ') {
        @threads = []
        THREAD_COUNT.times.each { |i|
          @threads << Thread.new {
            THREAD_SAMPLE_COUNT.times {
              Company.create!(name: "Company")
            }
          }
        }

        @threads.map(&:join)
      }
    end

    DatabaseCleaner.clean
  end

end
