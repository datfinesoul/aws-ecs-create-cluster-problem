# Sample for AWS Support

## Case ID 7672914591

> This sets up the entire infrastructure for the problem example, with the exception of the ECS Cluster.  While we setup the basic infrastructure using terraform, Terraform is not required for this problem to occur.  Feel free to replicate the setup in cloudformation.

- Modify config.tf per your account.

> **Note**: ecs.tf.off is not going to be executed.  it's included to show the problem via terraform if so desired.

After the basic infrastructure is in place, the following samples show the problem.

## Problem Example

```bash
aws --region us-east-1 ecs create-cluster \
  --cluster-name "SAMPLE" --capacity-providers "SAMPLE" \
  --default-capacity-provider-strategy capacityProvider=SAMPLE,weight=100
```

```json
{
    "cluster": {
        "clusterArn": "arn:aws:ecs:us-east-1:988857891049:cluster/SAMPLE",
        "clusterName": "SAMPLE",
        "status": "PROVISIONING",
        "registeredContainerInstancesCount": 0,
        "runningTasksCount": 0,
        "pendingTasksCount": 0,
        "activeServicesCount": 0,
        "statistics": [],
        "tags": [],
        "settings": [
            {
                "name": "containerInsights",
                "value": "disabled"
            }
        ],
        "capacityProviders": [
            "SAMPLE"
        ],
        "defaultCapacityProviderStrategy": [
            {
                "capacityProvider": "SAMPLE",
                "weight": 100,
                "base": 0
            }
        ],
        "attachments": [
            {
                "id": "70070944-d1d8-4658-ab06-c82bed6ccdda",
                "type": "asp",
                "status": "PRECREATED",
                "details": [
                    {
                        "name": "capacityProviderName",
                        "value": "SAMPLE"
                    },
                    {
                        "name": "scalingPlanName",
                        "value": "ECSManagedAutoScalingPlan-73c42a2d-bf90-4296-80cc-7f46061f6f94"
                    }
                ]
            }
        ],
        "attachmentsStatus": "UPDATE_IN_PROGRESS"
    }
}
```

As you can see, it says it is **PROVISIONING**, but if you check the cluster afterwards you see the **FAILED** status.

```bash
aws --region us-east-1 ecs describe-clusters --clusters "SAMPLE"
```

```json
{
    "clusters": [
        {
            "clusterArn": "arn:aws:ecs:us-east-1:988857891049:cluster/SAMPLE",
            "clusterName": "SAMPLE",
            "status": "FAILED",
            "registeredContainerInstancesCount": 0,
            "runningTasksCount": 0,
            "pendingTasksCount": 0,
            "activeServicesCount": 0,
            "statistics": [],
            "tags": [],
            "settings": [
                {
                    "name": "containerInsights",
                    "value": "disabled"
                }
            ],
            "capacityProviders": [
                "SAMPLE"
            ],
            "defaultCapacityProviderStrategy": [
                {
                    "capacityProvider": "SAMPLE",
                    "weight": 100,
                    "base": 0
                }
            ]
        }
    ],
    "failures": []
}
```

## Example of it working when run as separate commands

Make sure to delete the previously FAILED cluster to see this work.  Once this is running, you see the ECS cluster **ACTIVE**.

```bash
aws --region us-east-1 ecs create-cluster --cluster-name "SAMPLE"
```

```json
{
    "cluster": {
        "clusterArn": "arn:aws:ecs:us-east-1:988857891049:cluster/SAMPLE",
        "clusterName": "SAMPLE",
        "status": "ACTIVE",
        "registeredContainerInstancesCount": 0,
        "runningTasksCount": 0,
        "pendingTasksCount": 0,
        "activeServicesCount": 0,
        "statistics": [],
        "tags": [],
        "settings": [
            {
                "name": "containerInsights",
                "value": "disabled"
            }
        ],
        "capacityProviders": [],
        "defaultCapacityProviderStrategy": []
    }
}
```

```bash
aws --region us-east-1 ecs put-cluster-capacity-providers \
  --cluster "SAMPLE" --capacity-providers "SAMPLE" \
  --default-capacity-provider-strategy capacityProvider=SAMPLE,weight=100
```

```json
{
    "cluster": {
        "clusterArn": "arn:aws:ecs:us-east-1:988857891049:cluster/SAMPLE",
        "clusterName": "SAMPLE",
        "status": "ACTIVE",
        "registeredContainerInstancesCount": 0,
        "runningTasksCount": 0,
        "pendingTasksCount": 0,
        "activeServicesCount": 0,
        "statistics": [],
        "tags": [],
        "settings": [
            {
                "name": "containerInsights",
                "value": "disabled"
            }
        ],
        "capacityProviders": [
            "SAMPLE"
        ],
        "defaultCapacityProviderStrategy": [
            {
                "capacityProvider": "SAMPLE",
                "weight": 100,
                "base": 0
            }
        ],
        "attachments": [
            {
                "id": "f4887eaa-a7a5-4d1a-9d6d-fdf5222332a1",
                "type": "asp",
                "status": "PRECREATED",
                "details": [
                    {
                        "name": "capacityProviderName",
                        "value": "SAMPLE"
                    },
                    {
                        "name": "scalingPlanName",
                        "value": "ECSManagedAutoScalingPlan-dd01d772-649b-46c1-ab29-b4c56b823688"
                    }
                ]
            }
        ],
        "attachmentsStatus": "UPDATE_IN_PROGRESS"
    }
} 
```

```bash
 aws --region us-east-1 ecs describe-clusters --clusters "SAMPLE"
```

 ```json
 {
    "clusters": [
        {
            "clusterArn": "arn:aws:ecs:us-east-1:988857891049:cluster/SAMPLE",
            "clusterName": "SAMPLE",
            "status": "ACTIVE",
            "registeredContainerInstancesCount": 0,
            "runningTasksCount": 0,
            "pendingTasksCount": 0,
            "activeServicesCount": 0,
            "statistics": [],
            "tags": [],
            "settings": [
                {
                    "name": "containerInsights",
                    "value": "disabled"
                }
            ],
            "capacityProviders": [
                "SAMPLE"
            ],
            "defaultCapacityProviderStrategy": [
                {
                    "capacityProvider": "SAMPLE",
                    "weight": 100,
                    "base": 0
                }
            ]
        }
    ],
    "failures": []
}
 ```

## Creating a Capacity Provider using the CLI

### Version that worked

```bash
aws ecs create-capacity-provider --name SAMPLE \
 --region us-east-1 \
 --auto-scaling-group-provider \
 autoScalingGroupArn=arn:aws:autoscaling:us-east-1:988857891049:autoScalingGroup:815fdeff-316b-49b7-9bbc-a82535530fe0:autoScalingGroupName/SAMPLE 
```

### When using the managedScaling settings, it fails

```bash
SAMPLE_ARN="arn:aws:autoscaling:us-east-1:988857891049:autoScalingGroup:815fdeff-316b-49b7-9bbc-a82535530fe0:autoScalingGroupName/SAMPLE"
aws ecs create-capacity-provider --name SAMPLE \
 --region us-east-1 \
 --auto-scaling-group-provider \
 "autoScalingGroupArn=${SAMPLE_ARN},managedScaling={status='ENABLED',targetCapacity=100},managedTerminationProtection='ENABLED'"
```

