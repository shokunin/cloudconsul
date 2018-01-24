require 'spec_helper'
describe 'cloudconsul' do
  context 'with default values for all parameters' do
    it { should contain_class('cloudconsul') }
  end
end
