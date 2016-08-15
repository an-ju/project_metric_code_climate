require 'project_metric_code_climate' 

describe ProjectMetricCodeClimate, :vcr do

  let(:raw_data_three_point_five) { File.read './spec/data/code_climate_3_5_image.svg' }

  context 'AgileVentures/WebsiteOne repo' do
    subject(:code_climate_project_metrics) do
      described_class.new url: 'https://github.com/AgileVentures/WebsiteOne'
    end

    it 'has the corresponding score value' do
      expect(code_climate_project_metrics.score).to eq 3.5
    end

    it 'has the proper image url' do
      expect(code_climate_project_metrics.image).to eq 'https://codeclimate.com/github/AgileVentures/WebsiteOne/badges/gpa.svg'
    end
  end

  context 'AgileVentures/LocalSupport repo' do
    subject(:code_climate_project_metrics) do
      described_class.new url: 'https://github.com/AgileVentures/LocalSupport'
    end

    it 'has the corresponding score value' do
      expect(code_climate_project_metrics.score).to eq 3.2
    end

    it 'has the proper image url' do
      expect(code_climate_project_metrics.image).to eq 'https://codeclimate.com/github/AgileVentures/LocalSupport/badges/gpa.svg'
    end

    it 'uses raw data set with setter of 3.5 rather than network' do
      code_climate_project_metrics.raw_data = raw_data_three_point_five
      expect(code_climate_project_metrics.score).to eq 3.5
      expect(code_climate_project_metrics.raw_data).to eq raw_data_three_point_five
    end

    it 'uses raw data set with setter of 3.5 rather than network after score has already been computed once before' do
      code_climate_project_metrics.raw_data = raw_data_three_point_five
      expect(code_climate_project_metrics.score).to eq 3.5
    end

    it 'uses new network data of 3.5 after score has been computed once' do
      expect(HTTParty).to receive(:get).with('https://codeclimate.com/github/AgileVentures/LocalSupport/badges/gpa.svg').and_return double('response', body: raw_data_three_point_five)
      expect(code_climate_project_metrics.refresh).to be true
      expect(code_climate_project_metrics.score).to eq 3.5
    end

    context 'with raw data in initialize' do

      subject(:code_climate_project_metrics) do
        described_class.new({ url: 'http://github.com/AgileVentures/LocalSupport' }, raw_data_three_point_five)
      end

      it 'uses raw data 3.5 gpa rather than network' do
        expect(code_climate_project_metrics.score).to eq 3.5
      end

    end
  end

end