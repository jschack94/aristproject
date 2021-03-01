class Api::DevicesController < ApplicationController

  def register
    if Phonelib.valid?(params["phone_number"])
      device = Device.create(phone_number: params["phone_number"], carrier: params["carrier"])
      render json: {device_id: device.id} , status: 200
    else
    # debugger
      render json: {"error": "invalid phone number"} , status: 500
    end
  end

  def alive
    device = Device.find_by_id(params["device_id"])
    if device.present?
      if device.disabled_at == nil
        heartbeat = Heartbeat.create!(device_id: device.id)
        render json: {} , status: 200
      else
        render json: {"error": "This Device is disabled."} , status: 500
      end
    else
      render json: {"error": "Device not found"} , status: 500
    end
  end

  def report
    device = Device.find_by_id(params["device_id"])
    if device.present?
      report = Report.create(device_id: device.id, message: params["message"], sender: params["sender"])
      render json: {} , status: 200
    else
      render json: {"error": "Device not found"} , status: 500
    end
  end

  def terminate
    device = Device.find_by_id(params["device_id"])
    if device.present?
      device = device.update(disabled_at: Time.now)
      render json: {} , status: 200
    else
      render json: {"error": "Device not found"} , status: 500
    end
  end
end
