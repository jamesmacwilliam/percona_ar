require 'spec_helper'

RSpec.describe PerconaAr::SqlParser do
  describe "#parse" do
    subject(:parse) { described_class.parse(sql) }

    context "when sql does not have alter statement" do
      let(:sql) { "SELECT * FROM `USERS`" }

      it { expect{ parse }.to raise_error }
    end

    context "when sql has alter statement" do
      let(:sql) { "alter table `users` `foo` `bar` varchar(36)" }
      it { is_expected.to eq(table: "users", cmd: "`foo` `bar` varchar(36)") }

    end
    context "when sql has alter statement with DROP but no column" do
      let(:sql) { "alter table `users` drop `foo`" }

      it "adds 'COLUMN' to drop statement in order to be valid for percona" do
        is_expected.to eq(table: "users", cmd: "DROP COLUMN `foo`")
      end
    end

    context"when sql has alter statement with DROP and column specification" do
      let(:sql) { "alter table `users` drop column `foo`" }

      it "leaves sql unchanged" do
        is_expected.to eq(table: "users", cmd: "drop column `foo`")
      end
    end
  end
end
