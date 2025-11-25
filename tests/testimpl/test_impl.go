// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package testimpl

import (
	"context"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/ecs"
	ecstypes "github.com/aws/aws-sdk-go-v2/service/ecs/types"
	"github.com/gruntwork-io/terratest/modules/terraform"
	lcafTypes "github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

const (
	failedToDescribeServiceMsg = "Failed to describe ECS service"
	failedToGetServiceTagsMsg  = "Failed to list ECS service tags"
)

func TestComposableComplete(t *testing.T, ctx lcafTypes.TestContext) {
	ecsClient := GetAWSECSClient(t)

	serviceArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "service_id")
	serviceName := terraform.Output(t, ctx.TerratestTerraformOptions(), "service_name")
	clusterArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "cluster_arn")

	t.Run("TestECSServiceExists", func(t *testing.T) {
		testECSServiceExists(t, ecsClient, serviceArn, serviceName, clusterArn)
	})

	t.Run("TestECSServiceProperties", func(t *testing.T) {
		testECSServiceProperties(t, ecsClient, serviceArn, serviceName, clusterArn)
	})

	t.Run("TestECSServiceTags", func(t *testing.T) {
		var serviceTags map[string]interface{}
		terraform.OutputStruct(t, ctx.TerratestTerraformOptions(), "service_tags", &serviceTags)
		testECSServiceTags(t, ecsClient, serviceArn, clusterArn, serviceTags)
	})
}

func testECSServiceExists(t *testing.T, ecsClient *ecs.Client, serviceArn, serviceName, clusterArn string) {
	serviceOutput, err := ecsClient.DescribeServices(context.TODO(), &ecs.DescribeServicesInput{
		Services: []string{serviceName},
		Cluster:  aws.String(clusterArn),
		Include:  []ecstypes.ServiceField{ecstypes.ServiceFieldTags},
	})
	require.NoError(t, err, failedToDescribeServiceMsg)
	require.NotNil(t, serviceOutput.Services, "Services should not be nil")
	require.Greater(t, len(serviceOutput.Services), 0, "At least one service should be returned")
	assert.Equal(t, serviceArn, *serviceOutput.Services[0].ServiceArn,
		"Expected service ARN did not match actual ARN!")
	assert.Equal(t, serviceName, *serviceOutput.Services[0].ServiceName,
		"Expected service name did not match actual name!")
}

func testECSServiceProperties(t *testing.T, ecsClient *ecs.Client, serviceArn, serviceName, clusterArn string) {
	serviceOutput, err := ecsClient.DescribeServices(context.TODO(), &ecs.DescribeServicesInput{
		Services: []string{serviceName},
		Cluster:  aws.String(clusterArn),
	})
	require.NoError(t, err, failedToDescribeServiceMsg)
	require.NotNil(t, serviceOutput.Services, "Services should not be nil")
	require.Greater(t, len(serviceOutput.Services), 0, "At least one service should be returned")

	service := serviceOutput.Services[0]

	// Verify service name and ARN
	assert.Equal(t, serviceName, *service.ServiceName, "Service name should match expected value")
	assert.Equal(t, serviceArn, *service.ServiceArn, "Service ARN should match expected value")

	// Verify service status
	assert.Equal(t, "ACTIVE", *service.Status, "Service status should be ACTIVE")

	// Verify cluster ARN
	assert.Equal(t, clusterArn, *service.ClusterArn, "Cluster ARN should match expected value")

	// Verify desired count
	assert.NotNil(t, service.DesiredCount, "Desired count should not be nil")

	// Verify launch type
	assert.NotNil(t, service.LaunchType, "Launch type should not be nil")

	// Verify task definition
	assert.NotNil(t, service.TaskDefinition, "Task definition should not be nil")
}

func testECSServiceTags(t *testing.T, ecsClient *ecs.Client, serviceArn, clusterArn string, expectedTags map[string]interface{}) {
	if len(expectedTags) == 0 {
		return
	}

	serviceOutput, err := ecsClient.DescribeServices(context.TODO(), &ecs.DescribeServicesInput{
		Services: []string{serviceArn},
		Cluster:  aws.String(clusterArn),
		Include:  []ecstypes.ServiceField{ecstypes.ServiceFieldTags},
	})
	require.NoError(t, err, failedToGetServiceTagsMsg)
	require.NotNil(t, serviceOutput.Services, "Services should not be nil")
	require.Greater(t, len(serviceOutput.Services), 0, "At least one service should be returned")

	// Convert AWS tags to map for comparison
	actualTags := make(map[string]string)
	for _, tag := range serviceOutput.Services[0].Tags {
		actualTags[*tag.Key] = *tag.Value
	}

	// Verify expected tags exist
	for key, value := range expectedTags {
		if valueStr, ok := value.(string); ok {
			assert.Equal(t, valueStr, actualTags[key], "Tag %s should have expected value", key)
		}
	}
}

func GetAWSECSClient(t *testing.T) *ecs.Client {
	awsECSClient := ecs.NewFromConfig(GetAWSConfig(t))
	return awsECSClient
}

func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}
