class NotifierMailer < ApplicationMailer
  default from: 'Depot Store <depotstoreinfo@gmail.com>'
  
  def notify(error)
    @error = error
    mail to: 'foravitosells@gmail.com', subject: 'Notification about errors.'
  end
end
