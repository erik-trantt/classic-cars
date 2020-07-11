class CarsController < ApplicationController
  skip_before_action :authenticate_user!, only: :index
  before_action :set_car, only: %w[show edit update destroy]

  def new
    @car = Car.new
  end

  def create
    @car = Car.new(car_params)
    @car.user = current_user

    if @car.save
      redirect_to car_path(@car)
    else
      render :new
    end
  end

  def show
    @booking = Booking.new
    @reviews = @car.reviews
    @markers = [prepare_car_marker(@car)]
  rescue ActiveRecord::RecordNotFound => _e
    redirect_to cars_path, alert: "Could not find the car you requested."
  end

  def index
    @cars = handle_user_car_query(params[:query])

    @markers = @cars.map do |car|
      prepare_car_marker(car)
    end
  end

  def destroy
    if @car.bookings.count.zero?
      @car.destroy
      redirect_to listmycars_cars_path
    else
      redirect_to listmycars_cars_path, alert: "Car cannot be removed. There are still bookings for this car."
    end
  end

  def edit
  end

  def update
    @car.update(car_params)
    redirect_to listmycars_cars_path
  end

  def listmycars
    @cars = current_user.cars
  end

  private

  def set_car
    @car = Car.find(params[:id])
  end

  def car_params
    params.require(:car).permit(:name, :location, :seats, :year, :price, photos: [])
  end

  def handle_user_car_query(query)
    cars = cars_by_query(query) if query.present?
    cars ||= Car.geocoded
    cars.with_attached_photos
  end

  def cars_by_query(query)
    Car.geocoded.search_by_name_and_location(query)
  end

  def prepare_car_marker(car)
    {
      lat: car.latitude,
      lng: car.longitude,
      infoWindow: render_to_string(partial: "info_window", locals: { car: car }),
      image_url: helpers.asset_url('ferrari.png')
    }
  end
end
