require 'project_metric_code_climate'

describe ProjectMetricCodeClimate do

  before :each do
    @conn = double('conn')
    project_resp = double('project')
    allow(project_resp).to receive(:body) { File.read './spec/data/project.json' }
    snapshot_resp = double('snapshot')
    allow(snapshot_resp).to receive(:body) { File.read './spec/data/snapshot.json' }

    allow(Faraday).to receive(:new).and_return(@conn)
    allow(@conn).to receive(:headers).and_return({})
    allow(@conn).to receive(:get).with('repos?github_slug=an-ju/teamscope').and_return(project_resp)
    allow(@conn).to receive(:get).with('repos/696a76232df2736347000001/snapshots/596a762c9373ca000100177e').and_return(snapshot_resp)
  end

  context 'it should generate data correctly' do
    subject(:code_climate_project_metrics) do
      described_class.new(github_project: 'https://github.com/an-ju/teamscope', code_climate_token: 'token')
    end

    it 'has the corresponding score value' do
      expect(code_climate_project_metrics.score).to eq(100.0-3.0210800735343)
    end

    it 'has the proper image url' do
      image = JSON.parse(code_climate_project_metrics.image)
      expect(image).to have_key('data')
      expect(image['data']).to have_key('ratings')
      expect(image['data']['ratings'].length).to eql(1)
    end

    it 'has the proper commit_sha' do
      expect(code_climate_project_metrics.commit_sha).to eql('db36165a645accc5ac78d3c70dffffa4aef7d8a2')
    end
  end


  context 'it should generate fake data' do
    it 'generates three fake data' do
      expect(ProjectMetricCodeClimate.fake_data.length).to eql(3)
    end
  end
end