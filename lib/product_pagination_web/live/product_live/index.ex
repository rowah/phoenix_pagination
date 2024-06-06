defmodule ProductPaginationWeb.ProductLive.Index do
  use ProductPaginationWeb, :live_view

  alias ProductPagination.Catalog
  alias ProductPagination.Catalog.Product

  @impl true
  def mount(params, _session, socket) do
    %{
      entries: products,
      total_entries: total_entries,
      total_pages: total_pages,
      page_number: page_number
    } = Catalog.paginate_products(params)

    {:ok,
     socket
     |> assign(:products, products)
     |> assign(:total_entries, total_entries)
     |> assign(:total_pages, total_pages)
     |> assign(:page_number, page_number)
     |> stream(:products, products)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    %{
      entries: products,
      total_entries: total_entries,
      total_pages: total_pages,
      page_number: page_number
    } = Catalog.paginate_products(params)

    {:noreply,
     socket
     |> assign(:products, products)
     |> assign(:total_entries, total_entries)
     |> assign(:total_pages, total_pages)
     |> assign(:page_number, page_number)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product")
    |> assign(:product, Catalog.get_product!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product")
    |> assign(:product, %Product{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Products")
    |> assign(:product, nil)
  end

  @impl true
  def handle_info({ProductPaginationWeb.ProductLive.FormComponent, {:saved, product}}, socket) do
    {:noreply, stream_insert(socket, :products, product)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Catalog.get_product!(id)
    {:ok, _} = Catalog.delete_product(product)

    {:noreply, stream_delete(socket, :products, product)}
  end
end
