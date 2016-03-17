%{
  configs: [
    %{
      name: "default",
      files: %{
        included: ["lib/", "web/"],
        excluded: []
      },
      checks: [
        {Credo.Check.Consistency.TabsOrSpaces},

        # For some checks, like AliasUsage, you can only customize the priority
        # Priority values are: `low, normal, high, higher`
        {Credo.Check.Design.AliasUsage, priority: :low},

        # For others you can also set parameters
        {Credo.Check.Readability.MaxLineLength, priority: :low, max_length: 80},

        # You can also customize the exit_status of each check.
        # If you don't want TODO comments to cause `mix credo` to fail, just
        # set this value to 0 (zero).
        {Credo.Check.Design.TagTODO, exit_status: 2},

        # There are two ways of deactivating a check:
        # 1. deleting the check from this list
        # 2. putting `false` as second element (to quickly "comment it out"):
        {Credo.Check.Design.TagFIXME, false},

        # ... several checks omitted for readability ...
      ]
    }
  ]
}
