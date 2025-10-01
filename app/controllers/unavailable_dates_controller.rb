class UnavailableDatesController < ApplicationController
  def index
    # Fetch all records to display on the calendar
    @unavailable_dates = UnavailableDate.all
    # This is for the form on each day
    @new_unavailable_date = UnavailableDate.new
    
    # Handle date parameter to show specific month
    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    
    # Debug: Let's see what date we're showing
    puts "DEBUG: index action - params[:date] = #{params[:date]}"
    puts "DEBUG: index action - @date = #{@date}"
    puts "DEBUG: index action - @date month/year = #{@date.strftime('%B %Y')}"
  end

  def create
    @unavailable_date = UnavailableDate.new(unavailable_date_params)
    if @unavailable_date.save
      # Use the return_to_date parameter if provided (from JavaScript)
      if params[:return_to_date].present?
        redirect_to root_path(date: params[:return_to_date]), notice: "Date marked as unavailable!"
      else
        # Fallback: redirect to the month of the created date
        created_month = @unavailable_date.day.beginning_of_month
        redirect_to root_path(date: created_month.strftime("%Y-%m-%d")), notice: "Date marked as unavailable!"
      end
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