module Customers::BaseHelper
  def get_day_number_options
    day_number_options = []
    (0..6).each do |number|
      day_number_options << ["#{number}", number]
    end
    day_number_options
  end
end