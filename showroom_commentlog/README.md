# Showroom.CommentLog

## What I Want To Test

* Find out the polling interval limit of comments in a stream since thats what the code seems to do
  when pulling new comments to show (with Backbone Marionette) (instead of using Websockets) 
* Try out the Stream Module in Elixir when processing for new comments. The naive Ruby implementation
  that I made lags and I think its mostly likely because the current implementation eagerly fetches
  new comments and does some processing on it for new comments. You can view this within the cl.rb
  file
* ~~_Maybe_ try GenStage as a possible solution~~ Way too complex for use case ...?

## Todo

- [x] Setup dependencies like Poison
- [x] Write module that fetches for new comments
- [x] Write module that filters for new comments using the Stream module
- [ ] Test to see if it actually works

## How To Run

`iex -S mix run bin/track.exs`

An anonymous function wraps what needs to be run to start tracking the comment log of a SHOWROOM livestream which is assigned to a variable called `track`

Here is how you correctly invoke the `track` function. Given a url to a livestream `https://www.showroom-live.com/48_NAKAI_RIKA`, you take the room_url_key parameter which is `48_NAKAI_RIKA` and pass it into the function.
```elixir
# We want to track https://www.showroom-live.com/48_NAKAI_RIKA
# so in this case, the room_url_key is 48_NAKAI_RIKA

track.("48_NAKAI_RIKA")
```


## Related Links I Found Useful

* https://hexdocs.pm/elixir/Stream.html
