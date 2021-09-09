# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'with default parameters ', if: ['debian', 'redhat', 'ubuntu'].include?(os[:family]) do
  pp = <<-PUPPETCODE
  package { 'unzip':
    ensure => present,
  }
  -> class { '::grafana_agent':
    install_method => 'archive',
    server_config_hash => {
      server => {
        http_listen_port => 12345
      }
    }
  }
PUPPETCODE

  it 'applies idempotently' do
    idempotent_apply(pp)
  end

  describe group('grafana-agent') do
    it { is_expected.to exist }
  end

  describe user('grafana-agent') do
    it { is_expected.to exist }
  end

  describe file('/opt/grafana-agent') do
    it { is_expected.to be_directory }
  end

  describe file('/etc/grafana-agent.yaml') do
    it { is_expected.to be_file }
  end

  describe service('grafana-agent') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running.under('systemd') }
  end

  describe port(12_345) do
    it { is_expected.to be_listening }
  end

  describe port(9095) do
    it { is_expected.to be_listening }
  end
end
