# frozen_string_literal: true

# Handles all errors within entire app
module ErrorHandler

  # Reports error to log with backtrace
  # @param e [StandardError]
  def log_error(e, custom_error_message = nil)
    logger.error(prepared_error_message(e, custom_error_message))
  end

  # Reports info message to log
  # @param info_message [String]
  def log_info(info_message)
    logger.info(info_message)
  end

  # Reports debug message to log
  # @param debug_message [String]
  def log_debug(debug_message)
    logger.debug(debug_message)
  end

  # Reports debug message to log
  # @param warn_message [String]
  def log_warn(warn_message)
    logger.warn(warn_message)
  end

  # Prepares error message
  # @param e [StandardError]
  # @param custom_error_message [String]
  def prepared_error_message(e, custom_error_message)
    if e
      backtrace = e.backtrace.nil? ? "trace is empty" : e.backtrace.join("\n\t")
      return "#{custom_error_message}\n#{e.class}: #{e.message}\n#{backtrace}" if custom_error_message.present?
      "#{e.class}: #{e.message}\n#{backtrace}"
    else
      custom_error_message
    end
  end

  # Reports metrics data reporter errors to prevent looping
  # @param e [StandardError]
  def log_aspect_error(e)
    logger.error(e)
  end

  def logger
    @logger ||= Rails.logger
  end
end
