import type { Handler } from 'aws-lambda';
import { welcomeMessage } from './welcome';

const handler: Handler = async (event, context) => {
  console.log(event);

  return {
    statusCode: 200,
    body: JSON.stringify({ message: welcomeMessage('Hello World'), event }),
  };
};

export { handler };
