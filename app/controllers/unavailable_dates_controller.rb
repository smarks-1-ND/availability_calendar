class UnavailableDatesController < ApplicationController
  def index
    # Fetch all records to display on the calendar
    @unavailable_dates = UnavailableDate.all
    # This is for the form on each day
    @new_unavailable_date = UnavailableDate.new
  end

  def create
    @unavailable_date = UnavailableDate.new(unavailable_date_params)
    if @unavailable_date.save
      redirect_to root_path, notice: "Date marked as unavailable!"
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
    unavailable_date.destroy
    redirect_to root_path, notice: "Availability restored."
  end

  private

  def unavailable_date_params
    params.require(:unavailable_date).permit(:user_name, :day)
  end
end