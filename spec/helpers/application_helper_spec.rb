require 'rails_helper'

describe ApplicationHelper do
  describe '#last_inspection_day_date' do
    it 'should return Tuesday on a Wednesday before working hours' do
      Timecop.freeze( wednesday.to_time.in_time_zone.advance(hours: 2) ) do
        expect( last_inspection_day_date ).to eq( tuesday );
      end
    end

    it 'should return Tuesday on a Wednesday before 3pm' do
      Timecop.freeze( wednesday.to_time.in_time_zone.advance(hours: 14, minutes: 30) ) do
        expect( last_inspection_day_date ).to eq( tuesday );
      end
    end

    it 'should return Tuesday on a Wednesday after 3pm' do
      Timecop.freeze( wednesday.to_time.in_time_zone.advance(hours: 18) ) do
        expect( last_inspection_day_date ).to eq( tuesday );
      end
    end

    it 'should return Friday on a Monday before 3pm' do
      Timecop.freeze( monday.to_time.in_time_zone.advance(hours: 14, minutes: 30) ) do
        expect( last_inspection_day_date ).to eq( friday );
      end
    end

    it 'should return Friday on a Monday after 3pm' do
      Timecop.freeze( monday.to_time.in_time_zone.advance(hours: 18) ) do
        expect( last_inspection_day_date ).to eq( friday );
      end
    end

    it 'should return Friday on a Saturday after 3pm' do
      Timecop.freeze( Date.civil(2016, 5, 21).to_time.in_time_zone.advance(hours: 18) ) do
        expect( last_inspection_day_date ).to eq( friday );
      end
    end
  end

  describe '#next_inspection_day_date' do
    it 'should return Thursday on a Wednesday before working hours' do
      Timecop.freeze( wednesday.to_time.in_time_zone.advance(hours: 2) ) do
        expect( next_inspection_day_date ).to eq( Date.civil(2016, 5, 26) );
      end
    end

    it 'should return Thursday on a Wednesday before 3pm' do
      Timecop.freeze( wednesday.to_time.in_time_zone.advance(hours: 14, minutes: 30) ) do
        expect( next_inspection_day_date ).to eq( Date.civil(2016, 5, 26) );
      end
    end

    it 'should return Thursday on a Wednesday after 3pm' do
      Timecop.freeze( wednesday.to_time.in_time_zone.advance(hours: 18) ) do
        expect( next_inspection_day_date ).to eq( Date.civil(2016, 5, 26) );
      end
    end

    it 'should return Monday on a Friday before 3pm' do
      Timecop.freeze( friday.to_time.in_time_zone.advance(hours: 14, minutes: 30) ) do
        expect( next_inspection_day_date ).to eq( monday );
      end
    end

    it 'should return Monday on a Friday after 3pm' do
      Timecop.freeze( friday.to_time.in_time_zone.advance(hours: 18) ) do
        expect( next_inspection_day_date ).to eq( monday );
      end
    end

    it 'should return Monday on a Sunday after 3pm' do
      Timecop.freeze( friday.to_time.in_time_zone.advance(hours: 18) ) do
        expect( next_inspection_day_date ).to eq( monday );
      end
    end
  end
end

# days below picked to avoid holiday weekends

def friday
  Date.civil(2016, 5, 20)
end

def monday
  Date.civil(2016, 5, 23)
end

def tuesday
  Date.civil(2016, 5, 24)
end

def wednesday
  Date.civil(2016, 5, 25)
end
