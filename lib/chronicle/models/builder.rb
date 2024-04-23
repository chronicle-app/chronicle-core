module Chronicle
  module Models
    # Utility methods to build models from hash input
    module Builder
      # Build a nested a model with nested associated from a hash in json-ld format
      def build(obj)
        raise ArgumentError, 'Object must be a hash' unless obj.is_a?(Hash)

        type = obj[:@type]
        raise ArgumentError, 'Object must have a type' unless type

        model_klass = const_get(type.to_sym)
        raise ArgumentError, "Unknown model type: #{type}" unless model_klass

        # recursively create nested models
        # TODO: have a better way of detecting chronicle schema objects
        begin
          obj.each do |property, value|
            if value.is_a?(Hash)
              obj[property] = build(value)
            elsif value.is_a?(Array)
              obj[property] = value.map do |v|
                v.is_a?(Hash) ? build(v) : v
              end
            end
          end

          model_klass.new(obj.except(:@type))
        rescue Chronicle::Models::AttributeError => e
          raise ArgumentError, e.message
        end
      end
    end
  end
end
