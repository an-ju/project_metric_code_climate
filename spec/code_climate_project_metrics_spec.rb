require 'project_metric_code_climate' 

describe ProjectMetricCodeClimate do
  context 'AgileVentures/WebsiteOne repo' do
    subject(:code_climate_project_metrics) do
      described_class.new url: 'http://github.com/AgileVentures/WebsiteOne'
    end

    it 'has the corresponding scalar value' do
      expect(code_climate_project_metrics.score).to eq 3.5
    end
  end
  context 'AgileVentures/LocalSupport repo' do
    subject(:code_climate_project_metrics) do
      described_class.new url: 'http://github.com/AgileVentures/LocalSupport'
    end

    it 'has the corresponding scalar value' do
      expect(code_climate_project_metrics.score).to eq 3.2
    end
  end

end