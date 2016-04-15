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

  def initialize(params)
    super(params)
    @params = params.with_indifferent_access
    @inspections = []
  end

  def save
    if valid?
      build_inspections
      true
    else
      false
    end
  end


  private

  def build_inspections
    types = @params[:inspection_type_id].split(',')
    
    types.length.times do |i|  
      @inspections << create_inspection_with_address(@params.merge(inspection_type_id: types[i]))
    end
  end

  def create_inspection_with_address(attributes)
    inspection = Inspection.create(attributes)
    address = Address.create(attributes["address_attributes"].merge(inspection: inspection))
    inspection
  end

end
