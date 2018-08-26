# frozen_string_literal: true

require 'gcp_backend'

module Inspec::Resources
  class GoogleProject < GcpResourceBase
    name 'google_project'
    desc 'Verifies settings for a project'

    example "
      describe google_project(project: 'chef-inspec-gcp') do
        it { should exist }
        its('name') { should eq 'chef-inspec-gcp' }
        its('project_number') { should eq 1041234567833 }
        its('lifecycle_state') { should eq 'ACTIVE' }
        its('labels') { should include(key: 'contact', value: 'operations') }
      end
    "
    def initialize(opts = {})
      # Call the parent class constructor
      super(opts)
      @display_name = opts[:name]
      catch_gcp_errors do
        @project = @gcp.gcp_project_client.get_project(opts[:project])
        create_resource_methods(@project)
      end
    end

    # helper for returning label keys to perform checks
    def labels_keys
      return [] if !defined?(labels)
      labels.item.keys
    end
    
    # helper for returning label values to perform checks
    def labels_values
      return [] if !defined?(labels)
      labels.item.values
    end

    def exists?
      !@project.nil?
    end

    def to_s
      "Project #{name}"
    end
  end
end
