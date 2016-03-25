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
      let(:sql) { "alter table `users` drop `foo`" }

      it { is_expected.to receive(:sh).with(/pt.online.schema.change.*[-]u.*[-]h.*[-]p.*alter.*drop.*foo.*execute.D.#{$db_name.gsub("_", ".")}.t.users/) }
    end
  end
end
