defmodule GatewayWeb.DataController do
  use GatewayWeb, :controller

  action_fallback GatewayWeb.FallbackController
end
