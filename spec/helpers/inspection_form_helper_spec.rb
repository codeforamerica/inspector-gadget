require 'rails_helper'

describe InspectionFormHelper do
  describe '#next_available_date' do
    it 'should return a Date object' do
      expect( next_available_date ).to be_instance_of(Date)
    end

    it 'should return Thursday on a Wednesday before 3pm' do
      Timecop.freeze( Time.zone.now.next_week(:wednesday).advance(hours: 12) ) do
        expect( next_available_date.strftime('%A') ).to eq('Thursday');
      end
    end

    it 'should return Friday on a Wednesday after 3pm' do
      Timecop.freeze( Time.zone.now.next_week(:wednesday).advance(hours: 20) ) do
        expect( next_available_date.strftime('%A') ).to eq('Friday');
      end
    end

    it 'should return Tuesday on a Saturday' do
      Timecop.freeze( Time.zone.now.next_week(:saturday).advance(hours: 12) ) do
        expect( next_available_date.strftime('%A') ).to eq('Tuesday');
      end
    end

    it 'should return Monday on a Friday before 3pm' do
      Timecop.freeze( Time.zone.now.next_week(:friday).advance(hours: 12) ) do
        expect( next_available_date.strftime('%A') ).to eq('Monday');
      end
    end
  end

end
