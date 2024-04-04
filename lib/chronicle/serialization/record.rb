module Chronicle::Serialization
  class Record
    attr_reader :properties,
      :type,
      :id,
      :meta,
      :schema

    def initialize(properties: {}, type: nil, id: nil, meta: {}, schema: nil)
      @properties = properties
      @type = type
      @id = id
      @meta = meta
      @schema = schema
    end

    def self.build_from_model(model)
      raise ArgumentError, 'model must be a Chronicle::Models::Base' unless model.is_a?(Chronicle::Models::Base)

      properties = model.properties.transform_values do |v|
        if v.is_a?(Array)
          v.map do |record|
            if record.is_a?(Chronicle::Models::Base)
              Record.build_from_model(record)
            else
              record
            end
          end
        elsif v.is_a?(Chronicle::Models::Base)
          Record.build_from_model(v)
        else
          v
        end
      end.compact

      new(
        properties: properties,
        type: model.type_id,
        id: model.id,
        meta: model.meta,
        schema: :chronicle
      )
    end

    def association_properties
      # select properties whose values are a record, or are an array that contain a record
      properties.select do |_k, v|
        if v.is_a?(Array)
          v.any? { |record| record.is_a?(Chronicle::Serialization::Record) }
        else
          v.is_a?(Chronicle::Serialization::Record)
        end
      end
    end

    def attribute_properties
      properties.reject { |k, _v| association_properties.keys.include?(k) }
    end

    def to_h
      properties.transform_values do |v|
        if v.is_a?(Array)
          v.map do |item|
            value_to_h(item)
          end
        else
          value_to_h(v)
        end
      end.merge({ type: type, id: id }).compact
    end

    def value_to_h(v)
      if v.is_a?(Array)
        v.map do |item|
          if item.is_a?(Chronicle::Serialization::Record)
            item.to_h
          else
            item
          end
        end
      elsif v.is_a?(Chronicle::Serialization::Record)
        v.to_h
      else
        v
      end
    end
  end
end
