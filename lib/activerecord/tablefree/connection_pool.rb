module ActiveRecord::Tablefree
  # Minimal stand-in for ActiveRecord's connection pool. Newer ActiveRecord
  # (7.2+) reaches the connection through the pool for scoping, alias
  # tracking, and transactions.
  class ConnectionPool
    attr_reader :connection

    def initialize(connection)
      @connection = connection
    end

    def lease_connection
      connection
    end

    def with_connection(**)
      yield connection
    end

    def with_pool_transaction_isolation_level(*)
      yield
    end

    def schema_cache
      connection.schema_cache
    end
  end
end
