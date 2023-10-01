require 'chronicle/utils/hash_utils'

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
        # dedupe_on: @dedupe_on.map{|d| d.map(&:to_s).join(",")}
        dedupe_on: @dedupe_on
      }
    end

    def to_h
      @properties.transform_values do |v|
        # convert nested records to hashes
        if v.is_a?(Array)
          v.map do |e|
            if e.is_a?(Chronicle::Schema::Base)
              e.to_h
            else
              e
            end
          end
        elsif v.is_a?(Chronicle::Schema::Base)
          v.to_h
        else
          v
        end
      end
    end

    def to_h_flattened
      Chronicle::Utils::HashUtils.flatten_hash(to_h)
    end
  end
end

require_relative "activity"
require_relative "entity"
require_relative "raw"