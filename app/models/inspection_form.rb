class InspectionForm
  include ActiveModel::Model

  attr_reader :inspections

  attr_accessor(
    :permit_number,
    :contact_name,
    :contact_phone,
    :contact_phone_can_text,
    :contact_email,
    :inspection_type_id,
    :inspection_notes,
    :requested_for_date,
    :requested_for_time,
    :address_notes,
    :address_attributes,
  )

  validates :permit_number, presence: true
  validates :contact_name, presence: true
  validates :contact_phone, presence: true
  validates :contact_phone_can_text, presence: true
  validates :inspection_type_id, presence: true
  validates :requested_for_date, presence: true

  def initialize(*args)
    super(*args)
    @inspections = []
  end

  def save
    if valid?
      types = self.inspection_type_id.split(',')
      types.length.times do |i|
        
        @inspections << create_inspection_with_address(
          self.tap do |inspection| 
            inspection.inspection_type_id = types[i]
          end.as_json.except("validation_context", "errors")
        )
      end
    end
  end


  private

  def create_inspection_with_address(attributes)
    inspection = Inspection.create(attributes)
    address = inspection.create_address(attributes["address_attributes"])
    inspection
  rescue
    return false
  end

end