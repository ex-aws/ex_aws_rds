defmodule ExAws.RDS do
  @moduledoc """
  Operations on AWS RDS
  """

  @version "2014-10-31"


  @doc """
  Returns the AWS RDS API version targeted by this library as a string
  """
  @spec api_version :: String.t
  def api_version, do: @version



  @type db_instance_classes :: [
          :db_t1_micro
          | :db_m1_small
          | :db_m1_medium
          | :db_m1_large
          | :db_m1_xlarge
          | :db_m2_xlarge
          | :db_m2_2xlarge
          | :db_m2_4xlarge
          | :db_m3_medium
          | :db_m3_large
          | :db_m3_xlarge
          | :db_m3_2xlarge
          | :db_m4_large
          | :db_m4_xlarge
          | :db_m4_2xlarge
          | :db_m4_4xlarge
          | :db_m4_10xlarge
          | :db_r3_large
          | :db_r3_xlarge
          | :db_r3_2xlarge
          | :db_r3_4xlarge
          | :db_r3_8xlarge
          | :db_t2_micro
          | :db_t2_small
          | :db_t2_medium
          | :db_t2_large
        ]

  @type filter :: {name :: binary, values :: [binary]}

  @type tag :: {key :: binary, value :: binary}
  @doc """
  Adds a source identifier to an existing RDS event notification subscription.
  """
  @spec add_source_id_to_subscription(source_id :: binary, subscription :: binary) ::
          ExAws.Operation.RestQuery.t()
  def add_source_id_to_subscription(source_id, subscription) do
    query_params = %{
      "Action" => "AddSourceIdentifierToSubscription",
      "SourceIdentifier" => source_id,
      "SubscriptionName" => subscription,
      "Version" => @version
    }

    request(:post, "/", query_params)
  end

  @doc """
  Adds metadata tags to an Amazon RDS resource

  These tags can also be used with cost allocation reporting to track cost associated
  with Amazon RDS resources, or used in a Condition statement in an IAM policy for
  Amazon RDS.

  For an overview on tagging Amazon RDS resources, see [Tagging Amazon RDS
  Resources](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.Tagging.html)

  ## Parameters:

    * resource - The Amazon RDS resource that the tags are added to. This value is an
    Amazon Resource Name (ARN).

    * tags - a List of the tags to be assigned to the Amazon RDS resource.
  """
  @spec add_tags_to_resource(resource :: binary, tags :: [tag, ...]) ::
          ExAws.Operation.RestQuery.t()
  def add_tags_to_resource(resource, tags) do
    query_params = %{
      "Action" => "AddTagsToResource",
      "ResourceName" => resource,
      "Version" => @version
    }

    query_params =
      tags
      |> Stream.with_index(1)
      |> Enum.reduce(query_params, fn {{k, v}, n}, tags_map ->
        tags_map
        |> Map.put("Tags.member.#{Integer.to_string(n)}.Key", k)
        |> Map.put("Tags.member.#{Integer.to_string(n)}.Value", v)
      end)

    request(:post, "/", query_params)
  end

  @type apply_pending_maintenance_actions :: :system_upgrade | :db_upgrade
  @type apply_pending_maintenance_opt_in_types :: :immediate | :next_maintenance | :undo_opt_in
  @doc """
  Applies a pending maintenance action to a resource.
  """
  @spec apply_pending_maintenance(
          resource_id :: binary,
          action :: apply_pending_maintenance_actions,
          opt_in_type :: apply_pending_maintenance_opt_in_types
        ) :: ExAws.Operation.RestQuery.t()
  def apply_pending_maintenance(resource_id, action, opt_in_type) do
    query_params = %{
      "Action" => "ApplyPendingMaintenanceAction",
      "ResourceIdentifier" => resource_id,
      "ApplyAction" => action,
      "OptInType" => opt_in_type,
      "Version" => @version
    }

    request(:post, "/", query_params)
  end

  @type describe_db_instances_opts :: [
          {:DB_instance_identifier, binary}
          | [{:filter_member_1, filter}, ...]
          | {:marker, binary}
          | {:max_records, 20..100}
        ]
  @doc """
  Returns information about provisioned RDS instances.
  """
  @spec describe_db_instances() :: ExAws.Operation.RestQuery.t()
  @spec describe_db_instances(opts :: describe_db_instances_opts) :: ExAws.Operation.RestQuery.t()
  def describe_db_instances(opts \\ []) do
    query_params =
      opts
      |> normalize_opts()
      |> Map.merge(%{
        "Action" => "DescribeDBInstances",
        "Version" => @version
      })

    request(:get, "/", query_params)
  end

  @type mysql_port_range :: 1150..65535
  @type maria_db_port_range :: 1150..65535
  @type postgres_sql_port_range :: 1150..65535
  @type oracle_port_range :: 1150..65535
  @type sql_server_port_range :: 1150..65535
  @type amazon_aurora_port_rage :: 1150..65535

  @type create_db_instance_opts :: [
          {:auto_minor_version_upgrade, boolean}
          | {:availability_zone, binary}
          | {:backup_retention_period, integer}
          | {:character_set_name, binary}
          | {:copy_tags_to_snapshot, boolean}
          | {:db_cluster_identifier, binary}
          | {:db_name, binary}
          | {:db_parameter_group_name, binary}
          | [{:db_security_groups_member_1, [binary]}, ...]
          | {:db_subnet_group_name, binary}
          | {:domain, binary}
          | {:domain_iam_role_name, binary}
          | {:engine_version, binary}
          | {:iops, integer}
          | {:kms_key_id, binary}
          | {:license_model,
             :license_included | :bring_your_own_license | :general_public_license}
          | {:monitoring_interval, 0 | 1 | 5 | 10 | 15 | 30 | 60}
          | {:monitoring_role_arn, binary}
          | {:multi_az, boolean}
          | {:option_group_name, binary}
          | {:port,
             mysql_port_range
             | maria_db_port_range
             | postgres_sql_port_range
             | oracle_port_range
             | sql_server_port_range
             | amazon_aurora_port_rage}
          | {:preferred_backup_window, binary}
          | {:preferred_maintenance_window, binary}
          | {:promotion_tier, 0..15}
          | {:publicly_accessible, boolean}
          | {:storage_encrypted, boolean}
          | {:storage_type, :standard | :gp2 | :io1}
          | [{:tags_member_1, [tag]}, ...]
          | {:tde_credential_arn, binary}
          | {:tde_credential_password, binary}
          | [{:vpc_security_group_ids_member_1, [binary]}, ...]
        ]
  @doc """
  Creates a new DB instance.
  """
  @spec create_db_instance(
          instance_id :: binary,
          username :: binary,
          password :: binary,
          storage :: integer,
          class :: binary,
          engine :: binary
        ) :: ExAws.Operation.RestQuery.t()
  @spec create_db_instance(
          instance_id :: binary,
          username :: binary,
          password :: binary,
          storage :: integer,
          class :: binary,
          engine :: binary,
          opts :: create_db_instance_opts
        ) :: ExAws.Operation.RestQuery.t()
  def create_db_instance(instance_id, username, password, storage, class, engine, opts \\ []) do
    query_params =
      opts
      |> normalize_opts
      |> Map.merge(%{
        "Action" => "CreateDBInstance",
        "MasterUsername" => username,
        "MasterUserPassword" => password,
        "AllocatedStorage" => storage,
        "DBInstanceIdentifier" => instance_id,
        "DBInstanceClass" => class,
        "Engine" => engine,
        "Version" => @version
      })

    request(:post, "/", query_params)
  end

  @type mysql_allowed_storage :: 5..6144
  @type maria_db_allowed_storage :: 5..6144
  @type postgres_sql_allowed_storage :: 5..6144
  @type oracle_allowed_storage :: 10..6144

  @type modify_db_instance_opts :: [
          {:allocated_storage,
           mysql_allowed_storage
           | maria_db_allowed_storage
           | postgres_sql_allowed_storage
           | oracle_allowed_storage}
          | {:allow_major_version_upgrade, boolean}
          | {:apply_immediately, boolean}
          | {:auto_minor_version_upgrade, boolean}
          | {:backup_retention_period, integer}
          | {:ca_certificate_identifier, binary}
          | {:copy_tags_to_snapshot, boolean}
          | {:db_instance_class, db_instance_classes}
          | {:db_parameter_group_name, binary}
          | {:db_port_number,
             mysql_port_range
             | maria_db_port_range
             | postgres_sql_port_range
             | oracle_port_range
             | sql_server_port_range}
          | [{:sb_security_groups_member_1, [binary]}, ...]
          | {:domain, binary}
          | {:domain_iam_role_name, binary}
          | {:engine_version, binary}
          | {:iops, integer}
          | {:master_user_password, binary}
          | {:monitoring_interval, 0 | 1 | 5 | 10 | 15 | 30 | 60}
          | {:monitoring_role_arn, binary}
          | {:multi_az, boolean}
          | {:new_db_instance_identifier, binary}
          | {:option_group_name, binary}
          | {:preferred_backup_window, binary}
          | {:preferred_maintenance_window, binary}
          | {:promotion_tier, 0..15}
          | {:publicly_accessible, boolean}
          | {:storage_type, :standard | :gp2 | :io1}
          | {:tde_credential_arn, binary}
          | {:tde_credential_password, binary}
          | {:vpc_security_group_ids, [binary]}
        ]


  @doc """
  Modify settings for a DB instance.
  """
  @spec modify_db_instance(instance_id :: binary) :: ExAws.Operation.RestQuery.t()
  @spec modify_db_instance(instance_id :: binary, opts :: modify_db_instance_opts) ::
          ExAws.Operation.RestQuery.t()
  def modify_db_instance(instance_id, opts \\ []) do
    query_params =
      %{}
      |> extract_to(:vpc_security_group_ids, nil, opts)
      |> Map.merge(
        opts
        |> Keyword.drop([:vpc_security_group_ids])
        |> normalize_opts()
      )
      |> Map.merge(
        %{
          "Action"               => "ModifyDBInstance",
          "DBInstanceIdentifier" => instance_id,
          "Version"              => @version
        }
      )

    request(:patch, "/", query_params)
  end


  @type delete_db_instance_opts :: [
          {:final_db_snapshot_identifier, binary}
          | {:skip_final_snapshot, boolean}
        ]
  @doc """
  Deletes a DB instance.
  """
  @spec delete_db_instance(instance_id :: binary) :: ExAws.Operation.RestQuery.t()
  @spec delete_db_instance(instance_id :: binary, opts :: delete_db_instance_opts) ::
          ExAws.Operation.RestQuery.t()
  def delete_db_instance(instance_id, opts \\ []) do
    query_params =
      opts
      |> normalize_opts()
      |> Map.merge(%{
        "Action" => "DeleteDBInstance",
        "DBInstanceIdentifier" => instance_id,
        "Version" => @version
      })

    request(:delete, "/", query_params)
  end

  @type reboot_db_instance_opts :: [
          {:force_failover, boolean}
        ]
  @doc """
  Reboots a DB instance.
  """
  @spec reboot_db_instance(instance_id :: binary) :: ExAws.Operation.RestQuery.t()
  @spec reboot_db_instance(instance_id :: binary, opts :: reboot_db_instance_opts) ::
          ExAws.Operation.RestQuery.t()
  def reboot_db_instance(instance_id, opts \\ []) do
    query_params =
      opts
      |> normalize_opts()
      |> Map.merge(%{
        "Action" => "RebootDBInstance",
        "DBInstanceIdentifier" => instance_id,
        "Version" => @version
      })

    request(:get, "/", query_params)
  end

  @type describe_events_opts :: [
          {:duration, integer}
          | {:end_time, binary}
          | [{:event_categories_member_1, [binary]}, ...]
          | [{:filter_member_1, filter}, ...]
          | {:marker, binary}
          | {:max_records, 20..100}
          | {:source_identifier, binary}
          | {:source_type,
             :db_instance
             | :db_parameter_group
             | :db_security_group
             | :db_snapshot
             | :db_cluster
             | :db_cluster_snapsot}
          | {:start_time, binary}
        ]
  @doc """
  Returns events related to DB instances, DB security groups, DB snapshots,
  and DB parameter groups for the past 14 days.
  """
  @spec describe_events() :: ExAws.Operation.RestQuery.t()
  @spec describe_events(opts :: describe_db_instances_opts) :: ExAws.Operation.RestQuery.t()
  def describe_events(opts \\ []) do
    query_params =
      opts
      |> normalize_opts()
      |> Map.merge(%{
        "Action" => "DescribeEvents",
        "Version" => @version
      })

    request(:get, "/", query_params)
  end

  @type list_tags_for_resource_opts :: [
          [{:filter_member_1, filter}, ...]
        ]
  @doc """
  Lists all tags on an Amazon RDS resource.

  resource_name is the ARN for the RDS resource. Its returned from
  describe_db_instances. Although the doc implies that a filter
  could be used as as second parameter it also states:
  "This parameter is not currently supported" so don't attempt to
  use the opts for now.
  """
  @spec list_tags_for_resource(resource_name :: binary) :: ExAws.Operation.RestQuery.t()
  @spec list_tags_for_resource(opts :: list_tags_for_resource_opts) ::
          ExAws.Operation.RestQuery.t()
  def list_tags_for_resource(resource_name, opts \\ []) do
    query_params =
      opts
      |> normalize_opts()
      |> Map.merge(%{
        "Action" => "ListTagsForResource",
        "Version" => @version,
        "ResourceName" => resource_name
      })

    request(:get, "/", query_params)
  end

  @type describe_pending_maintenance_actions_opts :: [
          [{:filter_member_1, filter}, ...]
          | {:marker, binary}
          | {:max_records, 20..100}
          | {:resource_identifier, binary}
        ]
  @doc """
  Returns a list of resources (for example, DB instances) that have at least one pending maintenance action.

  The options don't seem to work. They don't work using the AWS CLI either.
  """
  @spec describe_pending_maintenance_actions() :: ExAws.Operation.RestQuery.t()
  @spec describe_pending_maintenance_actions(opts :: describe_pending_maintenance_actions_opts) ::
          ExAws.Operation.RestQuery.t()
  def describe_pending_maintenance_actions(opts \\ []) do
    query_params =
      opts
      |> normalize_opts()
      |> Map.merge(%{
        "Action" => "DescribePendingMaintenanceActions",
        "Version" => @version
      })

    request(:get, "/", query_params)
  end

  @type describe_db_clusters_opts :: [
          {:db_cluster_identifier, binary}
          | [{:filter_member_1, filter}, ...]
          | {:marker, binary}
          | {:max_records, 20..100}
        ]

  @doc """
  Returns information about provisioned Aurora DB clusters. This API supports pagination
  """
  @spec describe_db_clusters() :: ExAws.Operation.RestQuery.t()
  @spec describe_db_clusters(opts :: describe_db_clusters_opts) :: ExAws.Operation.RestQuery.t()
  def describe_db_clusters(opts \\ []) do
    query_params =
      opts
      |> normalize_opts()
      |> Map.merge(%{
        "Action" => "DescribeDBClusters",
        "Version" => @version
      })

    request(:get, "/", query_params)
  end

  # Portions copyright Daniel Bustamante Ospina 2020:
  @doc """
  Creates a DBSnapshot. The source DBInstance must be in "available" state.
  See <https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBSnapshot.html>
  """
  @spec create_db_snapshot(instance_id :: binary, snapshot_id :: binary) :: ExAws.Operation.RestQuery.t()
  def create_db_snapshot(instance_id, snapshot_id) do
    query_params = %{
      "Action"               => "CreateDBSnapshot",
      "DBInstanceIdentifier" => instance_id,
      "DBSnapshotIdentifier" => snapshot_id,
      "Version"              => @version
    }

    request(:post, "/", query_params)
  end


  @doc """
  Copies an AWS RDS instance snapshot to a new snapshot

  If an AWS KMS key ID is supplied, the copy (new) snapshot will be encrypted with that key.
  """
  @spec copy_db_snapshot(
    source_snapshot_id :: binary,
    target_snapshot_id :: binary,
    kms_key_id         :: binary | nil
  ) :: ExAws.Operation.RestQuery.t()
  def copy_db_snapshot(source_snapshot_id, target_snapshot_id, kms_key_id \\ nil) do

    query_params = %{
      "Action"                     => "CopyDBSnapshot",
      "SourceDBSnapshotIdentifier" => source_snapshot_id,
      "TargetDBSnapshotIdentifier" => target_snapshot_id,
      "Version"                    => @version
    }
    |> Map.merge(
      if is_nil(kms_key_id) do
        %{}
      else
        %{ "KmsKeyId" => kms_key_id }
      end
    )

    request(:post, "/", query_params)
  end


  @doc """
  Deletes a snapshot

  See:

  - [DeleteDBSnapshot - Amazon Relational Database Service](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_DeleteDBSnapshot.html)
  """
  @spec delete_db_snapshot(snapshot_id :: binary) :: ExAws.Operation.RestQuery.t()
  def delete_db_snapshot(snapshot_id) do
    query_params = %{
      "Action"               => "DeleteDBSnapshot",
      "DBSnapshotIdentifier" => snapshot_id,
      "Version"              => @version
    }

    request(:post, "/", query_params)
  end



  # Portions copyright Daniel Bustamante Ospina 2020:
  @type describe_db_snapshot_opts ::
  [
    {:include_public, binary}
    | {:marker, binary}
    | {:include_public, boolean}
    | {:include_shared, boolean}
    | {:snapshot_type, binary}
    | {:db_instance_identifier, binary}
    | {:db_snapshot_identifier, binary}
    | {:dbi_resource_id, binary}
    | {:max_records, 20..100}
  ]


  # Portions copyright Daniel Bustamante Ospina 2020:
  @doc """
  Returns an AWS query to return info about DB (RDS instance) snapshots

  See:

  - [DescribeDBSnapshots - Amazon Relational Database Service](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_DescribeDBSnapshots.html)
  """
  @spec describe_db_snapshots(opts :: describe_db_snapshot_opts) :: ExAws.Operation.RestQuery.t()
  def describe_db_snapshots(opts \\ []) do
    query_params = %{
      "Action"  => "DescribeDBSnapshots",
      "Version" => @version
    }
    # TODO: Move this 'extract' logic into `normalize_opts`?:
    |> extract_to(:db_snapshot_identifier, "DBSnapshotIdentifier", opts)
    |> extract_to(:db_instance_identifier, "DBInstanceIdentifier", opts)
    |> Map.merge(
      opts
      |> Keyword.drop([:db_snapshot_identifier, :db_instance_identifier])
      |> normalize_opts()
    )

    request(:post, "/", query_params)
  end


  @type restore_db_instance_from_db_snapshot_opts ::
  [
      { :instance_class,          binary   }
    | { :availability_zone,       binary   }
    | { :db_parameter_group_name, binary   }
    | { :vpc_security_group_ids,  [binary] }
  ]



  @doc """
  Restores an RDS instance snapshot to a new instance

  See:

  - [RestoreDBInstanceFromDBSnapshot - Amazon Relational Database Service](https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_RestoreDBInstanceFromDBSnapshot.html)
  """
  @spec restore_db_instance_from_db_snapshot(
    instance_id :: binary,
    snapshot_id :: binary,
    opts        :: restore_db_instance_from_db_snapshot_opts
  )
  :: ExAws.Operation.RestQuery.t
  def restore_db_instance_from_db_snapshot(instance_id, snapshot_id, opts \\ []) do

    query_params =
      %{}
      |> extract_to(:vpc_security_group_ids,  nil,                    opts)
      |> extract_to(:instance_class,          "DBInstanceClass",      opts)
      |> extract_to(:availability_zone,       "AvailabilityZone",     opts)
      |> extract_to(:db_parameter_group_name, "DBParameterGroupName", opts)
      |> Map.merge(
        %{
          "Action"               => "RestoreDBInstanceFromDBSnapshot",
          "DBInstanceIdentifier" => instance_id,
          "DBSnapshotIdentifier" => snapshot_id,
          "PubliclyAccessible"   => "false",
          "Version"              => @version
        }
      )

    request(:post, "/", query_params)
  end




  @doc """
  Removes metadata tags from an Amazon RDS resource

  For an overview on tagging an Amazon RDS resource, see [Tagging Amazon RDS
  Resources](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Overview.Tagging.html)
  in the Amazon RDS User Guide.

  ## Parameters:

    * resource - The Amazon RDS resource that the tags are removed from.
    This value is an Amazon Resource Name (ARN).

    * tag_keys - a List of the tag keys (name) of the tag to be removed
  """
  @spec remove_tags_from_resource(resource :: binary, tag_keys :: [binary, ...]) ::
          ExAws.Operation.RestQuery.t()
  def remove_tags_from_resource(resource, tag_keys) do
    query_params = %{
      "Action" => "RemoveTagsFromResource",
      "ResourceName" => resource,
      "Version" => @version
    }

    query_params =
      tag_keys
      |> Stream.with_index(1)
      |> Enum.reduce(query_params, fn {k, n}, tags_map ->
        tags_map
        |> Map.put("TagKeys.member.#{Integer.to_string(n)}", k)
      end)

    request(:post, "/", query_params)
  end


  @doc """
  Generates an auth token used to connect to a db with IAM credentials.
  See <http://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/UsingWithRDS.IAMDBAuth.Connecting.html>
  """
  @spec generate_db_auth_token(
          hostname :: binary,
          username :: binary,
          port :: integer,
          config :: map
        ) :: binary
  def generate_db_auth_token(hostname, username, port \\ 3306, config \\ %{}) do
    config = ExAws.Config.new(:rds, config)
    query_params = [Action: "connect", DBUser: username]
    datetime = :calendar.universal_time()
    # The signing utilities expect an actual URL, whereas RDS rejects a protocol on the token
    url = "https://#{hostname}:#{port}/"

    {:ok, token} =
      ExAws.Auth.presigned_url(:get, url, :"rds-db", datetime, config, 900, query_params, "")

    String.trim_leading(token, "https://")
  end



  # TODO: Combine with `normalize_opts/1` and rename to `opts_to_params`?:


  defp extract_to(map, :vpc_security_group_ids, _, keywords) do
    map
    |> Map.merge(
      case Keyword.get(keywords, :vpc_security_group_ids) do
        nil -> %{}


        vpc_security_group_ids ->

          vpc_security_group_ids
          |> Enum.with_index(
            fn group_id, index ->
              {
                "VpcSecurityGroupIds.VpcSecurityGroupId.#{index + 1}",
                group_id
              }
            end
          )
          |> Enum.into(%{})
      end
    )
  end


  defp extract_to(map, key, param_name, keywords) do
    case Keyword.get(keywords, key) do
      nil   -> map
      value -> Map.put(map, param_name, value)
    end
  end



  # TODO: Combine with `extract_to/4` and rename to `opts_to_params`?:
  defp normalize_opts(opts) do
    import ExAws.Utils, only: [camelize_keys: 1]

    opts
    |> Enum.into(%{})
    |> camelize_keys()
  end


  defp request(http_method, path, data) do
    %ExAws.Operation.RestQuery{
      http_method: http_method,
      path:        path,
      params:      data,
      service:     :rds
    }
  end

end
