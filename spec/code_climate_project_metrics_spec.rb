require 'project_metric_code_climate'

describe ProjectMetricCodeClimate do

  before :each do
    stub_request(:get, 'https://api.codeclimate.com/v1/repos?github_slug=an-ju/teamscope')
      .to_return(body: File.read('spec/fixtures/files/project.json'))
    stub_request(:get, 'https://api.codeclimate.com/v1/repos/696a76232df2736347000001/snapshots/596a762c9373ca000100177e')
      .to_return(body: File.read('spec/fixtures/files/snapshot.json'))
  end

  context 'metric' do
    subject(:code_climate_project_metrics) do
      described_class.new(github_project: 'https://github.com/an-ju/teamscope', code_climate_token: 'token')
    end

    it 'returns a right score' do
      expect(code_climate_project_metrics.score).to eq(100.0-3.0210800735343)
    end

    it 'returns a right image' do
      metric_image = code_climate_project_metrics.image
      expect(metric_image).to be_a Hash
      expect(metric_image).to have_key(:chartType)
      expect(metric_image).to have_key(:data)
    end

    it 'returns a right obj_id' do
      expect(code_climate_project_metrics.obj_id).to eql('db36165a645accc5ac78d3c70dffffa4aef7d8a2')
    end
  end


  context 'data generator' do
    it 'generates an array of data' do
      expect(described_class.fake_data).to be_a(Array)
    end

    it 'sets data properly' do
      data_item = described_class.fake_data.first
      expect(data_item).to have_key(:score)
      expect(data_item).to have_key(:image)
    end

  end
end