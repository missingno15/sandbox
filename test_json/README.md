# TestJSON

## What I Want To Test

* I'm not sure how what the behavior is when saving or updating JSON(B) arrays with JSON objects in a SQL environment.
* If I wanted to write a SQL trigger that checks this array for JSON array for certain JSON objects 

## Todo

- [x] Take a screenshot of the log emitted with saving and updating a JSON array with objects.
- [ ] Write a SQL trigger that ensures a certain schema for certain JSON objects.
- [ ] Make it so that the corresponding Ecto.Changeset returns the error from the SQL trigger on update.

## Related Links I Found Useful

* https://blog.hagander.net/json-field-constraints-228/
