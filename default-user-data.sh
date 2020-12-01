#!/bin/bash
echo ECS_CLUSTER=${ecs_cluster_name} >> /etc/ecs/ecs.config
echo ECS_RESERVED_MEMORY=256 >> /etc/ecs/ecs.config
echo "ECS_AVAILABLE_LOGGING_DRIVERS=[\"awslogs\",\"fluentd\",\"syslog\",\"json-file\"]" >> /etc/ecs/ecs.config