class AdvsMailer < ActionMailer::Base
  default from: "admin@bytelogistics.com"

  def send_advs(email, data)
  	@data = data
  	mail(:to => email, :subject => "Subject line")
  end
end
