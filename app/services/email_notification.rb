class EmailNotification
  def initialize(params)
    @params = params
  end

  def call
    p "user notified by email, params: #{@params}"
  end
end
