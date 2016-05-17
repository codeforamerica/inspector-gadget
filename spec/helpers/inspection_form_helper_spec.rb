require 'rails_helper'

describe InspectionFormHelper do
  describe '#min_days_from_now' do
    it 'on a Wednesday before 3pm should return a number of additional days that results in Thursday' do
      Timecop.freeze( Time.now.next_week(:wednesday).advance(hours: 12) ) do
        expect( (Date.today+min_days_from_now).strftime('%A') ).to eq('Thursday');
      end
    end

    it 'on a Wednesday after 3pm should return a number of additional days that results in Friday' do
      Timecop.freeze( Time.now.next_week(:wednesday).advance(hours: 20) ) do
        expect( (Date.today+min_days_from_now).strftime('%A') ).to eq('Friday');
      end
    end

    it 'on a Saturday should return a number of additional days that results in Tuesday' do
      Timecop.freeze( Time.now.next_week(:saturday).advance(hours: 12) ) do
        expect( (Date.today+min_days_from_now).strftime('%A') ).to eq('Tuesday');
      end
    end

    it 'on a Friday before 3pm should return a number of additional days that results in Monday' do
      Timecop.freeze( Time.now.next_week(:friday).advance(hours: 12) ) do
        expect( (Date.today+min_days_from_now).strftime('%A') ).to eq('Monday');
      end
    end
  end

end
