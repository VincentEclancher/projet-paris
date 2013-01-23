class FileParse < ActiveRecord::Base
	set_table_name "file_parsing"
	set_primary_key "last_parse_date"
end