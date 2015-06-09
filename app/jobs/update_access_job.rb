class UpdateAccessJob
  @queue = :updates
  @pids = []

  # This method takes the PID of a collection and iterates through each of the
  # members updating their visibility. If the work that is being updated is a
  # collection it calls this method recursively until all subcollections and
  # items in those collections and the root collection have been updated.
  def self.perform(collection, visibility)
    @pids << collection
    @visibility = visibility

    puts @pids
    while @pids.length > 0
      puts "PIDs: #{@pids}"
      item = ActiveFedora::Base.find(@pids.pop)
      puts "class: #{item.class}"

      if item.class.name == "Collection" then
        item.members.each do |member|
          @pids << member.pid
        end
      end

      if ["Text", "Video", "Audio", "Image", "CaseGenericWork"].include? item.class.name then
        item.generic_file_ids.each do |id|
          @pids << id
        end
      end

      puts "PIDs: #{@pids}"
      item.visibility = @visibility
      item.save!
      item.update_index
    end
  end

end
