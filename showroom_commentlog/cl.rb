require "oj"
require "curb"
require "pry"

room_url_key = ARGV[0]
response = Curl.get("https://www.showroom-live.com/api/room/status?room_url_key=#{room_url_key}")
room_id = Oj.load(response.body)["room_id"]
logged_comments = {}

loop do
  response = Curl.get("https://www.showroom-live.com/api/live/comment_log?room_id=#{room_id}")

  json = Oj.load(response.body)
  comment_log = json["comment_log"]

  # Register comments in logged_comments hash
  # This will help filter display the comments
  # that haven't already been displayed
  
  if logged_comments.empty?
    # Register all the comments
    comment_log.each do |comment|
      unique_key = "#{comment["created_at"]}.#{comment["user_id"]}"
      logged_comments[unique_key] = comment
    end

    comments = comment_log.map do |comment|
      "[ #{Time.at(comment["created_at"]).strftime("%Y-%m-%d %p%I:%M:%S")} ] #{comment["name"]}: #{comment["comment"]}"
    end.reverse

    puts comments
  else
    # Select only new comments
    unlogged_comments = comment_log.select do |comment|
      unique_key = "#{comment["created_at"]}.#{comment["user_id"]}"
      logged_comments[unique_key] == nil
    end

    if unlogged_comments.any?
      # Print unlogged comments to terminal
      comments = unlogged_comments.map do |comment|
        "[ #{Time.at(comment["created_at"]).strftime("%Y-%m-%d %p%I:%M:%S")} ] #{comment["name"]}: #{comment["comment"]}"
      end.reverse

      puts comments

      # Then log the unlogged comments into cache
      unlogged_comments.each do |comment|
        unique_key = "#{comment["created_at"]}.#{comment["user_id"]}"
        logged_comments[unique_key] = comment
      end
    end # unlogged_comments.any?
  end # logged_comments.empty?

  # sleep(2)
end
