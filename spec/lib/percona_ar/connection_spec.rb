require 'spec_helper'

RSpec.describe PerconaAr::Connection do
  let!(:lib) { described_class.new(ActiveRecord::Base.connection) }
  let(:executor) { PerconaAr::PtOnlineSchemaChangeExecutor }

  before do
    allow(executor).to receive(:new) { double(:call => "") }
    allow_any_instance_of(ActiveRecord::ConnectionAdapters::Mysql2Adapter).
      to receive(:execute)
  end

  it "raises an error for unsupported methods" do
    expect { lib.create_table(:foo) }.to raise_error(
      "This is not implemented with the percona tool, please use a standard migration"
    )
  end

  describe "#execute" do
    it "uses percona tool when sql is an alter statement" do
      sql = "ALTER TABLE `users` drop column `foo`"
      expect(executor).to receive(:new).with(sql)
      lib.execute(sql)
    end

    it "uses ActiveRecord when sql is not an alter statement" do
      sql = "SHOW FIELDS FOR users"
      expect(executor).not_to receive(:new)
      lib.execute(sql)
    end
  end
end
