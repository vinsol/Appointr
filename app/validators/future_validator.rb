class FutureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value >= (DateTime.current - 1.minute)
      record.errors[attribute] << (options[:message] || "can not be in past.")
    end
  end
end