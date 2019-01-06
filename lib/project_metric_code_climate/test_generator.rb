class ProjectMetricCodeClimate
  def self.fake_data
    [_test_data(3.0), _test_data(30.0), _test_data(50.0)]
  end

  def self._test_data(value)
    { image: _test_image(value), score: 100.0-value }
  end

  def self._test_image(value)
    {chartType: 'code_climate',
     fixtures:
          { ratings:
                [{ letter: _test_letter(value),
                   path: '/',
                   measure:
                       { value: value,
                         unit: "percent" },
                   pillar: "Maintainability" }],
            meta:
                { issues_count: 6037,
                  measures:
                      { remediation:
                            { value: 20007.3,
                              unit: "minute" },
                        technical_debt_ratio:
                            {
                                value: value,
                                unit: "percent" } } },
            issue_link: 'https://codeclimate.com/github/an-ju/projectscope/issues' } }.to_json
  end

  def self._test_letter(value)
    if value < 20.0
      'A'
    elsif value < 40.0
      'B'
    elsif value < 60.0
      'C'
    elsif value < 80.0
      'D'
    end
  end
end