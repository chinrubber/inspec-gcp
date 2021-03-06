# frozen_string_literal: true

require 'gcp_backend'

module Inspec::Resources
  class GoogleStorageDefaultObjectAcl < GcpResourceBase
    name 'google_storage_default_object_acl'
    desc 'Verifies settings for a storage default object ACL'

    example "
      describe google_storage_default_object_acl(bucket: 'bucket-buvsjjcndqz',  entity: 'user-object-viewer@spaterson-project.iam.gserviceaccount.com') do
        it { should exist }
      end
    "

    def initialize(opts = {})
      # Call the parent class constructor
      super(opts)
      @bucket = opts[:bucket]
      @entity = opts[:entity]
      catch_gcp_errors do
        @acl = @gcp.gcp_storage_client.get_default_object_access_control(@bucket, @entity)
        create_resource_methods(@acl)
      end
    end

    def exists?
      !@acl.nil?
    end

    def to_s
      "Storage Default Object ACL #{@bucket}"
    end
  end
end
