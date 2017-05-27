defmodule TestJSON.ShoppingListTest do
  use ExUnit.Case
  alias TestJSON.ShoppingList
  # doctest TestJSON

  describe "TestJSON.ShoppingList.changeset/2" do
    test "validates changeset presence of json items array" do
      shopping_list = %{
        "items" => [
          %{"name" => "mushroom", "type" => "food"},
          %{"name" => "EX大衆 2017年6月号", "type" => "magazine"},
          %{"name" => "toothpaste", "type" => "toiletries"}
        ]
      }

      changeset = ShoppingList.changeset(%ShoppingList{}, shopping_list)

      assert changeset.valid?
    end

    test "changeset is invalid when items json array is not present" do
      shopping_list = %{"items" => nil }

      changeset = ShoppingList.changeset(%ShoppingList{}, shopping_list)

      refute changeset.valid?
    end

    # The field call within the schema ... do block probably
    # reinforces the type of the field

    test "change is invalid when items field is not a list" do
      shopping_list = %{"items" => "す"}

      changeset = ShoppingList.changeset(%ShoppingList{}, shopping_list)

      refute changeset.valid?
    end

    test "change is invalid when items field is not a list of maps" do
      shopping_list = %{"items" => ["す","す","す","す"]}

      changeset = ShoppingList.changeset(%ShoppingList{}, shopping_list)

      refute changeset.valid?
    end
  end
end
