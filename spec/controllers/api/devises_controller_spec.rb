require 'rails_helper'

describe Api::DevicesController do
  describe "POST register" do
    context "with valid phone number" do
      let(:valid_params) do
        {
          phone_number: "+1-541-754-3010",
          carrier: "this is carrier"
        }
      end

      it "register only if phone number is valid" do
        expect { post "register", params: valid_params}.to change(Device, :count).by(1)
        expect(response).to have_http_status 200
      end
    end
    context "with invalid phone number" do
      let(:invalid_params) do
        {
          phone_number: "12345678",
          carrier: "this is carrier"
        }
      end

      it "return error if phone number is invalid" do
        post "register", params: invalid_params
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["error"]).to eq("invalid phone number")
        expect(response).to have_http_status 500
      end
    end
  end

  describe "PUT terminate" do
    let(:device) { FactoryGirl.create(:device, phone_number: "+1-541-754-3010", carrier: "this is carrier")}
    it "allows to terminate devise" do
      put :terminate,params: { :device_id => device.id, :device => device.attributes = { :disabled_at => Time.now }}
      expect(response).to have_http_status 200
    end

    it "return error if devise id is not present" do
      put :terminate,params: { :device_id => 2, :device => device.attributes = { :disabled_at => Time.now }}
      expect(response).to have_http_status 500
      parsed_response = JSON.parse(response.body)
      expect(parsed_response["error"]).to eq("Device not found")
    end
  end

  describe "POST report" do
    let(:device) { FactoryGirl.create(:device, phone_number: "+1-541-754-3010", carrier: "this is carrier")}
    it "create report if devise exist" do
      post :report, params: {device_id: device.id, :report => FactoryGirl.create(:report, sender: 'this is sender', message: 'This is message', device_id: device.id)}
     expect(response).to have_http_status 200
    end

    it "return error if devise exist" do
      post :report, params: {device_id: 3}
      expect(response).to have_http_status 500
      parsed_response = JSON.parse(response.body)
      expect(parsed_response["error"]).to eq("Device not found")
    end
  end

  describe "POST alive" do
    let(:device) { FactoryGirl.create(:device, phone_number: "+1-541-754-3010", carrier: "this is carrier", disabled_at: nil)}
    let(:device1) { FactoryGirl.create(:device, phone_number: "+1-541-754-3010", carrier: "this is carrier", disabled_at: Time.now)}
    it "create report if devise exist and not disabled" do
      post :alive, params: {device_id: device.id, :heartbeat => FactoryGirl.create(:heartbeat, device_id: device.id)}
     expect(response).to have_http_status 200
    end

    it "create report if devise exist and disabled" do
      post :alive, params: {device_id: device1.id}
      expect(response).to have_http_status 500
      parsed_response = JSON.parse(response.body)
      expect(parsed_response["error"]).to eq("This Device is disabled.")
    end

    it "return error if devise exist" do
      post :alive, params: {device_id: 6}
      expect(response).to have_http_status 500
      parsed_response = JSON.parse(response.body)
      expect(parsed_response["error"]).to eq("Device not found")
    end
  end
end