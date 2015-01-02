module Customers::BaseHelper
  def get_day_number_options
    day_number_options = (0..6).inject([]) {|a,b| a << ["#{b}", b]}
  end
end