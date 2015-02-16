class TrackingController < ApplicationController
  # We need this controller to be accessible by anyone without authentication
  skip_filter :authenticate_admin!
  # SSL redirection is also disabled for this controller. See ApplicationController force_ssl.

  # Deprecated form of open link
  def open
    if HashId.valid?(params[:delivery_id], params[:hash])
      delivery = Delivery.find(params[:delivery_id])
      delivery.add_open_event(request) unless Rails.configuration.cuttlefish_read_only_mode
      # TODO Check that we are asking for a gif and only accept those for the time being
      # This sends a 1x1 transparent gif
      send_data(Base64.decode64("R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="), type: "image/gif", disposition: "inline")
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def open2
    if HashId2.valid?(params[:delivery_id], params[:hash])
      delivery = Delivery.find(params[:delivery_id])
      delivery.add_open_event(request) unless Rails.configuration.cuttlefish_read_only_mode
      # TODO Check that we are asking for a gif and only accept those for the time being
      # This sends a 1x1 transparent gif
      send_data(Base64.decode64("R0lGODlhAQABAPAAAAAAAAAAACH5BAEAAAAALAAAAAABAAEAAAICRAEAOw=="), type: "image/gif", disposition: "inline")
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def click
    if HashId.valid?(params[:delivery_link_id], params[:hash])
      delivery_link = DeliveryLink.find_by_id(params[:delivery_link_id])
      if delivery_link
        delivery_link.add_click_event(request) unless Rails.configuration.cuttlefish_read_only_mode
        redirect_to delivery_link.url
      elsif params[:url]
        # This is probably an old email which has been archived and the delivery_link record
        # doesn't exist anymore. If we have a url we should redirect to it anyway so that the
        # link will still work even though we won't be able to log the click event.
        redirect_to params[:url]
      else
        raise ActiveRecord::RecordNotFound
      end
    else
      raise ActiveRecord::RecordNotFound
    end
  end

  def click2
    if HashId2.valid?("#{params[:delivery_link_id]}-#{params[:url]}", params[:hash])
      delivery_link = DeliveryLink.find_by_id(params[:delivery_link_id])
      # If there is no delivery_link this is probably an old email
      # which has been archived and the delivery_link record doesn't exist anymore.
      if delivery_link && !Rails.configuration.cuttlefish_read_only_mode
        delivery_link.add_click_event(request)
      end
      redirect_to params[:url]
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end
