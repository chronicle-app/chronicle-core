module Chronicle::Utils
  module Hash
    def self.flatten_keys(hash)
      hash.each_with_object({}) do |(k, v), h|
        if v.is_a? Hash
          flatten_hash(v).map do |h_k, h_v|
            h["#{k}.#{h_k}".to_sym] = h_v
          end
        else 
          h[k] = v
        end
      end
    end
  end
end
