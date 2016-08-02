require 'rails_helper'

describe InspectionFormHelper do
  describe '#next_available_date' do
    it 'should return a Date object' do
      expect(next_available_date).to be_instance_of(Date)
    end

    it 'should return Thursday on a Wednesday before 3pm' do
      Timecop.freeze(Time.zone.now.next_week(:wednesday).advance(hours: 14, minutes: 30)) do
        expect(next_available_date.strftime('%A')).to eq('Thursday')
      end
    end

    it 'should return Friday on a Wednesday after 3pm' do
      Timecop.freeze(Time.zone.now.next_week(:wednesday).advance(hours: 20)) do
        expect(next_available_date.strftime('%A')).to eq('Friday')
      end
    end

    it 'should return Friday on a Wednesday at exactly 3pm' do
      Timecop.freeze(Time.zone.now.next_week(:wednesday).advance(hours: 15)) do
        expect(next_available_date.strftime('%A')).to eq('Friday')
      end
    end

    it 'should return Tuesday on a Saturday' do
      Timecop.freeze(Date.civil(2016, 5, 21).to_time.in_time_zone.advance(hours: 14, minutes: 30)) do
        expect(next_available_date.strftime('%A')).to eq('Tuesday')
      end
    end

    it 'should return Tuesday on a Sunday before 3pm' do
      Timecop.freeze(Date.civil(2016, 5, 22).to_time.in_time_zone.advance(hours: 14, minutes: 30)) do
        expect(next_available_date.strftime('%A')).to eq('Tuesday')
      end
    end

    it 'should return Tuesday on a Sunday after 3pm' do
      Timecop.freeze(Date.civil(2016, 5, 22).to_time.in_time_zone.advance(hours: 16)) do
        expect(next_available_date.strftime('%A')).to eq('Tuesday')
      end
    end

    it 'should return Monday on a Friday before 3pm' do
      Timecop.freeze(Date.civil(2016, 5, 20).to_time.in_time_zone.advance(hours: 14, minutes: 30)) do
        expect(next_available_date.strftime('%A')).to eq('Monday')
      end
    end

    it 'should return Tuesday on a Friday before 3pm on a Memorial Day weekend' do
      Timecop.freeze(Date.civil(2016, 5, 27).to_time.in_time_zone.advance(hours: 14, minutes: 30)) do
        expect(next_available_date.strftime('%A')).to eq('Tuesday')
      end
    end
  end
end
