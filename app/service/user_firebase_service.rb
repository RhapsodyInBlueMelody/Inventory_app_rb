class UserFirebaseService
  def self.all
    response = FIREBASE_CLIENT.get("users")
    if response.success? && response.body.present?
      # Firebase returns a hash of objects, convert to an array of objects
      response.body.map do |cargo_id, data|
        OpenStruct.new(data.merge(cargoId: cargo_id)) # Use OpenStruct for easy access
      end
    else
      []
    end
  end

  def self.find(cargo_id)
    response = FIREBASE_CLIENT.get("users/#{cargo_id}")
    if response.success? && response.body
      OpenStruct.new(response.body.merge(cargoId: cargo_id))
    else
      nil
    end
  end

  def self.create(attributes)
    # Firebase generates unique push IDs, or you can provide your own
    # For this example, let's assume we use a provided cargoId or let Firebase generate
    cargo_id = attributes[:cargoId] || SecureRandom.hex(10) # Simple ID generation
    response = FIREBASE_CLIENT.set("users/#{cargo_id}", attributes)
    response.success? ? OpenStruct.new(attributes.merge(cargoId: cargo_id)) : nil
  end

  # Add update and delete methods as needed
end
