class PwaController < ApplicationController
  def manifest
    render "pwa/manifest", formats: :json, layout: false
  end

  def service_worker
    render "pwa/service_worker", formats: :js, layout: false
  end
end
