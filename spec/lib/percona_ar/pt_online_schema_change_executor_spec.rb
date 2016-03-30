require 'spec_helper'

RSpec.describe PerconaAr::PtOnlineSchemaChangeExecutor do
  describe "#call" do

    let(:lib) { described_class.new(sql) }

    after { lib.call }
    subject { lib }

    context "when sql does not have alter statement" do
      let(:sql) { "SELECT * FROM `USERS`" }

      it { is_expected.not_to receive(:sh) }
    end

    context "when sql has alter statement" do
      let(:sql) { "alter table `users` `foo` `bar` varchar(36)" }
      it { is_expected.to receive(:sh).with(/pt.online.schema.change.*[-]u.*[-]h.*[-]p.*alter.*foo.*execute.D.#{$db_name.gsub("_", ".")}.t.users/) }

    end
    context "when sql has alter statement with DROP but no column" do
      let(:sql) { "alter table `users` drop `foo`" }

      it "adds 'COLUMN' to drop statement in order to be valid for percona" do
        is_expected.to receive(:sh).with(/alter.*DROP COLUMN..foo/)
      end
    end

    context"when sql has alter statement with DROP and column specification" do
      let(:sql) { "alter table `users` drop column `foo`" }

      it "leaves sql unchanged" do
        is_expected.to receive(:sh).with(/alter.*drop column..foo/)
      end
    end
  end
end
