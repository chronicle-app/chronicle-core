module Chronicle::Schema
  class Raw < Chronicle::Schema::Base
    TYPE = 'raw'.freeze

    def to_h
      @properties
    end
  end
end