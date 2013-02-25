class SaleDate < ActiveRecord::Base
  attr_accessible :date, :user_id

  belongs_to :user

  @@weeks_ahead = 8

  scope :not_expired, where(:date => Date.today..@@weeks_ahead.weeks.from_now.to_date)
  scope :assigned, where("user_id is not null")
  scope :not_assigned, where(:user_id => nil)

  def self.next_dates
    dates = []
    d = Date.today
    @@weeks_ahead.times do
      # get tuesdays
      tmp_date = next_cwday(d,2)
      dates << self.where(:date => tmp_date).first_or_create!
      # get thursdays
      tmp_date = next_cwday(d,4)
      dates << self.where(:date => tmp_date).first_or_create!

      d = d + 1.week
    end

    return dates.sort{|a,b| a.date <=> b.date}
  end

  # returns next 'cwday' for 'date'
  # 'date' has to be an object which supports .year, .cweek, .cwday and .next_week (e.g. DateTime)
  def self.next_cwday date, cwday
    if date.cwday <= cwday
      d = Date.commercial(date.year, date.cweek, cwday)
    else
      d = Date.commercial(date.year, date.next_week.cweek, cwday)
    end
    return d
  end
end
