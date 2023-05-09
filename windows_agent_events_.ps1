# Download agent
(Invoke-WebRequest https://s3.amazonaws.com/ddagent-windows-stable/datadog-agent-7-latest.amd64.msi -OutFile c:\datadog-agent-7-latest.amd64.msi)

# Start the Datadog agent
# (Start-Process -Wait msiexec -ArgumentList '/qn /i c:\datadog-agent-7-latest.amd64.msi APIKEY=xxx HOSTNAME="my_hostname" TAGS="mytag1,mytag2"')
(Start-Process -Wait msiexec -ArgumentList '/qn /i c:\datadog-agent-7-latest.amd64.msi APIKEY="api_key"')

# Enable logs, live process, and agent configuration through the datadog UI
(Add-Content C:\ProgramData\Datadog\datadog.yaml "logs_enabled: true`nlogs_config:`n  use_compression: true`n  compression_level: 6`n  batch_wait: 5`n  open_files_limit: 500")
(Add-Content C:\ProgramData\Datadog\datadog.yaml "`nprocess_config:`n  process_collection:`n    enabled: `"true`"")
(Add-Content C:\ProgramData\Datadog\datadog.yaml "`ninventories_configuration_enabled: true")

# Delete Datadog agent .msi & .NET tracer agent v1.13x64
(Remove-Item -Path c:\datadog-agent-7-latest.amd64.msi) 

# Configure win32_event_log 
echo "init_config:
logs:
  - type: windows_event
    channel_path: Application
    source: windows.events
    service: Application_Event
  
  - type: windows_event
    channel_path: Security
    source: windows.events
    service: Security_Event

  - type: windows_event
    channel_path: Setup
    source: windows.events
    service: Setup_Event

  - type: windows_event
    channel_path: System
    source: windows.events
    service: System_Event" > C:\ProgramData\Datadog\conf.d\win32_event_log.d\conf.yaml 

# Restart the Datatdog Agent
Restart-Service -Name datadogagent -Force
