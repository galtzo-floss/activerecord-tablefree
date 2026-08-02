module ActiveRecord::Tablefree
  class Connection < ActiveRecord::ConnectionAdapters::AbstractAdapter
    def initialize
      @connection = Object.new # The Raw Connection
      @owner = nil
      @instrumenter = ActiveSupport::Notifications.instrumenter
      @logger = Object.new
      @config = Object.new
      @pool = nil
      @schema_cache = ActiveRecord::Tablefree::SchemaCache.new
      @quoted_column_names, @quoted_table_names = {}, {}
      @visitor = Object.new
      @lock = Object.new
      @prepared_statements = false
    end

    def quote_table_name(*_args)
      ""
    end

    def quote_column_name(*_args)
      ""
    end

    def substitute_at(*_args)
      nil
    end

    # Fixes Issue #17. https://github.com/softace/activerecord-tablefree/issues/17
    # The following method is from the ActiveRecord gem:
    #   /lib/active_record/connection_adapters/abstract/database_statements.rb .
    # Sanitizes the given LIMIT parameter in order to prevent SQL injection.
    #
    # The +limit+ may be anything that can evaluate to a string via #to_s. It
    # should look like an integer, or a comma-delimited list of integers, or
    # an Arel SQL literal.
    #
    # Returns Integer and Arel::Nodes::SqlLiteral limits as is.
    # Returns the sanitized limit parameter, either as an integer, or as a
    # string which contains a comma-delimited list of integers.
    def sanitize_limit(limit)
      if limit.is_a?(Integer) || limit.is_a?(Arel::Nodes::SqlLiteral)
        limit
      elsif limit.to_s.include?(",")
        Arel.sql limit.to_s.split(",").map { |i| Integer(i) }.join(",")
      else
        Integer(limit)
      end
    end

    # Called by bound_attributes in /lib/active_record/relation/query_methods.rb
    # Returns a SQL string with the from, join, where, and having clauses,
    #   in addition to the limit and offset.
    def combine_bind_parameters(**_args)
      ""
    end

    def lookup_cast_type_from_column(*_args)
      @_cast_type ||= ActiveRecord::Tablefree::CastType.new
    end

    def current_transaction
      @_current_transaction ||= ActiveRecord::Tablefree::Transaction.new
    end

    def execute(*_args)
      {}
    end

    # This is used in the StatementCache object.
    def cacheable_query(arel) # :nodoc:
      ActiveRecord::Tablefree::StatementCache.partial_query visitor, arel.ast, collector
    end
  end
end
