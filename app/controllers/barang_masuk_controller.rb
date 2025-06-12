class BarangMasukController < ApplicationController
  def index
    @barang_masuk_items = BarangMasukFirebaseService.all
    # This @barang_masuk_items will be an array of OpenStructs
    # You can iterate over them in your view:
    # <% @barang_masuk_items.each do |item| %>
    #   <%= item.namaBarang %>
    # <% end %>
  end

  def show
    @item = BarangMasukFirebaseService.find(params[:id])
    # Handle nil case if not found
  end

  def create
    # Example attributes from a form
    attributes = {
      namaBarang: params[:nama_barang],
      namaSupplier: params[:nama_supplier],
      nomorPO: params[:nomor_po],
      quantity: params[:quantity].to_i,
      tanggalMasuk: Date.current.strftime("%d %b %Y"),
      unit: params[:unit]
    }
    if BarangMasukFirebaseService.create(attributes)
      redirect_to barang_masuk_index_path, notice: "Item created successfully."
    else
      redirect_to new_barang_masuk_path, alert: "Failed to create item."
    end
  end
end
