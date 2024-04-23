module Chronicle
  module Utils
    module HashUtils
      def self.flatten_hash(hash, parent_key = '', result = {})
        hash.each do |key, value|
          current_key = parent_key + (parent_key.empty? ? '' : '.') + key.to_s
          case value
          when Hash
            flatten_hash(value, current_key, result)
          when Array
            value.each_with_index do |item, index|
              if item.is_a?(Hash)
                flatten_hash(item, "#{current_key}[#{index}]", result)
              else
                result["#{current_key}[#{index}]".to_sym] = item
              end
            end
          else
            result[current_key.to_sym] = value
          end
        end
        result
      end
    end
  end
end
