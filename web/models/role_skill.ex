defmodule CodeCorps.RoleSkill do
  use CodeCorps.Web, :model

  import CodeCorps.ModelHelpers

  schema "role_skills" do
    field :cat, :integer

    belongs_to :role, CodeCorps.Role
    belongs_to :skill, CodeCorps.Skill

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:cat, :role_id, :skill_id])
    |> validate_required([:role_id, :skill_id])
    |> validate_inclusion(:cat, cats)
    |> assoc_constraint(:role)
    |> assoc_constraint(:skill)
    |> unique_constraint(:role_id, name: :index_projects_on_role_id_skill_id)
  end

  def index_filters(query, params) do
    query |> id_filter(params)
  end

  defp cats do
    [1, 2, 3, 4, 5, 6]
  end
end
