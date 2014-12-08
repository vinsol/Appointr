ThinkingSphinx::Index.define :appointment, :with => :active_record do
  # fields
  indexes customer.name, :as => :customer, :sortable => true
  indexes customer.email
  indexes staff.name, :as => :staff, :sortable => true
  indexes staff.email
  indexes service.name

  # attributes
  has created_at, updated_at
end