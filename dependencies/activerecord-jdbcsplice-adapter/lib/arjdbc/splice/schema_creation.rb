module ArJdbc
  module Derby
    # @private
    class SchemaCreation < ::ActiveRecord::ConnectionAdapters::AbstractAdapter::SchemaCreation

      # @override
      def visit_AddForeignKey(o)
      end

      private

    end
  end

  def schema_creation
    SchemaCreation.new self
  end

end if ::ActiveRecord::ConnectionAdapters::AbstractAdapter.const_defined? :SchemaCreation