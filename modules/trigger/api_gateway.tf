resource aws_apigatewayv2_api stress_trigger_api {
  name          = "stress-trigger-api"
  protocol_type = "HTTP"
}

resource aws_apigatewayv2_integration lambda_integration {
  api_id           = aws_apigatewayv2_api.stress_trigger_api.id
  integration_type = "AWS_PROXY"
  integration_uri  = aws_lambda_function.lambda_function.invoke_arn
}

resource aws_apigatewayv2_route stress_trigger_route {
  api_id    = aws_apigatewayv2_api.stress_trigger_api.id
  route_key = "GET /stress"
  target    = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

resource aws_apigatewayv2_stage stress_trigger_stage {
  api_id      = aws_apigatewayv2_api.stress_trigger_api.id
  name        = var.env_name
  auto_deploy = true
}

resource aws_lambda_permission api_gateway_invoke {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_function.function_name
  principal     = "apigateway.amazonaws.com"
}