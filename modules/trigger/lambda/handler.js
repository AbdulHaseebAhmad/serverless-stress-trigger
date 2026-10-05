import { SSMClient, SendCommandCommand } from "@aws-sdk/client-ssm";

const ssmClient = new SSMClient({}); //create client
export const handler = async (event) => {
  let result;
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
      try {
        result = await ssmClient.send(command);
      } catch (e) {
        return {
          statusCode: 400,
          body: JSON.stringify({
            message: `The action requested failed `,
            error:e,
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
      try {
        result = await ssmClient.send(command);
      } catch (e) {
        return {
          statusCode: 400,
          body: JSON.stringify({
            message: `The action requested failed `,
            error:e,
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
