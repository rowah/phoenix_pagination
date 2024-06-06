defmodule ProductPagination.Repo do
  use Ecto.Repo,
    otp_app: :product_pagination,
    adapter: Ecto.Adapters.Postgres
end
