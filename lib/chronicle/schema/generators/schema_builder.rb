module Chronicle::Schema::Generators
  # a DSL for adapting a schema from schema.org
  class SchemaBuilder
    def initialize(base_schema_filename)
      @base_schema_filename = base_schema_filename
    end

    def include_class(name, &block)
      klass = SchemaClass.new(name)
      klass.instance_eval(&block) if block_given?
      @classes << klass
    end

    def include_property(name, &block)
      prop = SchemaProperty.new(name, &block)
      klass.instance_eval(&block) if block_given?
      @properties << prop
    end

  end

  class SchemaClass
    attr_accessor :name, :superclass, :domains_of

    def initialize(name)
      @name = name
      @domains_of = []
    end

    def domain_of(property)
      @domains_of << property
    end
  end

  class SchemaProperty
    attr_accessor :name, :type, :range, :comment, :max_cardinality, :min_cardinality

    def initialize(name, type, range, comment, max_cardinality, min_cardinality)
      @name = name
      @type = type
      @range = range
      @comment = comment
      @max_cardinality = max_cardinality
      @min_cardinality = min_cardinality
    end
  end

end
