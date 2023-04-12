class PhoneNotification
  def initialize(params)
    @params = params
  end

  def call
    p "user notified by phone, params: #{@params}"
  end
end
