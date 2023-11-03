class ApplicationController < ActionController::API
  INTERNAL_SERVER_ERROR = "internal_server_error"
  NOT_FOUND = "not_found"

  MSG_NOT_FOUND = "Not Found"
  MSG_INTERNAL_SERVER_ERROR = "Internal Server Error"

  rescue_from StandardError, with: :rescue_standard_error
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found

  def success(data, status: :ok)
    {
      json: data,
      status: status
    }
  end


  def internal_server_error(code: INTERNAL_SERVER_ERROR, title: MSG_INTERNAL_SERVER_ERROR, detail: "", status: :internal_server_error)
    {
      json: {
        code: code,
        title: title,
        detail: detail,
      },
      status: status
    }
  end

  def not_found(code: INTERNAL_SERVER_ERROR, title: MSG_NOT_FOUND, detail: "")
    {
      json: {
        code: code,
        title: title,
        detail: detail,
      },
      status: :not_found
    }
  end

  private

  def logger
    @logger ||= Rails.logger
  end

  def rescue_standard_error(exception)
    logger.error(message: MSG_INTERNAL_SERVER_ERROR, exception: exception)

    render internal_server_error
  end

  def render_not_found(exception)
    logger.error(message: MSG_NOT_FOUND, exception: exception)

    render not_found
  end
end
