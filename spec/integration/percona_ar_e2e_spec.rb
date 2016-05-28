require 'spec_helper'

RSpec.describe "End to End" do
  let!(:executor) { PerconaAr::PtOnlineSchemaChangeExecutor.new("", "") }

  before do
    ActiveRecord::Migration.create_table :foos
    ActiveRecord::Migration.create_table :foos2
    allow(PerconaAr::PtOnlineSchemaChangeExecutor).
      to receive(:new) { executor }
  end

  after  do
    ActiveRecord::Migration.drop_table :foos
    ActiveRecord::Migration.drop_table :foos2
  end

  describe "when adding several columns from one table" do
    class ManyCols < PerconaAr::Migration
      def change
        add_column :foos, :bar, :text
        add_column :foos, :bat, :text
      end
    end

    it "only uses the pt-osc tool once for both columns" do
      expect(executor).to receive(:sh).once
      ManyCols.migrate :up
    end

  end

  describe "when adding columns from several tables" do
    class ManyTables < PerconaAr::Migration
      def change
        add_column :foos,  :bar, :text
        add_column :foos2, :bar , :text
      end
    end

    it "uses pt-osc tool once per table" do
      expect(executor).to receive(:sh).twice
      ManyTables.migrate :up
    end
  end
end
