CREATE DATABASE avitus;
\connect avitus;

CREATE OR REPLACE FUNCTION auto_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ language 'plpgsql';

/*----------------------------------------------------------------------------*/
/*                                   TABLES                                   */
/*----------------------------------------------------------------------------*/

CREATE TABLE contact_info(
   contact_id UUID PRIMARY KEY,
   created_at TIMESTAMPTZ DEFAULT NOW(),
   updated_at TIMESTAMPTZ DEFAULT NOW(),
   author_id UUID,
   first_name VARCHAR(255),
   last_name VARCHAR(255),
   email VARCHAR(255),
   phone_number VARCHAR(255),
   address_1 VARCHAR(255),
   address_2 VARCHAR(255),
   city VARCHAR(255),
   state VARCHAR(255),
   zip_code VARCHAR(255)
);
CREATE TRIGGER contact_info_updated_at BEFORE UPDATE
  ON contact_info FOR EACH ROW EXECUTE PROCEDURE
  auto_updated_at();

CREATE TABLE user_account(
  user_id UUID PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  author_id UUID,
  encrypted_password VARCHAR(255),
  organization_id UUID,
  default_shipping_profile_id UUID,
  contact_id UUID
);
CREATE TRIGGER user_account_updated_at BEFORE UPDATE
  ON user_account FOR EACH ROW EXECUTE PROCEDURE
  auto_updated_at();

CREATE TABLE user_permission(
  user_permission_id UUID PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  author_id UUID,
  /*
    PRODUCT,
    ORDER_FORM,
    FULFILLMENT,
    MASTER_LOG,
    USER,
    PERMISSION,
    ORGANIZATION
  */
  permission_type VARCHAR(255),
  user_id UUID
);
CREATE TRIGGER user_permission_updated_at BEFORE UPDATE
  ON user_permission FOR EACH ROW EXECUTE PROCEDURE
  auto_updated_at();

CREATE TABLE organization(
  organization_id UUID PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  author_id UUID,
  organization_name VARCHAR(255),
  /*
    INTERNAL,
    DISTRIBUTOR,
    CUSTOMER
  */
  organization_type VARCHAR(255),
  contact_user_id UUID,
  contact_id UUID
);
CREATE TRIGGER organization_updated_at BEFORE UPDATE
  ON organization FOR EACH ROW EXECUTE PROCEDURE
  auto_updated_at();

CREATE TABLE shipping_profile(
  shipping_profile_id UUID PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  author_id UUID,
  user_id UUID,
  contact_id UUID
);
CREATE TRIGGER shipping_profile_updated_at BEFORE UPDATE
  ON shipping_profile FOR EACH ROW EXECUTE PROCEDURE
  auto_updated_at();

CREATE TABLE product(
  ref_id VARCHAR(255) PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  author_id UUID,
  description VARCHAR(255),
  /*
    CLINICAL,
    DEMO
  */
  product_type VARCHAR(255)
);
CREATE TRIGGER product_updated_at BEFORE UPDATE
  ON product FOR EACH ROW EXECUTE PROCEDURE
  auto_updated_at();

CREATE TABLE lot(
  external_lot_id VARCHAR(255) PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  author_id UUID,
  part_number VARCHAR(255),
  use_by_date DATE,
  initial_quantity SMALLINT,
  product_ref_id VARCHAR(255)
);
CREATE TRIGGER lot_updated_at BEFORE UPDATE
  ON lot FOR EACH ROW EXECUTE PROCEDURE
  auto_updated_at();

CREATE TABLE shipping_order(
  order_id UUID PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  author_id UUID,
  request_date DATE,
  purchase_order_number VARCHAR(255),
  internal_comments VARCHAR(255),
  external_comments VARCHAR(255),
  tracking_number VARCHAR(255),
  fulfillment_date DATE,
  hand_carry_info VARCHAR(255),
  shipping_profile_id UUID,
  consignee_id UUID,
  fulfilled_by_id UUID
);
CREATE TRIGGER shipping_order_updated_at BEFORE UPDATE
  ON shipping_order FOR EACH ROW EXECUTE PROCEDURE
  auto_updated_at();

CREATE TABLE order_slice(
  slice_id UUID PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  author_id UUID,
  quantity SMALLINT,
  unit_price DECIMAL(10,2),
  order_id UUID,
  product_ref_id VARCHAR(255)
);
CREATE TRIGGER order_slice_updated_at BEFORE UPDATE
  ON order_slice FOR EACH ROW EXECUTE PROCEDURE
  auto_updated_at();

CREATE TABLE fulfillment_slice(
  slice_id UUID PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  author_id UUID,
  quantity SMALLINT,
  lot_id VARCHAR(255),
  order_id UUID
);
CREATE TRIGGER fulfillment_slice_updated_at BEFORE UPDATE
  ON fulfillment_slice FOR EACH ROW EXECUTE PROCEDURE
  auto_updated_at();

CREATE TABLE consignment_sale(
  consignment_sale_id UUID PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  author_id UUID,
  usage_date DATE,
  hospital VARCHAR(255),
  surgeon VARCHAR(255),
  case_id VARCHAR(255),
  consignee_id UUID
);
CREATE TRIGGER consignment_sale_updated_at BEFORE UPDATE
  ON consignment_sale FOR EACH ROW EXECUTE PROCEDURE
  auto_updated_at();

CREATE TABLE consignment_sale_slice(
  slice_id UUID PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  author_id UUID,
  quantity SMALLINT,
  unit_price DECIMAL(10,2),
  lot_id VARCHAR(255),
  sale_id UUID
);
CREATE TRIGGER consignment_sale_slice_updated_at BEFORE UPDATE
  ON consignment_sale_slice FOR EACH ROW EXECUTE PROCEDURE
  auto_updated_at();

CREATE TABLE field_transfer(
  field_transfer_id UUID PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  author_id UUID,
  transfer_date DATE,
  comment VARCHAR(255),
  src_consignee_id UUID,
  dst_consignee_id UUID
);
CREATE TRIGGER field_transfer_updated_at BEFORE UPDATE
  ON field_transfer FOR EACH ROW EXECUTE PROCEDURE
  auto_updated_at();

CREATE TABLE field_transfer_slice(
  slice_id UUID PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  author_id UUID,
  quantity SMALLINT,
  lot_id VARCHAR(255),
  transfer_id UUID
);
CREATE TRIGGER field_transfer_slice_updated_at BEFORE UPDATE
  ON field_transfer_slice FOR EACH ROW EXECUTE PROCEDURE
  auto_updated_at();

CREATE TABLE return_materials_authorization(
  rma_id UUID PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  author_id UUID,
  /*
    CONSIGNMENT,
    SALE
  */
  return_type VARCHAR(255),
  request_date DATE,
  process_date DATE,
  reason VARCHAR(255),
  returner_id UUID
);
CREATE TRIGGER return_materials_authorization_updated_at BEFORE UPDATE
  ON return_materials_authorization FOR EACH ROW EXECUTE PROCEDURE
  auto_updated_at();

CREATE TABLE return_slice(
  slice_id UUID PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  author_id UUID,
  return_quantity SMALLINT,
  restock_quantity SMALLINT,
  ifu VARCHAR(255),
  rev VARCHAR(255),
  mrr VARCHAR(255),
  lot_id VARCHAR(255),
  return_id UUID
);
CREATE TRIGGER return_slice_updated_at BEFORE UPDATE
  ON return_slice FOR EACH ROW EXECUTE PROCEDURE
  auto_updated_at();


/*----------------------------------------------------------------------------*/
/*                               RELATIONSHIPS                                */
/*----------------------------------------------------------------------------*/

ALTER TABLE contact_info
  ADD FOREIGN KEY (author_id) REFERENCES user_account(user_id);

ALTER TABLE user_account
  ADD FOREIGN KEY (author_id) REFERENCES user_account(user_id),
  ADD FOREIGN KEY (organization_id) REFERENCES organization(organization_id),
  ADD FOREIGN KEY (default_shipping_profile_id) REFERENCES shipping_profile(shipping_profile_id),
  ADD FOREIGN KEY (contact_id) REFERENCES contact_info(contact_id);

ALTER TABLE user_permission
  ADD FOREIGN KEY (author_id) REFERENCES user_account(user_id),
  ADD FOREIGN KEY (user_id) REFERENCES user_account(user_id);

ALTER TABLE organization
  ADD FOREIGN KEY (author_id) REFERENCES user_account(user_id),
  ADD FOREIGN KEY (contact_user_id) REFERENCES user_account(user_id),
  ADD FOREIGN KEY (contact_id) REFERENCES contact_info(contact_id);

ALTER TABLE shipping_profile
  ADD FOREIGN KEY (author_id) REFERENCES user_account(user_id),
  ADD FOREIGN KEY (user_id) REFERENCES user_account(user_id),
  ADD FOREIGN KEY (contact_id) REFERENCES contact_info(contact_id);

ALTER TABLE product
  ADD FOREIGN KEY (author_id) REFERENCES user_account(user_id);

ALTER TABLE lot
  ADD FOREIGN KEY (author_id) REFERENCES user_account(user_id),
  ADD FOREIGN KEY (product_ref_id) REFERENCES product(ref_id);

ALTER TABLE shipping_order
  ADD FOREIGN KEY (author_id) REFERENCES user_account(user_id),
  ADD FOREIGN KEY (shipping_profile_id) REFERENCES shipping_profile(shipping_profile_id),
  ADD FOREIGN KEY (consignee_id) REFERENCES user_account(user_id),
  ADD FOREIGN KEY (fulfilled_by_id) REFERENCES user_account(user_id);

ALTER TABLE order_slice
  ADD FOREIGN KEY (author_id) REFERENCES user_account(user_id),
  ADD FOREIGN KEY (order_id) REFERENCES shipping_order(order_id),
  ADD FOREIGN KEY (product_ref_id) REFERENCES product(ref_id);

ALTER TABLE fulfillment_slice
  ADD FOREIGN KEY (author_id) REFERENCES user_account(user_id),
  ADD FOREIGN KEY (lot_id) REFERENCES lot(external_lot_id),
  ADD FOREIGN KEY (order_id) REFERENCES shipping_order(order_id);

ALTER TABLE consignment_sale
  ADD FOREIGN KEY (author_id) REFERENCES user_account(user_id),
  ADD FOREIGN KEY (consignee_id) REFERENCES user_account(user_id);

ALTER TABLE consignment_sale_slice
  ADD FOREIGN KEY (author_id) REFERENCES user_account(user_id),
  ADD FOREIGN KEY (lot_id) REFERENCES lot(external_lot_id),
  ADD FOREIGN KEY (sale_id) REFERENCES consignment_sale(consignment_sale_id);

ALTER TABLE field_transfer
  ADD FOREIGN KEY (author_id) REFERENCES user_account(user_id),
  ADD FOREIGN KEY (src_consignee_id) REFERENCES user_account(user_id),
  ADD FOREIGN KEY (dst_consignee_id) REFERENCES user_account(user_id);

ALTER TABLE field_transfer_slice
  ADD FOREIGN KEY (author_id) REFERENCES user_account(user_id),
  ADD FOREIGN KEY (lot_id) REFERENCES lot(external_lot_id),
  ADD FOREIGN KEY (transfer_id) REFERENCES field_transfer(field_transfer_id);

ALTER TABLE return_materials_authorization
  ADD FOREIGN KEY (author_id) REFERENCES user_account(user_id),
  ADD FOREIGN KEY (returner_id) REFERENCES user_account(user_id);

ALTER TABLE return_slice
  ADD FOREIGN KEY (author_id) REFERENCES user_account(user_id),
  ADD FOREIGN KEY (lot_id) REFERENCES lot(external_lot_id),
  ADD FOREIGN KEY (return_id) REFERENCES return_materials_authorization(rma_id);
