module SQLiteFunctions
  def connect
    super.tap do
      raw_connection.create_function("popularity", 2) do |func, count, weight|
        func.result = count.to_i * weight.to_i
      end

      raw_connection.create_function("recentness", 1) do |func, stamp|
        epoch = Time.parse(stamp.to_s).to_i
        func.result = ((epoch - 1_388_380_757) / 3600).to_i
      end

      raw_connection.create_function("ranking", 3) do |func, counts, stamp, weight|
        popularity = counts.to_i * weight.to_i
        recentness = ((Time.parse(stamp.to_s).to_i - 1_388_380_757) / 3600).to_i
        func.result = popularity + recentness
      end
    end
  end
end

ActiveSupport.on_load(:active_record_sqlite3adapter) do
  ActiveRecord::ConnectionAdapters::SQLite3Adapter.prepend(SQLiteFunctions)
end
