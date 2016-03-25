require 'spec_helper'

RSpec.describe PerconaAr::Migration do
  let(:migration) { described_class.new }

  describe "#connection" do
    it "is a Percona::Connection" do
      expect(migration.connection.class).to eq PerconaAr::Connection
    end
  end
end
