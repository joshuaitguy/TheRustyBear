$url = "https://umod.org/plugins/raidable-bases"
$webResponse = Invoke-WebRequest -Uri $url

$regex = [Regex]::new("v\d\.\d\.\d(?:\.\d)?")

$regex.IsMatch($webResponse.Content) -eq $true

$regex.Match($webResponse.Content).Value

# [mshtml.HTMLDocumentClass]$html = (Invoke-WebRequest -Uri $url).ParsedHTML

# $html.

# $html.getElementByTagName('span') | %{
    
# }