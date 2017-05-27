# TestJSON

## What I Want To Test

* I'm not sure how what the behavior is when saving or updating JSON(B) arrays with JSON objects in a SQL environment using Elixir.
* If I wanted to write a SQL trigger that checks this array for JSON array for certain JSON objects.

## Todo

- [ ] Take a screenshot of the log emitted with saving and updating a JSON array with objects.
- [ ] Write a SQL trigger that ensures a certain schema for certain JSON objects.
- [ ] Map the SQL trigger to an Ecto.Changeset callback so that the Ecto.Changeset returns an error provided by the SQL trigger.

## Related Links I Found Useful

* https://blog.hagander.net/json-field-constraints-228/
