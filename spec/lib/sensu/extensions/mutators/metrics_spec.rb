require 'sensu/base'

describe 'Sensu::Extension::Metrics' do

  let(:graphite_event) do
    Wizardvan::Test::Fixtures::GRAPHITE_EVENT
  end

  let(:bad_graphite_event) do
    Wizardvan::Test::Fixtures::BAD_GRAPHITE_EVENT
  end

  let(:opentsdb_event) do
    Wizardvan::Test::Fixtures::OPENTSDB_EVENT
  end

  let(:json_event) do
    Wizardvan::Test::Fixtures::JSON_EVENT
  end

  let(:json_event_with_name) do
    Wizardvan::Test::Fixtures::JSON_EVENT_WITH_NAME
  end

  let(:settings) do
    Wizardvan::Test::Fixtures::SETTINGS
  end

  let(:settings_bad) do
    Wizardvan::Test::Fixtures::SETTINGS_BAD
  end

  let(:empty_event) do
    Wizardvan::Test::Fixtures::EMPTY_EVENT
  end

  before(:all) do
    extensions = Sensu::Extensions.new
    extensions.require_directory(
      # bleh really?
      File.expand_path('../../../../../../lib/sensu/extensions', __FILE__)
    )
    extensions.load_all
    @mutator = extensions[:mutators]['metrics']
  end

  before(:each) do
    @mutator.settings = settings
  end

  it 'can be loaded by sensu' do
    @mutator.should be_an_instance_of(Sensu::Extension::Metrics)
    @mutator.definition[:type].should eq('extension')
    @mutator.definition[:name].should eq('metrics')
  end

  it 'successfully returns endpoints hash when configured' do
    @mutator.run(graphite_event) do |output, status|
      output.should be_an_instance_of(Hash)
    end
  end

  it 'does nothing for empty metrics' do
    @mutator.run(empty_event) do |output, status|
      status.should == 0
      output[:graphite].should == ""
      output[:opentsdb].should == ""
    end
  end

  it 'passes metrics through for graphite' do
    @mutator.run(graphite_event) do |output, status|
      output[:graphite].should == graphite_event[:check][:output]
    end
  end

  it 'should ignore malformed lines in graphite events when mutating for opentsdb' do
    @mutator.run(bad_graphite_event) do |output, status|
      output[:opentsdb].should_not match(/bad/)
    end
  end

  it 'passes metrics through for opentsdb' do
    @mutator.run(opentsdb_event) do |output, status|
      output[:opentsdb].should == opentsdb_event[:check][:output]
    end
  end

  it 'strips hostnames from opentsdb metric names' do
    @mutator.run(graphite_event) do |output, status|
      output[:opentsdb].should =~ /^put metric_name/
    end
  end

  it 'automatically tags mutated metrics for opentsdb with host' do
    @mutator.run(graphite_event) do |output, status|
      output[:opentsdb].should =~ /host=hostname\n$/
    end
  end

  it 'mutates json to graphite' do
    @mutator.run(json_event) do |output, status|
      output[:graphite].should == "com.example.hostname.metric_name\tvalue\t0\n"
    end
  end

  it 'mutates json to opentsdb' do
    @mutator.run(json_event) do |output, status|
      output[:opentsdb].should == "put metric_name 0 value host=hostname.example.com tag=tag tag2=tag2\n"
    end
  end

  it 'mutates json to opentsdb and includes name if it exists' do
    @mutator.run(json_event_with_name) do |output, status|
      output[:opentsdb].should == "put metric_name 0 value check_name=check_name host=hostname tag=tag tag2=tag2\n"
    end
  end

  it 'handles non-existent mutators gracefully-ish' do
    @mutator.settings = settings_bad
    @mutator.run(json_event) do |output, status|
      status.should == 0
    end
  end

  it 'does not require tags' do
    @mutator.run(opentsdb_event) do |output, status|
      output[:opentsdb].should == opentsdb_event[:check][:output]
    end
  end
end
