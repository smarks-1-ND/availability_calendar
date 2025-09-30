class UnavailableDatesController < ApplicationController
  def index
    # Fetch all records to display on the calendar
    @unavailable_dates = UnavailableDate.all
    # This is for the form on each day
    @new_unavailable_date = UnavailableDate.new
    
    # Handle date parameter to show specific month
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
  end

  def create
    @unavailable_date = UnavailableDate.new(unavailable_date_params)
    if @unavailable_date.save
      redirect_to redirect_path_with_date(@unavailable_date.day), notice: "Date marked as unavailable!"
    else
      # Re-render the index page with the existing data and an error message
      @unavailable_dates = UnavailableDate.all
      @new_unavailable_date = @unavailable_date # Keep user's input
      flash.now[:alert] = "Couldn't save. Did you enter a name?"
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    unavailable_date = UnavailableDate.find(params[:id])
    target_date = unavailable_date.day
    unavailable_date.destroy
    
    # Use the date parameter if provided, otherwise use the target date
    redirect_date = params[:date] ? Date.parse(params[:date]) : target_date
    redirect_to redirect_path_with_date(redirect_date), notice: "Availability restored."
  end

  private

  def unavailable_date_params
    params.require(:unavailable_date).permit(:user_name, :day)
  end

  def redirect_path_with_date(date)
    # Redirect to the same month/year as the date that was just modified
    root_path(date: date.strftime("%Y-%m-01"))
  end
end