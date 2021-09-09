# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'with default parameters ', if: ['debian', 'redhat', 'ubuntu'].include?(os[:family]) do
  pp = <<-PUPPETCODE
  class { '::grafana_agent':
    install_method => 'archive',
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

  describe file('/opt/grafana_agent') do
    it { is_expected.to be_directory }
  end

  describe file('/etc/grafana-agent.yaml') do
    it { is_expected.to be_file }
  end

  describe service('grafana-agent') do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running.under('systemd') }
  end

  describe port(80) do
    it { is_expected.to be_listening }
  end

  describe port(9095) do
    it { is_expected.to be_listening }
  end
end
