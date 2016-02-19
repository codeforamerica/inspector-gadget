class Address < ActiveRecord::Base
  belongs_to :inspection

  def to_s
    [line_1, line_2, city, zip].join(' ')
  end
end
