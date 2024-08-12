BEGIN
  -- Membuat temporary table untuk agregasi pesanan bulanan berdasarkan produk
  CREATE TEMP TABLE report_monthly_orders_product_agg AS
  SELECT
      oi.product_id,
      EXTRACT(YEAR FROM o.created_at) AS year,
      EXTRACT(MONTH FROM o.created_at) AS month,
      COUNT(oi.order_id) AS total_orders,
      SUM(oi.sale_price) AS total_sales,
      u.country,
      u.traffic_source
  FROM
      `bigquery-public-data.thelook_ecommerce.orders` o
  JOIN
      `bigquery-public-data.thelook_ecommerce.order_items` oi
  ON
      o.order_id = oi.order_id
  JOIN
      `bigquery-public-data.thelook_ecommerce.users` u
  ON
      o.user_id = u.id
  GROUP BY
      oi.product_id, year, month, u.country, u.traffic_source
  ORDER BY
      year, month, total_sales DESC;

  -- Menampilkan data dari temporary table
  SELECT * FROM report_monthly_orders_product_agg;
END;
