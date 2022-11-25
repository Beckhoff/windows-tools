#####################################
## Add New ADS Route
#####################################

# Location of routes file
$routesPath = "C:\TwinCAT\3.1\Target"
$routesFile = "StaticRoutes.xml"

# Create a new Route Element
$xmlfile = [xml](Get-Content "$routesPath\$routesFile")
$new_route_node =$xmlfile.SelectSingleNode("//TcConfig/RemoteConnections")

$new_route_node.AppendChild($xmlfile.CreateElement("Route"))|out-null
$new_route_node = $xmlfile.SelectSingleNode("//TcConfig/RemoteConnections/Route")

# Add a new name "RemoteSystem123" for the route
$new_name_node = $new_route_node.AppendChild($xmlfile.CreateElement("Name"))
$new_name_node.AppendChild($xmlfile.CreateTextNode("RemoteSystem123")) | Out-Null

# Add IP address "192.168.1.75" for the route
$new_address_node = $new_route_node.AppendChild($xmlfile.CreateElement("Address"))
$new_address_node.AppendChild($xmlfile.CreateTextNode("192.168.1.75")) | Out-Null

# Add NetId "192.168.1.75.1.1" for the route
$new_netid_node = $new_route_node.AppendChild($xmlfile.CreateElement("NetId"))
$new_netid_node.AppendChild($xmlfile.CreateTextNode("192.168.1.75.1.1")) | Out-Null

# Add a route type
$new_type_node = $new_route_node.AppendChild($xmlfile.CreateElement("Type"))
$new_type_node.AppendChild($xmlfile.CreateTextNode("TCP_IP")) | Out-Null

# Add route flags
$new_flags_node = $new_route_node.AppendChild($xmlfile.CreateElement("Flags"))
$new_flags_node.AppendChild($xmlfile.CreateTextNode("64")) | Out-Null

# Save the new route
$xmlfile.save("$routesPath\$routesFile")

#########################################