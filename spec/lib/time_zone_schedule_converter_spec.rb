require 'rails_helper'

RSpec.describe TimeZoneScheduleConverter do
  describe '.convert' do
    subject do
      TimeZoneScheduleConverter.convert(
        from_zone: from_zone,
        to_zone: to_zone,
        days: days,
        hour: hour
      )
    end

    context 'when hour is blank' do
      let(:from_zone) { 'UTC' }
      let(:to_zone) { 'Amsterdam' }
      let(:days) { ['Mon'] }
      let(:hour) { nil }

      it 'returns the same days and hour' do
        expect(subject).to eq(
          days: days,
          hour: hour
        )
      end
    end

    context 'when to_zone is the same as from_zone' do
      let(:from_zone) { 'Amsterdam' }
      let(:to_zone) { 'Amsterdam' }
      let(:days) { ['Mon'] }
      let(:hour) { 0 }

      it 'returns the same days and hour' do
        expect(subject).to eq(
          days: days,
          hour: hour
        )
      end
    end

    context 'when all days are provided' do
      let(:from_zone) { 'UTC' }
      let(:to_zone) { 'Amsterdam' }
      let(:to_zone_offset) { ActiveSupport::TimeZone[to_zone].now.utc_offset / 60 / 60 }
      let(:days) { Date::ABBR_DAYNAMES }
      let(:hour) { 23 }
      let(:adjusted_hour) { to_zone_offset - 1 }

      it 'returns the adjusted hour but same days' do
        expect(subject).to eq(
          days: days,
          hour: adjusted_hour
        )
      end
    end

    context 'when some days are provided' do
      let(:days) { %w[Sun Wed Sat] }

      let(:to_zone_offset) { ActiveSupport::TimeZone[to_zone].now.utc_offset / 60 / 60 }

      context 'when the adjusted hour doesn\'t affect the days' do
        let(:from_zone) { 'UTC' }
        let(:to_zone) { 'Amsterdam' }
        let(:hour) { 12 }
        let(:adjusted_hour) { hour + to_zone_offset }

        it 'returns the adjusted hour and same days' do
          expect(subject).to eq(
            days: days,
            hour: adjusted_hour
          )
        end
      end

      context 'when the adjusted hour moves behind into previous day(s)' do
        let(:from_zone) { 'UTC' }
        let(:to_zone) { 'Greenland' }
        let(:hour) { 1 }
        let(:adjusted_hour) { 24 + to_zone_offset + 1 }

        it 'returns the adjusted hour and previous day(s)' do
          expect(subject).to eq(
            days: %w[Sat Tue Fri],
            hour: adjusted_hour
          )
        end
      end

      context 'when the adjusted hour moves forward into next days' do
        let(:from_zone) { 'UTC' }
        let(:to_zone) { 'Amsterdam' }
        let(:hour) { 23 }
        let(:adjusted_hour) { to_zone_offset - 1 }

        it 'returns the adjusted hour and next days' do
          expect(subject).to eq(
            days: %w[Mon Thu Sun],
            hour: adjusted_hour
          )
        end
      end
    end
  end
end
