module Orderable
  extend ActiveSupport::Concern
  SIGN_OPDERS = { "+" => "asc", "-" => "desc" }

  # A list of the param names that can be used for ordering the model list
  def ordering_params(params)
    # For example it retrieves a list of experiences in descending order of price.
    # Within a specific price, older experiences are ordered first
    #
    # GET /api/v1/experiences?sort=-price,created_at
    # ordering_params(params) # => "price desc, created_at asc"
    # Experience.order("price desc, created_at asc")
    #
    ordering = []
    return join_params(ordering) unless params[:sort]

    ordering = params[:sort].split(',').each_with_object(ordering) do |attr, memo|
      sort_sign = (attr =~ /\A[+-]/) ? attr.slice!(0) : "+"
      memo << "#{attr} #{SIGN_OPDERS[sort_sign]}"
    end
    join_params(ordering)
  end

  private

  def join_params(ordering)
    ordering.join(",")
  end
end
