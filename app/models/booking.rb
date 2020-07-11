class Booking < ApplicationRecord
  BOOKING_STATUS = {
    pending: "pending",
    renting: "renting",
    confirmed: "confirmed",
    cancelled: "cancelled",
    returned: "returned",
    declined: "declined"
  }

  belongs_to :car
  belongs_to :user
  has_one :review

  validates :start_date, :end_date, presence: true
  validate :date_available?, on: :create

  def date_available?
    return true if car.can_book_for?(start_date, end_date)

    errors.add(:dates, "Selected dates are not available to book!")
    return false
  end

  def approved
    update(status: BOOKING_STATUS[:confirmed])
  end

  def declined
    update(status: BOOKING_STATUS[:declined])
  end

  def duration
    (end_date - start_date).to_i
  end

  def formatted_price
    booking_price.to_s(:rounded, precision: 2, delimiter: ',')
  end
end
