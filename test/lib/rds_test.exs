defmodule ExAws.RDSTest do

  use ExUnit.Case, async: true

  alias ExAws.RDS


  # TODO: Replace all/most of these tests with 'options to request parameters' tests?


  test "insert instance no options" do
    params = %{
      "Action" => "CreateDBInstance",
      "AllocatedStorage" => 5,
      "DBInstanceClass" => "db.t1.micro",
      "DBInstanceIdentifier" => "some-instance",
      "Engine" => "MySQL",
      "MasterUserPassword" => "mypassword",
      "MasterUsername" => "awsuser",
      "Version" => "2014-10-31"
    }

    expected = base_rest_query(params, :post)

    assert expected ==
             RDS.create_db_instance(
               "some-instance",
               "awsuser",
               "mypassword",
               5,
               "db.t1.micro",
               "MySQL"
             )
  end


  test "insert instance with options" do
    params = %{
      "Action" => "CreateDBInstance",
      "AllocatedStorage" => 5,
      "DBInstanceClass" => "db.t1.micro",
      "DBInstanceIdentifier" => "some-instance",
      "Engine" => "MySQL",
      "MasterUserPassword" => "mypassword",
      "MasterUsername" => "awsuser",
      "Version" => "2014-10-31",
      "AutoMinorVersionUpgrade" => true,
      "AvailabilityZone" => "us-east-1e",
      "MonitoringInterval" => 10
    }

    expected = base_rest_query(params, :post)

    assert expected ==
             RDS.create_db_instance(
               "some-instance",
               "awsuser",
               "mypassword",
               5,
               "db.t1.micro",
               "MySQL",
               auto_minor_version_upgrade: true,
               availability_zone: "us-east-1e",
               monitoring_interval: 10
             )
  end


  test "describe_db_instances no options" do
    params = %{"Action" => "DescribeDBInstances", "Version" => "2014-10-31"}

    expected = base_rest_query(params)
    assert expected == RDS.describe_db_instances()
  end


  test "describe_db_instances with options" do
    params = %{
      "Action" => "DescribeDBInstances",
      "Version" => "2014-10-31",
      "MaxRecords" => 10,
      "Filter.Member.1" => "some_filter"
    }

    expected = base_rest_query(params)

    assert expected ==
             RDS.describe_db_instances(max_records: 10, "Filter.Member.1": "some_filter")
  end


  test "modify_db_instance no options" do
    params = %{
      "Action" => "ModifyDBInstance",
      "Version" => "2014-10-31",
      "DBInstanceIdentifier" => "some_instance"
    }

    expected = base_rest_query(params, :patch)

    assert expected == RDS.modify_db_instance("some_instance")
  end


  test "modify_db_instance with options" do
    params = %{
      "Action" => "ModifyDBInstance",
      "Version" => "2014-10-31",
      "DBInstanceIdentifier" => "some_instance",
      "AllocatedStorage" => 20,
      "DomainIamRoleName" => "some_iam_name",
      "Iops" => 20000,
      "PubliclyAccessible" => true
    }

    expected = base_rest_query(params, :patch)

    assert expected ==
             RDS.modify_db_instance(
               "some_instance",
               allocated_storage: 20,
               domain_iam_role_name: "some_iam_name",
               iops: 20000,
               publicly_accessible: true
             )
  end


  test "delete_db_instance no options" do
    params = %{
      "Action" => "DeleteDBInstance",
      "Version" => "2014-10-31",
      "DBInstanceIdentifier" => "some_instance"
    }

    expected = base_rest_query(params, :delete)

    assert expected == RDS.delete_db_instance("some_instance")
  end


  test "delete_db_instance with options" do
    params = %{
      "Action" => "DeleteDBInstance",
      "Version" => "2014-10-31",
      "DBInstanceIdentifier" => "some_instance",
      "SkipFinalSnapshot" => true
    }

    expected = base_rest_query(params, :delete)

    assert expected == RDS.delete_db_instance("some_instance", skip_final_snapshot: true)
  end


  test "describe_events no options" do
    params = %{
      "Action" => "DescribeEvents",
      "Version" => "2014-10-31"
    }

    expected = base_rest_query(params)

    assert expected == RDS.describe_events()
  end


  test "describe_events with options" do
    params = %{
      "Action" => "DescribeEvents",
      "Version" => "2014-10-31",
      "Duration" => 50,
      "EventCategories.member.1" => "some_event_category",
      "SourceType" => "DbInstance"
    }

    expected = base_rest_query(params)

    result =
      RDS.describe_events(
        duration: 50,
        "EventCategories.member.1": "some_event_category",
        source_type: "DbInstance"
      )

    assert expected == result
  end


  test "reboot_db_instance no options" do
    params = %{
      "Action" => "RebootDBInstance",
      "Version" => "2014-10-31",
      "DBInstanceIdentifier" => "some_instance"
    }

    expected = base_rest_query(params)

    assert expected == RDS.reboot_db_instance("some_instance")
  end


  test "reboot_db_instance with options" do
    params = %{
      "Action" => "RebootDBInstance",
      "Version" => "2014-10-31",
      "DBInstanceIdentifier" => "some_instance",
      "ForceFailover" => true
    }

    expected = base_rest_query(params)

    assert expected == RDS.reboot_db_instance("some_instance", force_failover: true)
  end


  test "apply_pending_maintenance" do
    params = %{
      "Action" => "ApplyPendingMaintenanceAction",
      "Version" => "2014-10-31",
      "ResourceIdentifier" => "some_resource_id",
      "ApplyAction" => "some_action",
      "OptInType" => "some_type"
    }

    expected = base_rest_query(params, :post)
    result = RDS.apply_pending_maintenance("some_resource_id", "some_action", "some_type")

    assert expected == result
  end


  test "add_source_id_to_subscription" do
    params = %{
      "Action" => "AddSourceIdentifierToSubscription",
      "Version" => "2014-10-31",
      "SourceIdentifier" => "some_source_id",
      "SubscriptionName" => "some_subscription"
    }

    expected = base_rest_query(params, :post)

    assert expected == RDS.add_source_id_to_subscription("some_source_id", "some_subscription")
  end


  test "add_tags_to_resource" do
    params = %{
      "Action" => "AddTagsToResource",
      "Version" => "2014-10-31",
      "ResourceName" => "some_resource",
      "Tags.member.1.Key" => "key1",
      "Tags.member.1.Value" => "value1",
      "Tags.member.2.Key" => "key2",
      "Tags.member.2.Value" => "value2"
    }

    expected = base_rest_query(params, :post)
    result = RDS.add_tags_to_resource("some_resource", [{"key1", "value1"}, {"key2", "value2"}])

    assert expected == result
  end


  test "list_tags_for_resource" do
    params = %{
      "Action" => "ListTagsForResource",
      "Version" => "2014-10-31",
      "ResourceName" => "arn:some-arn"
    }

    expected = base_rest_query(params)

    assert expected == RDS.list_tags_for_resource("arn:some-arn")
  end


  test "describe_db_clusters" do
    params = %{"Action" => "DescribeDBClusters", "Version" => "2014-10-31"}
    expected = base_rest_query(params)
    assert expected == RDS.describe_db_clusters()
  end

  test "describe_pending_maintenance_actions" do
    params = %{"Action" => "DescribePendingMaintenanceActions", "Version" => "2014-10-31"}
    expected = base_rest_query(params)
    assert expected == RDS.describe_pending_maintenance_actions()
  end


  # Copyright Daniel Bustamante Ospina 2020:
  test "create_db_snapshot" do
    params = %{
      "Action" => "CreateDBSnapshot",
      "Version" => "2014-10-31",
      "DBInstanceIdentifier" => "mysqldb-02",
      "DBSnapshotIdentifier" => "mySQLdb-snap-1"
    }

    expected = base_rest_query(params, :post)
    assert expected == RDS.create_db_snapshot("mysqldb-02", "mySQLdb-snap-1")
  end


  # Copyright Daniel Bustamante Ospina 2020:
  test "describe_db_snapshots" do
    params = %{
      "Action" => "DescribeDBSnapshots",
      "Version" => "2014-10-31",
      "DBInstanceIdentifier" => "mysqldb-02",
      "DBSnapshotIdentifier" => "some_id",
      "DbiResourceId" => "arn:value",
      "IncludePublic" => false,
      "IncludeShared" => true,
      "MaxRecords" => 10
    }

    expected = base_rest_query(params, :post)

    assert expected ==
             RDS.describe_db_snapshots(
               max_records: 10,
               include_public: false,
               include_shared: true,
               dbi_resource_id: "arn:value",
               db_instance_identifier: "mysqldb-02",
               db_snapshot_identifier: "some_id"
             )
  end


  # Copyright Daniel Bustamante Ospina 2020:
  test "describe_db_snapshots no params" do
    params = %{
      "Action" => "DescribeDBSnapshots",
      "Version" => "2014-10-31"
    }

    expected = base_rest_query(params, :post)
    assert expected == RDS.describe_db_snapshots()
  end


  test "remove tags from resource" do
    params = %{
      "Action" => "RemoveTagsFromResource",
      "Version" => "2014-10-31",
      "ResourceName" => "some_resource",
      "TagKeys.member.1" => "key1",
      "TagKeys.member.2" => "key2"
    }

    expected = base_rest_query(params, :post)
    result = RDS.remove_tags_from_resource("some_resource", ["key1", "key2"])
    assert expected == result
  end



  defp base_rest_query(params, http_method \\ :get) do
    %ExAws.Operation.RestQuery{
      action: nil,
      body: "",
      http_method: http_method,
      parser: &ExAws.Utils.identity/2,
      path: "/",
      params: params,
      service: :rds
    }
  end

end
