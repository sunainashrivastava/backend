require 'spec_helper'

#######################################################
# DO NOT CHANGE THIS FILE - WRITE YOUR OWN SPEC FILES #
#######################################################
RSpec.describe 'App Functional Test' do
  describe 'dollar and percent formats sorted by first_name' do
    let(:params) do
      {
        dollar_format: File.read('spec/fixtures/people_by_dollar.txt'),
        percent_format: File.read('spec/fixtures/people_by_percent.txt'),
        order: :first_name,
      }
    end
    let(:people_controller1) { PeopleController.new(params) }

    it 'parses input files and outputs normalized data' do
      normalized_people = people_controller1.normalize

      # Expected format of each entry: `<first_name>, <city>, <birthdate M/D/YYYY>`
      expect(normalized_people).to eq [
        'Elliot, New York City, 5/4/1947',
        'Mckayla, Atlanta, 5/29/1986',
        'Rhiannon, Los Angeles, 4/30/1974',
        'Rigoberto, New York City, 1/5/1962',
      ]
    end

    let(:people_controller2) { PeopleController.new({}) }

    it 'parses input files and outputs nil if data is not passed' do
      normalized_people = people_controller2.normalize

      expect(normalized_people).to be_nil
    end

    it 'parses dollar input and outputs array' do
      response = Filter.new(params)
        .split_by_dollar("city $ birthdate $ last_name $ first_name")
      expect(response).to eq(["city", "birthdate", "last_name", "first_name"])
    end

    it 'parses percent input and outputs array' do
      response = Filter.new(params)
        .split_by_percent("city % birthdate % last_name % first_name")
      expect(response).to eq(["city", "birthdate", "last_name", "first_name"])
    end

    context 'single format data' do
      let(:params) do
        {
          dollar_format: File.read('spec/fixtures/people_by_dollar.txt'),
          order: :first_name,
        }
      end
      it 'parses single format input and outputs normalized data' do
        normalized_people = people_controller1.normalize

        expect(normalized_people).to eq [
          'Rhiannon, Los Angeles, 4/30/1974',
          'Rigoberto, New York City, 1/5/1962',
        ]
      end
    end
  end
end
