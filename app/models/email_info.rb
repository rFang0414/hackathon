class EmailInfo < ActiveRecord::Base
    # def self.import(file)
    #   file = Roo::Excel.new(file.path)
    #   file.row(1)[0]

    #   header = file.row(1)

    #   header = spreadsheet.row(1)
      
    #   (2..file.last_row).each do |i|
    #     row = Hash[[header, file.row(i)].transpose]
    #     email_info = find_by_id(row["id"]) || new
    #     email_info.attributes = row.to_hash.slice(*accessible_attributes)
    #     email_info.save!
    #     end
    # end

    # def self.open_spreadsheet(file)
    #   case File.extname(file.original_filename)
    #   when '.csv' then Csv.new(file.path, nil, :ignore)
    #   when '.xls' then Excel.new(file.path, nil, :ignore)
    #   when '.xlsx' then Excelx.new(file.path, nil, :ignore)
    #   else raise "Unknown file type: #{file.original_filename}"
    #   end
    # end

end


