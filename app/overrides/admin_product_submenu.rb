Deface::Override.new(virtual_path: "spree/admin/shared/sub_menu/_product",
                     name: "add_bulk_discount_menu_tab",
                     insert_bottom: "[data-hook='admin_product_sub_tabs'], #sidebar-productgit [data-hook]",
                     text: "<%= tab :bulk_discounts %>")