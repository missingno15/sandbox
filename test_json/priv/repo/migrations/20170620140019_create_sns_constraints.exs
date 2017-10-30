defmodule TestJSON.Repo.Migrations.CreateSnsConstraints do
  use Ecto.Migration

  def change do
    execute """
    CREATE OR REPLACE FUNCTION twitter_json_compliant(items jsonb[]) RETURNS boolean AS $$
      DECLARE
        item jsonb; 
      BEGIN
        RAISE NOTICE 'items %', items;

        FOR item IN SELECT * FROM jsonb_array_elements(to_jsonb(items)) LOOP
          IF item->'sns_type' = 'twitter' THEN
            IF NOT item ?& ARRAY['sns_type', 'username'] AND NOT (SELECT COUNT(*) FROM jsonb_object_keys(item)) = 2 THEN
              RETURN FALSE;
            END IF; 
          END IF;
        END LOOP;
        
        RETURN TRUE;
      END;
    $$ LANGUAGE plpgsql;
    """

    create constraint(
      :shopping_list,
      "sns_constraint",
      check: "twitter_json_compliant(items)"
    )
  end
end
