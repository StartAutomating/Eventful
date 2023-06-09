#requires -Module PSSVG

$assetsPath = Join-Path $PSScriptRoot Assets

if (-not (Test-Path $assetsPath)) {
    $null = New-Item -ItemType Directory -path $assetsPath -Force
}
=<svg> -content $(
    $commonParameters = [Ordered]@{
        Fill        = '#4488FF'
        Stroke      = 'black'
        StrokeWidth = '0.05'
    }

    =<svg.symbol> -Id psChevron -Content @(
        =<svg.polygon> -Points (@(
            "40,20"
            "45,20"
            "60,50"
            "35,80"
            "32.5,80"
            "55,50"
        ) -join ' ')
    ) -ViewBox 100, 100

    
    =<svg.use> -Href '#psChevron' -X -25% -Y 35% @commonParameters -Height 30% -Opacity .9
    # =<svg.text> -Text '>' -X 20 -Y 50 -FontSize 48 -Rotate -7 -FontFamily monospace @commonParameters
    =<svg.text> -Text @(
        =<svg.tspan> -Content '@' -Dx -8.5em -FontFamily sans-serif  -FontSize 4 -DominantBaseline 'middle'
        =<svg.tspan> -Content 'eventful' -TextAnchor 'left' -FontFamily monospace -Dx -.4em -DominantBaseline 'middle' -Dy 0em

        # =<svg.tspan> -Content '@' -Dx -8.5em -FontFamily sans-serif  -FontSize 4 -DominantBaseline 'middle' -Dy -1em
    ) -X 40% -Y 50%  -FontSize 24 -FontFamily monospace @commonParameters 
    
    <#=<svg.text> -Text @(        
        =<svg.tspan> -Content 'eventful' -TextAnchor 'left' -FontFamily monospace -Dx -1em
    ) -X 40% -Y 56%  -FontSize 24 -FontFamily monospace @commonParameters 
    =<svg.text> -Text @(        
        =<svg.tspan> -Content '@' -TextAnchor 'right' -FontFamily sans-serif -Dx -1em
    ) -X 25% -Y 53%  -FontSize 12 -FontFamily monospace @commonParameters #>
    # =<svg.text> -Text 'SVG' -X 70% -Y 53.5% -FontSize 36 -FontFamily monospace -FontStretch "10%" -FontWeight 150 @commonParameters -DominantBaseline 'middle' -TextAnchor 'middle' -Opacity .9
    
) -ViewBox 0, 0, 200, 100 -OutputPath $(    
    Join-Path (Join-Path $PSScriptRoot Assets) Eventful.svg
)