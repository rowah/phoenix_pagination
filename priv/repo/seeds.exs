# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ProductPagination.Repo.insert!(%ProductPagination.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ProductPagination.Catalog

products =
  Enum.map(1..100, fn n ->
    %{title: "Product #{n}", description: "Product #{n} description", price: "#{n}00.0", views: n}
  end)

for product <- products do
  Catalog.create_product(product)
  :timer.sleep(5000)
end
