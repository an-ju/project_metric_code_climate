require 'project_metric_code_climate' 

describe ProjectMetricCodeClimate do
  context 'AgileVentures/WebsiteOne repo' do
    subject(:code_climate_project_metrics) { described_class.new 'http://github.com/AgileVentures/WebsiteOne'}

    it 'has the corresponding scalar value' do
      expect(code_climate_project_metrics.scalar).to eq 3.5
    end
  end
  context 'AgileVentures/LocalSupport repo' do
    subject(:code_climate_project_metrics) { described_class.new 'http://github.com/AgileVentures/LocalSupport'}

    it 'has the corresponding scalar value' do
      expect(code_climate_project_metrics.scalar).to eq 3.2
    end
  end

end