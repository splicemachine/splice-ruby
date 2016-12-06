class MailWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(klass, method, *args)
    mail = klass.constantize.send(method, *args)
    mail.deliver
  end
end