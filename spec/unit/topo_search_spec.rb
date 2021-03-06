#
# Author:: Christine Draper (<christine_draper@thirdwaveinsights.com>)
# Copyright:: Copyright (c) 2014 ThirdWave Insights LLC
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

require 'rspec'
require 'rspec/mocks'
require File.expand_path('../../spec_helper', __FILE__)
require 'chef/knife/topo_search'
require 'chef/node'

describe KnifeTopo::TopoSearch do
  before(:each) do
    Chef::Config[:node_name] = 'christine_test'
  end

  describe '#run' do
    it 'searches for nodes in any topology' do
      @cmd = KnifeTopo::TopoSearch.new(%w(topo  search))
      query = Chef::Search::Query.new
      allow(Chef::Search::Query).to receive(:new).and_return(query)
      expect(query).to receive(:search).with(
        'node', 'topo_name%3A*', anything
      ).and_return([])
      @cmd.run
    end

    it 'searches for nodes in any topology with name appserver' do
      @cmd = KnifeTopo::TopoSearch.new(%w(topo  search  name:appserver))
      query = Chef::Search::Query.new
      allow(Chef::Search::Query).to receive(:new).and_return(query)
      expect(query).to receive(:search).with(
        'node', 'topo_name%3A*%20AND%20(name%3Aappserver)', anything
      ).and_return([])
      @cmd.run
    end

    it 'searches for nodes in no topology' do
      @cmd = KnifeTopo::TopoSearch.new(['topo', 'search', '--no-topo'])
      query = Chef::Search::Query.new
      allow(Chef::Search::Query).to receive(:new).and_return(query)
      expect(query).to receive(:search).with(
        'node', 'NOT%20topo_name%3A*', anything
      ).and_return([])
      @cmd.run
    end

    it 'searches for nodes in a specific topology' do
      @cmd = KnifeTopo::TopoSearch.new(
        %w(topo  search  --topo topo1)
      )
      query = Chef::Search::Query.new
      allow(Chef::Search::Query).to receive(:new).and_return(query)
      expect(query).to receive(
        :search
      ).with('node', 'topo_name%3Atopo1', anything).and_return([])

      @cmd.run
    end

    it 'searches for nodes in no topology with name appserver' do
      @cmd = KnifeTopo::TopoSearch.new(
        %w(topo  search  name:appserver  --no-topo)
      )
      query = Chef::Search::Query.new
      allow(Chef::Search::Query).to receive(:new).and_return(query)
      expect(query).to receive(:search).with(
        'node', '(name%3Aappserver)%20NOT%20topo_name%3A*', anything
      ).and_return([])

      @cmd.run
    end
  end
end
