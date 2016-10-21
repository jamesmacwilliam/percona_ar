require 'spec_helper'

RSpec.describe PerconaAr::QueryBuilder do
  let(:builder) { described_class.new }
  subject(:executor) { PerconaAr::PtOnlineSchemaChangeExecutor }
  before { allow_any_instance_of(executor).to receive(:sh) }

  describe "#execute" do
    after { builder.execute }

    context "many tables" do
      before do
        builder.add "alter table `users` `foo` `bar` varchar(36)"
        builder.add "alter table `users2` `foo` `bar` varchar(36)"
      end

      it { is_expected.not_to receive(:new).
           and_call_original.twice }
    end

    context "many updates to the same table" do
      before do
        builder.add "alter table `users` `foo` `bar` varchar(36)"
        builder.add "alter table `users` `foos` `bar` varchar(36)"
      end

      it { is_expected.not_to receive(:new).
           and_call_original.once }
    end
  end

  describe "#add" do
    after { builder.add(sql).execute }
    before { allow_any_instance_of(executor).to receive(:sh) }

    context "when sql does not have alter statement" do
      let(:sql) { "SELECT * FROM `USERS`" }

      it { is_expected.not_to receive(:new) }
    end

    context "when sql has alter statement" do
      let(:sql) { "alter table `users` `foo` `bar` varchar(36)" }
      it { is_expected.to receive(:new).
           with("users", /foo.*bar/, ActiveRecord::Base.connection).
           and_call_original }

    end
    context "when sql has alter statement with DROP but no column" do
      let(:sql) { "alter table `users` drop `foo`" }

      it "adds 'COLUMN' to drop statement in order to be valid for percona" do
        is_expected.to receive(:new).
          with("users", /DROP COLUMN..foo/, ActiveRecord::Base.connection).
          and_call_original
      end
    end

    context"when sql has alter statement with DROP and column specification" do
      let(:sql) { "alter table `users` drop column `foo`" }

      it "leaves sql unchanged" do
        is_expected.to receive(:new).
          with("users", /drop column..foo/, ActiveRecord::Base.connection).
          and_call_original
      end
    end
  end
end
