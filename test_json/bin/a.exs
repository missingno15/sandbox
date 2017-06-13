# run with
# `iex -S mix run bin/a.exs`
require IEx
alias TestJSON.{ShoppingList, Repo}
shopping_list = %{
  "items" => [
    %{"name" => "mushroom", "type" => "food"},
    %{"name" => "EX大衆 2017年6月号", "type" => "magazine"},
    %{"name" => "toothpaste", "type" => "toiletries"}
  ]
}

changeset = ShoppingList.changeset(%ShoppingList{}, shopping_list)

IEx.pry
