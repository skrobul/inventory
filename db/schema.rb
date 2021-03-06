# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_190_413_112_054) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'allocations', force: :cascade do |t|
    t.date 'date'
    t.bigint 'purchase_id'
    t.integer 'quantity'
    t.index ['purchase_id'], name: 'index_allocations_on_purchase_id'
  end

  create_table 'categories', force: :cascade do |t|
    t.string 'name'
  end

  create_table 'items', force: :cascade do |t|
    t.string 'name'
    t.bigint 'category_id'
    t.index ['category_id'], name: 'index_items_on_category_id'
  end

  create_table 'purchases', force: :cascade do |t|
    t.date 'date'
    t.bigint 'retailer_id'
    t.bigint 'item_id'
    t.integer 'quantity'
    t.decimal 'unit_cost'
    t.index ['item_id'], name: 'index_purchases_on_item_id'
    t.index ['retailer_id'], name: 'index_purchases_on_retailer_id'
  end

  create_table 'retailers', force: :cascade do |t|
    t.string 'name'
  end

  add_foreign_key 'allocations', 'purchases'
  add_foreign_key 'items', 'categories'
  add_foreign_key 'purchases', 'items'
  add_foreign_key 'purchases', 'retailers'
end
