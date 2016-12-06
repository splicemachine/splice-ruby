namespace :benchmark do
  task :models => :environment do
    Rails.application.config.active_record.logger = nil
    SpliceBenchmarks.profile
  end

  task :threads => :environment do
    Rails.application.config.active_record.logger = nil
    SpliceBenchmarks.threads
  end


end
