module ActiveRecord::Tablefree
  class CastType
    def assert_valid_value(*_args)
      true
    end

    # Needed for Rails 5.2 when using numericality validator
    def value_constructed_by_mass_assignment?(_value)
      false
    end

    # Needed for Rails 5.0
    def serialize(args)
      args
    end

    def deserialize(args)
      args
    end

    def cast(args)
      args
    end

    def changed?(*_args)
      false
    end

    def changed_in_place?(*_args)
      false
    end

    def force_equality?(value)
      case value
      when ::Array, ::Range
        true
      else
        false
      end
    end
  end
end
