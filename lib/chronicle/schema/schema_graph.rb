require 'tsort'

module Chronicle::Schema
  # Represents a RDF graph as a DAG of classes and their properties, built
  # from a TTL string
  class SchemaGraph
    include TSort

    attr_accessor :classes, :properties, :datatypes, :version

    def initialize
      # FIXME: This should be a configuration option
      @default_prefix = 'https://schema.org/'
      @classes = []
      @properties = []
      @datatypes = []
    end

    def self.build_from_json(json)
      graph = new
      graph.version = json['version']
      json['classes'].each do |class_data|
        id = graph.id_to_identifier(class_data['id'])
        graph.add_class(id).tap do |klass|
          klass.comment = class_data['comment']
          klass.subclass_ids = class_data['subclass_ids']
        end
      end
      json['properties'].each do |property_data|
        id = graph.id_to_identifier(property_data['id'])
        graph.add_property(id).tap do |property|
          property.comment = property_data['comment']
          property.domain = property_data['domain']
          property.range = property_data['range']
        end
      end
      graph.build_references!
      graph
    end

    def pretty_print(pp)
      pp.text('SchemaGraph')
      pp.nest(2) do
        pp.breakable
        pp.text("Num classes: #{classes.size}")
      end
    end

    def inspect
      "#<SchemaGraph:#{object_id}>"
    end

    def to_h
      {
        version: @version,
        classes: classes.map(&:to_h),
        properties: properties.map(&:to_h)
      }
    end

    def build_references!
      @classes.each do |klass|
        klass.subclasses = klass.subclass_ids.map { |id| find_class_by_id(id) }
        klass.superclasses = @classes.select { |c| c.subclass_ids.include?(klass.id) }
      end

      @properties.each do |property|
        property.domain.each do |class_id|
          klass = find_class_by_id(class_id)
          klass.properties << property if klass
        end

        # prune unknown range values from property
        property.range = property.range.select do |range|
          find_class_by_id(range)
        end
      end
    end

    def find_class_by_id(id)
      @classes.find { |c| c.id == id }
    end

    def find_class(identifier)
      @classes.find { |c| c.id == identifier_to_uri(identifier) }
    end

    def find_property(identifier)
      @properties.find { |p| p.id == identifier_to_uri(identifier) }
    end

    def add_class(identifier)
      find_class(identifier) || add_new_type(identifier)
    end

    def add_property(identifier)
      find_property(identifier) || add_new_property(identifier)
    end

    def id_to_identifier(id)
      id.gsub(@default_prefix, '')
    end

    def identifier_to_uri(identifier)
      "#{@default_prefix}#{identifier}"
    end

    private

    def add_new_type(identifier)
      new_type = SchemaType.new(identifier_to_uri(identifier)) do |t|
        t.namespace = @default_prefix
      end

      @classes << new_type unless @classes.include?(new_type)
      new_type
    end

    def add_new_property(identifier)
      new_property = SchemaProperty.new(identifier_to_uri(identifier))
      @properties << new_property unless @properties.include?(new_property)
      new_property
    end

    def tsort_each_node(&block)
      @classes.each do |node|
        block.call(node)
      end
    end

    def tsort_each_child(node, &)
      puts "tsort_each_child called with node: #{node&.id}"
      node&.subclasses&.each(&)
    end
  end
end
