require 'spec_helper'
require_relative '../../pantry_ec2_resized_event_handler/pantry_ec2_resized_event_handler'

describe Wonga::Daemon::PantryEc2ResizedEventHandler do
  let(:api_client) { instance_double('Wonga::Daemon::PantryApiClient').as_null_object }
  let(:config) {
    {
      "pantry" => {
        "api_key" => "some_api_key",
        "request_timeout" => 10,
        "url" => "http://some.url"
      }
    }
  }
  let(:logger) { instance_double('Logger').as_null_object }
  let(:message) {
    {
      "name" => "some-name",
      "domain" => "some.domain",
      "id" => 42,
      "user_id" => 1
    }
  }

  subject { described_class.new(api_client,logger) }

  it_behaves_like "handler"

  it "updates Pantry using PantryApiClient" do
    expect(api_client).to receive(:send_put_request).with(
      "/api/ec2_instances/42",
      {
        "name" => "some-name",
        "domain" => "some.domain",
        "id" => 42,
        "user_id" => 1,
        :event => :resized
      }
    )
    subject.handle_message(message)
  end
end

