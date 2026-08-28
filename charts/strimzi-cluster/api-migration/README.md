# Strimzi Cluster Helm Chart :: API v1 Migration
When looking to upgrade Strimzi from 0.51.0 to 1.x.x, one of the most important steps is migrating the Strimzi CRD storage versions from `v1beta2` to `v1`. Converting existing custom resources to `v1` does not by itself mean that the corresponding objects persisted in Kubernetes' etcd database have been rewritten to `v1`, nor does it remove `v1beta2` from the CRD's `status.storedVersions`. The migration therefore needs to recreate the existing custom resources so that their representations are persisted in etcd under `v1`. This will allow `v1beta2` to be removed from `status.storedVersions` before the new CRDs can be applied successfully. The following section shows how to migrate CRs to `v1` and how to do the storage version migration. Once this is complete, the built-in upgrade feature can be used to complete the Strimzi CRD upgrade.

## Migrating API versions v1beta2 to v1
In Strimzi 1.0.0, support for `v1beta2` was removed. Version 0.51.0 acts as a bridge release because its CRDs support CRs using `v1beta2` and `v1`. CRD upgrades are blocked by design until the storage versions are migrated to `v1` in 0.51.0. For example, trying to upgrade the CRDs while still using the `v1beta2` storage version will trigger an error similar to the below:

```bash
status.storedVersions[0]: invalid value: "v1beta2": missing from spec.versions, v1beta2 was previously a storage version, and must remain in spec.versions until a storage migration ensures no data remains persisted in v1beta2 and removes v1beta2 from the status.storedVersions.
```

This is a safety feature that serves as a reminder to finish the migration. The following summarizes the steps needed for this version jump.

### Migration steps
The steps below show how to do the migration from inside the Kubernetes cluster, which is also compatible with Helm-based deployments.

1. Migrate all CRs to `v1`. This will require updating the configuration defined in the CR to align with the target API version. Strimzi has a tool to help with this, but it may be easier to do it manually since the tool still requires manual edits anyway. See [Converting Strimzi custom resources to the v1 API](https://strimzi.io/docs/operators/1.0.0/deploying#assembly-api-conversion-str) for more details.
2. This next step is the critical part that is easily missed, migrating the storage versions. But first, check the current state of the storage version for each CRD using the below command. The output should be similar to the one in the example.

    ```bash
    kubectl get crd -o name | grep kafka.strimzi.io | while read crd; do
      echo -n "$crd  "
      kubectl get "$crd" -o jsonpath='{.status.storedVersions}{"\n"}'
    done
    ```

    🔳 **Output**

    ```bash
    customresourcedefinition.apiextensions.k8s.io/kafkabridges.kafka.strimzi.io  ["v1beta2"]
    customresourcedefinition.apiextensions.k8s.io/kafkaconnectors.kafka.strimzi.io  ["v1beta2"]
    customresourcedefinition.apiextensions.k8s.io/kafkaconnects.kafka.strimzi.io  ["v1beta2"]
    customresourcedefinition.apiextensions.k8s.io/kafkamirrormaker2s.kafka.strimzi.io  ["v1beta2"]
    customresourcedefinition.apiextensions.k8s.io/kafkanodepools.kafka.strimzi.io  ["v1beta2"]
    customresourcedefinition.apiextensions.k8s.io/kafkarebalances.kafka.strimzi.io  ["v1beta2"]
    customresourcedefinition.apiextensions.k8s.io/kafkas.kafka.strimzi.io  ["v1beta2"]
    customresourcedefinition.apiextensions.k8s.io/kafkatopics.kafka.strimzi.io  ["v1beta2"]
    customresourcedefinition.apiextensions.k8s.io/kafkausers.kafka.strimzi.io  ["v1beta2"]
    ```
3. Run the CRD migration job. Like in the example below, this will recreate the storage representation of each CR under `v1`, and then, update the storage version of each CRD. The Job's logs should be similar to the below example.

    ```bash
    kubectl apply -f https://raw.githubusercontent.com/StevenJDH/helm-charts/refs/heads/main/charts/strimzi-cluster/api-migration/strimzi-v1-api-conversion-job.yaml
    ```

    <table>
    <tr>
    <td>

    > [!IMPORTANT]
    > The file referenced above uses the `strimzi` namespace, which may need updating. If so, download it to edit it, and run it locally.

    </td>
    </tr>
    </table>

    🔳 **Logs**

    ```bash
    Checking that the CRDs are present and have the desired API versions.
    Changing stored version in all Strimzi CRDs to v1:
    Updating Kafka CRD
    Updating KafkaRebalance CRD
    Updating KafkaUser CRD
    Updating KafkaMirrorMaker2 CRD
    Updating KafkaConnect CRD
    Updating StrimziPodSet CRD
    Updating KafkaConnector CRD
    Updating KafkaTopic CRD
    Updating KafkaBridge CRD
    Updating KafkaNodePool CRD

    Updating all Strimzi CRs to be stored under v1:
    Updating Kafka my-strimzi-cluster to be stored as v1
    Updating KafkaRebalance my-strimzi-cluster-full-rebalance to be stored as v1
    Updating StrimziPodSet my-strimzi-cluster-broker to be stored as v1
    Updating StrimziPodSet my-strimzi-cluster-kraft-controller to be stored as v1
    Updating KafkaNodePool broker to be stored as v1
    Updating KafkaNodePool kraft-controller to be stored as v1

    Changing stored version in statuses of all Strimzi CRDs to v1:
    Updating Kafka CRD
    Updating KafkaRebalance CRD
    Updating KafkaUser CRD
    Updating KafkaMirrorMaker2 CRD
    Updating KafkaConnect CRD
    Updating StrimziPodSet CRD
    Updating KafkaConnector CRD
    Updating KafkaTopic CRD
    Updating KafkaBridge CRD
    Updating KafkaNodePool CRD
    ```

4. Recheck the state of the storage version for each CRD. Confirm that all CRDs return `["v1"]` as the stored version.

    ```bash
    kubectl get crd -o name | grep kafka.strimzi.io | while read crd; do
      echo -n "$crd  "
      kubectl get "$crd" -o jsonpath='{.status.storedVersions}{"\n"}'
    done
    ```

    🔳 **Output**

    ```bash
    customresourcedefinition.apiextensions.k8s.io/kafkabridges.kafka.strimzi.io  ["v1"]
    customresourcedefinition.apiextensions.k8s.io/kafkaconnectors.kafka.strimzi.io  ["v1"]
    customresourcedefinition.apiextensions.k8s.io/kafkaconnects.kafka.strimzi.io  ["v1"]
    customresourcedefinition.apiextensions.k8s.io/kafkamirrormaker2s.kafka.strimzi.io  ["v1"]
    customresourcedefinition.apiextensions.k8s.io/kafkanodepools.kafka.strimzi.io  ["v1"]
    customresourcedefinition.apiextensions.k8s.io/kafkarebalances.kafka.strimzi.io  ["v1"]
    customresourcedefinition.apiextensions.k8s.io/kafkas.kafka.strimzi.io  ["v1"]
    customresourcedefinition.apiextensions.k8s.io/kafkatopics.kafka.strimzi.io  ["v1"]
    customresourcedefinition.apiextensions.k8s.io/kafkausers.kafka.strimzi.io  ["v1"]
    ```

5. Finally, remove the migration job with the following command:

    ```bash
    kubectl delete -f https://raw.githubusercontent.com/StevenJDH/helm-charts/refs/heads/main/charts/strimzi-cluster/api-migration/strimzi-v1-api-conversion-job.yaml
    ```

From this point on, it is safe to upgrade to Strimzi 1.x.x using the built-in CRD upgrade feature of my strimzi-cluster helm chart, or by whatever method was previously used. As a side note, the migration job has a commented out command for upgrading the CR resources as well, but this is expected to fail because of manual migration related changes being needed. Feel free to play around with it if there is interest.


// Steven Jenkins De Haro ("StevenJDH" on GitHub)
