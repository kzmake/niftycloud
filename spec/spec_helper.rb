require 'rspec'
require 'webmock/rspec'

require File.expand_path('../../lib/nifcloud', __FILE__)

RSpec.configure do |config|
  config.before(:all) do
    Nifcloud.endpoint = 'https://api.example.com'
    Nifcloud.access_key = 'ABC'
    Nifcloud.secret_key = '012'
  end
end

def load_fixture(name)
  File.new(File.dirname(__FILE__) + "/fixtures/#{name}.xml")
end

# GET
def stub_get(path, action, fixture, status_code=200)
  timestamp = Time.now.strftime("%Y%m%dT%H:%M:%SZ")
  stub_request(:get, "#{Nifcloud.endpoint}#{path}").
      with(query: {
          Action: action,
          Timestamp: timestamp,
          AccessKeyId: Nifcloud.access_key,
          Signature: Nifcloud::Signature.v0(Nifcloud.secret_key, "#{action}#{timestamp}"),
          SignatureVersion: '0',
      }).
      to_return(body: load_fixture(fixture), status: status_code)
end

def a_get(path, action)
  timestamp = Time.now.strftime("%Y%m%dT%H:%M:%SZ")
  a_request(:get, "#{Nifcloud.endpoint}#{path}").
      with(query: {
          Action: action,
          Timestamp: timestamp,
          AccessKeyId: Nifcloud.access_key,
          Signature: Nifcloud::Signature.v0(Nifcloud.secret_key, "#{action}#{timestamp}"),
          SignatureVersion: '0',
      })
end

# POST
def stub_post(path, fixture, status_code=200)
  stub_request(:post, "#{Nifcloud.endpoint}#{path}").
      with(headers: {'PRIVATE-TOKEN' => Nifcloud.secret_key}).
      to_return(body: load_fixture(fixture), status: status_code)
end

def a_post(path)
  a_request(:post, "#{Nifcloud.endpoint}#{path}").
      with(headers: {'PRIVATE-TOKEN' => Nifcloud.secret_key})
end

# PUT
def stub_put(path, fixture)
  stub_request(:put, "#{Nifcloud.endpoint}#{path}").
      with(headers: {'PRIVATE-TOKEN' => Nifcloud.secret_key}).
      to_return(body: load_fixture(fixture))
end

def a_put(path)
  a_request(:put, "#{Nifcloud.endpoint}#{path}").
      with(headers: {'PRIVATE-TOKEN' => Nifcloud.secret_key})
end

# DELETE
def stub_delete(path, fixture)
  stub_request(:delete, "#{Nifcloud.endpoint}#{path}").
      with(headers: {'PRIVATE-TOKEN' => Nifcloud.secret_key}).
      to_return(body: load_fixture(fixture))
end

def a_delete(path)
  a_request(:delete, "#{Nifcloud.endpoint}#{path}").
      with(headers: {'PRIVATE-TOKEN' => Nifcloud.secret_key})
end
