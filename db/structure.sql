CREATE TABLE "carts" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "line_items" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "product_id" integer, "cart_id" integer, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL, "quantity" integer DEFAULT 1, "price" decimal(8,2), "order_id" integer);
CREATE INDEX "index_line_items_on_cart_id" ON "line_items" ("cart_id");
CREATE INDEX "index_line_items_on_product_id" ON "line_items" ("product_id");
CREATE TABLE "products" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "title" varchar, "description" text, "image_url" varchar, "price" decimal(8,2), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE TABLE "schema_migrations" ("version" varchar NOT NULL);
CREATE UNIQUE INDEX "unique_schema_migrations" ON "schema_migrations" ("version");
CREATE TABLE "orders" ("id" INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "name" varchar, "address" text, "email" varchar, "pay_type" varchar, "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
CREATE INDEX "index_line_items_on_order_id" ON "line_items" ("order_id");
INSERT INTO schema_migrations (version) VALUES ('20160425221522');

INSERT INTO schema_migrations (version) VALUES ('20160617033404');

INSERT INTO schema_migrations (version) VALUES ('20160617040151');

INSERT INTO schema_migrations (version) VALUES ('20160629015755');

INSERT INTO schema_migrations (version) VALUES ('20160630004803');

INSERT INTO schema_migrations (version) VALUES ('20160630151433');

INSERT INTO schema_migrations (version) VALUES ('20160803165719');

INSERT INTO schema_migrations (version) VALUES ('20160803165813');

