class OrganizationValidator < ActiveModel::Validator
  include ActiveModel::Validations

  def initialize(options={})
    @validators = [
      PresenceValidator.new(attributes: [:organization_name, :organization_size, :organization_sector, :organization_type]),
      InclusionValidator.new(attributes: [:organization_size], in: %w[<10 10-50 51-250 251-1000 >1000]),
      InclusionValidator.new(attributes: [:organization_type], in: %w[commercial non_commercial])
    ]
  end

  def validate(record)
    @validators.each do |validator|
      validator.validate(record)
    end
    if record.new_record? && Organization.exists?(name: record.organization_name)
      record.errors.add(:organization_name, "is already taken")
    end
  end

end
