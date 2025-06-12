class HomeController < ApplicationController
  def index
    # Assuming these instance variables are already populated from your Firebase logic
    # For example:
    @barang_masuk_items = BarangMasukFirebaseService.all
    @barang_keluar_items = BarangKeluarFirebaseService.all
    @stok_barang_items = StokBarangFirebaseService.all
    @users = UserFirebaseService.all

    # Ensure your Firebase fetching logic for these variables is in place
    # If they are simple hashes, you might need item['quantity'] instead of item.quantity

    # Calculate statistics
    @total_masuk_quantity = @barang_masuk_items.sum { |item| item.quantity.to_i rescue 0 }
    @total_keluar_quantity = @barang_keluar_items.sum { |item| item.quantity.to_i rescue 0 }
    @total_stok_quantity = @stok_barang_items.sum { |item| item.stokTersedia.to_i rescue 0 }

    # Note: @users data is no longer displayed on the home page,
    # so you might remove its fetching from here if not used elsewhere on this page.
  end
end
