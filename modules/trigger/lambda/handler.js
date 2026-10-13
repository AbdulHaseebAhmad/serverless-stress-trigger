import { SNSClient, PublishCommand } from "@aws-sdk/client-sns";
import { SSMClient, SendCommandCommand } from "@aws-sdk/client-ssm";
import crypto from "crypto";
const ssmClient = new SSMClient({}); //create client
const snsClient = new SNSClient({});

export const handler = async (event) => {
  let result;
  let snsresult;
  let message;
  if (event.queryStringParameters) {
    const action = event.queryStringParameters.action;
    if (action === "start") {
      const command = new SendCommandCommand({
        DocumentName: "AWS-RunShellScript",
        InstanceIds: [process.env.INSTANCE_ID],
        Parameters: {
          commands: ["sudo systemctl start stress-ng.service"],
        },
      });
      message = {
        action,
        InstanceIds: [process.env.INSTANCE_ID],
        TimeStamp: new Date().toISOString(),
      };
      try {
        result = await ssmClient.send(command);
        const snsCommand = new PublishCommand({
          TopicArn: process.env.SNS_TOPIC_ARN,
          Message: JSON.stringify(message),
          MessageGroupId: "stress-updates",
          MessageDeduplicationId: crypto.randomUUID(),
        });

        snsresult = await snsClient.send(snsCommand);
      } catch (e) {
        return {
          statusCode: 400,
          body: JSON.stringify({
            message: `The action requested failed `,
            error: e,
          }),
        };
      }
    } else if (action === "stop") {
      const command = new SendCommandCommand({
        DocumentName: "AWS-RunShellScript",
        InstanceIds: [process.env.INSTANCE_ID],
        Parameters: {
          commands: ["sudo systemctl stop stress-ng.service"],
        },
      });
      message = {
        action,
        InstanceIds: [process.env.INSTANCE_ID],
        TimeStamp: new Date().toISOString(),
      };
      try {
        result = await ssmClient.send(command);
        const snsCommand = new PublishCommand({
          TopicArn: process.env.SNS_TOPIC_ARN,
          Message: JSON.stringify(message),
          MessageDeduplicationId: crypto.randomUUID(),
          MessageDeduplicationId: crypto.randomUUID(),
        });

        snsresult = await snsClient.send(snsCommand);
      } catch (e) {
        return {
          statusCode: 400,
          body: JSON.stringify({
            message: `The action requested failed `,
            error: e,
          }),
        };
      }
    } else {
      return {
        statusCode: 400,
        body: JSON.stringify({
          message: `The action requested is invalid `,
        }),
      };
    }
    return {
      statusCode: 200,
      body: JSON.stringify({
        message: `Stress test ${action === "start" ? "requested" : "stopped"} `,
        commandId: result.Command.CommandId,
      }),
    };
  } else {
    return {
      statusCode: 400,
      body: JSON.stringify({
        message: `Invalid Action `,
      }),
    };
  }
};
