require 'chronicle/utils/hash'

module Chronicle::Schema
  class Base
    attr_accessor(:id, :dedupe_on, :properties)

    def initialize(attributes = {})
      @properties = {}
      @dedupe_on = []
      assign_attributes(attributes) if attributes
    end

    def method_missing(method, *args)
      if method.to_s.end_with?("=")
        @properties[method.to_s.gsub("=", "").to_sym] = args.first
      else
        @properties[method]
      end
    end

    def assign_attributes(attributes)
      @properties.merge!(attributes)
    end

    def identifier_hash
      {
        id: @id,
        type: self.class::TYPE
      }.compact
    end

    def attributes
      @properties.reject { |k, v| associations.keys.include?(k) }.compact
    end

    def associations
      @properties.select do |k, v|
        if v.is_a?(Array)
          v.any? { |e| e.is_a?(Chronicle::Schema::Base) }
        else
          v.is_a?(Chronicle::Schema::Base)
        end
      end
    end

    def meta
      {
        dedupe_on: @dedupe_on.map{|d| d.map(&:to_s).join(",")}
      }
    end

    def to_h
      identifier_hash
        .merge(@properties)
        .merge({ meta: meta })
    end

    def to_h_flattened
      Chronicle::Utils::Hash.flatten_keys(to_h)
    end
  end
end

require_relative "activity"
require_relative "entity"
require_relative "raw"