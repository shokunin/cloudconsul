require 'spec_helper'
describe 'cloudconsul' do
    let(:facts) do
    {
      'fqdn'                   => 'testjenkinsbox',
      'osfamily'               => 'Debian',
      'operatingsystem'        => 'Ubuntu',
      'architecture'           => 'amd64',
      'staging_http_get'       => 'wget',
      'path'                   => '/tmp',
      'root_home'              => '/tmp',
      'kernel'                 => 'Linux',
      'ipaddress_lo'           => '127.0.0.1',
      'operatingsystemrelease' => '16.04',
      'os' => {
        'name'    => 'Ubuntu',
        'family'  => 'Debian',
        'release' => { 'major' => '16.04', 'full' => '16.04' },
        'lsb'     =>
                              {
                                'distcodename'    => 'xenial',
                                'distid'          => 'Ubuntu',
                                'distdescription' => 'Ubuntu 16.04.3 LTS',
                                'distrelease'     => '16.04',
                                'majdistrelease'  => '16.04'
                              }
      }
    }
  end
  context 'with default values for all parameters' do
    it { should contain_class('cloudconsul') }
  end
end
