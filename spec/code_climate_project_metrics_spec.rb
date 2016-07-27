require 'project_metric_code_climate' 

describe ProjectMetricCodeClimate do
  context 'AgileVentures/WebsiteOne repo' do
    subject(:code_climate_project_metrics) do
      described_class.new url: 'http://github.com/AgileVentures/WebsiteOne'
    end

    it 'has the corresponding scalar value' do
      expect(code_climate_project_metrics.score).to eq 3.5
    end

    it 'has the proper image url' do
      expect(code_climate_project_metrics.image).to eq "https://codeclimate.com/github/AgileVentures/WebsiteOne/badges/gpa.svg"
    end
  end
  context 'AgileVentures/LocalSupport repo' do
    subject(:code_climate_project_metrics) do
      described_class.new url: 'http://github.com/AgileVentures/LocalSupport'
    end

    it 'has the corresponding scalar value' do
      expect(code_climate_project_metrics.score).to eq 3.2
    end

    it 'has the proper image url' do
      expect(code_climate_project_metrics.image).to eq "https://codeclimate.com/github/AgileVentures/LocalSupport/badges/gpa.svg"
    end

    context 'with raw data in initialize' do

      subject(:code_climate_project_metrics) do
        raw_data = "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"110\" height=\"20\"><linearGradient id=\"a\" x2=\"0\" y2=\"100%\"><stop offset=\"0\" stop-color=\"#bbb\" stop-opacity=\".1\"/><stop offset=\"1\" stop-opacity=\".1\"/></linearGradient><rect rx=\"3\" width=\"110\" height=\"20\" fill=\"#555\"/><rect rx=\"3\" x=\"82\" width=\"28\" height=\"20\" fill=\"#97CA00\"/><path fill=\"#97CA00\" d=\"M82 0h4v20h-4z\"/><rect rx=\"3\" width=\"110\" height=\"20\" fill=\"url(#a)\"/><g fill=\"#fff\" text-anchor=\"middle\" font-family=\"DejaVu Sans,Verdana,Geneva,sans-serif\" font-size=\"11\"><text x=\"42\" y=\"15\" fill=\"#010101\" fill-opacity=\".3\">code climate</text><text x=\"42\" y=\"14\">code climate</text><text x=\"95\" y=\"15\" fill=\"#010101\" fill-opacity=\".3\">3.5</text><text x=\"95\" y=\"14\">3.5</text></g></svg>\n"
        described_class.new({url: "http://github.com/AgileVentures/LocalSupport"},raw_data)
      end

      it 'uses raw data 3.5 gpa rather than network' do
        expect(code_climate_project_metrics.score).to eq 3.5
      end

    end
  end

end