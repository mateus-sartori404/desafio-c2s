class AuthServiceClient
  class Error < StandardError; end
  class Unauthorized < Error; end
  class UnprocessableEntity < Error; end

  def initialize(base_url: ENV["AUTH_SERVICE_URL"])
    @base_url = base_url
    @conn = Faraday.new(url: @base_url) do |faraday|
      faraday.request :json
      faraday.response :json, content_type: /\bjson$/
      faraday.adapter Faraday.default_adapter
      faraday.options.timeout = 8
      faraday.options.open_timeout = 3
    end
  end

  def register(email, password, password_confirmation)
    response = @conn.post("/register", { email: email, password: password, password_confirmation: password_confirmation })
    handle(response)
  end

  def login(email, password)
    response = @conn.post("/login", { email: email, password: password })
    handle(response)
  end


  private

  def post_json(path, payload)
    response = @conn.post(path, payload)
    handle(response)
  end

  def handle(response)
    case response.status
    when 200, 201, 202
      response.body
    when 401
      raise Unauthorized, "Unauthorized: #{response.body['error']}"
    when 422
      raise UnprocessableEntity, "Unprocessable Entity: #{response.body['error']}"
    else
      raise Error, "HTTP Error #{response.status}: #{response.body}"
    end
  end
end
