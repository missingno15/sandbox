# SrComments

## What I Want To Test

* Find out the polling interval limit of comments in a stream since thats what the code seems to do
  when pulling new comments to show (with Backbone Marionette) (instead of using Websockets) 
* Try out the Stream Module in Elixir when processing for new comments. The naive Ruby implementation
  that I made lags and I think its mostly likely because the current implementation eagerly fetches
  new comments and does some processing on it for new comments
* _Maybe_ try GenStage as a possible solution

## Todo

- [x] Setup dependencies like Poison
- [ ] Write module that fetches for new comments
- [ ] Write module that filters for new comments using the Stream module

## Related Links I Found Useful

* https://hexdocs.pm/elixir/Stream.html
