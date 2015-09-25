Deface::Override.new(virtual_path: "spree/admin/products/_form",
                     name: "add_bulk_discount_products_select",
                     insert_bottom: "[data-hook='admin_product_form_right']",
                     partial: "spree/admin/overrides/products/bulk_discount")