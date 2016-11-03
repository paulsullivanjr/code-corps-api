defmodule CodeCorps.DonationGoalController do
  use CodeCorps.Web, :controller
  use JaResource

  import CodeCorps.Helpers.Query, only: [id_filter: 2]

  alias CodeCorps.DonationGoal

  plug :load_and_authorize_changeset, model: DonationGoal, only: [:create]
  plug :load_and_authorize_resource, model: DonationGoal, only: [:update, :delete]
  plug JaResource

  def filter(_conn, query, "id", id_list) do
    query |> id_filter(id_list)
  end

  def handle_create(_conn, attributes) do
    %DonationGoal{}
    |> DonationGoal.create_changeset(attributes)
    |> Repo.insert
  end

  def handle_update(_conn, record, attributes) do
    record
    |> DonationGoal.update_changeset(attributes)
    |> Repo.update
  end
end
