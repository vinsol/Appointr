class FutureValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if(value.class == Date)
      unless value >= (Date.today)
        record.errors[attribute] << (options[:message] || "can not be in past.")
      end
    else
      unless value >= (DateTime.current - 1.minute)
        record.errors[attribute] << (options[:message] || "can not be in past.")
      end
    end
  end
end