# Generated on 04/16/2025 21:38:23 by .\build\orca\Update-OrcaTests.ps1

using module ".\orcaClass.psm1"

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingEmptyCatchBlock', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSPossibleIncorrectComparisonWithNull', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingCmdletAliases', '')]
param()




class ORCA114 : ORCACheck
{
    <#
    
        CONSTRUCTOR with Check Header Data
    
    #>

    ORCA114()
    {
        $this.Control=114
        $this.Area="Anti-Spam Policies"
        $this.Name="IP Allow Lists"
        $this.PassText="No IP Allow Lists have been configured"
        $this.FailRecommendation="Remove IP addresses from IP allow list"
        $this.Importance="IP addresses contained in the IP allow list are able to bypass spam, phishing and spoofing checks, potentially resulting in more spam. Ensure that the IP list is kept to a minimum."
        $this.ExpandResults=$True
        $this.ItemName="Anti-Spam Policy"
        $this.DataType="Allowed IP"
        $this.ChiValue=[ORCACHI]::Medium
        $this.Links= @{
            "Microsoft 365 Defender Portal - Anti-spam settings"="https://security.microsoft.com/antispam"
            "Use Anti-Spam Policy IP Allow lists"="https://aka.ms/orca-antispam-docs-3"
        }
    }

    <#
    
        RESULTS
    
    #>

    GetResults($Config)
    {
    
        $CountOfPolicies = ($Config["HostedConnectionFilterPolicy"]).Count
        ForEach($HostedConnectionFilterPolicy in $Config["HostedConnectionFilterPolicy"]) 
        {
            $IsBuiltIn = $false
            $policyname = $($HostedConnectionFilterPolicy.Name)
            $IPAllowList = $($HostedConnectionFilterPolicy.IPAllowList)

            <#
            
            Important! Do not apply read-only to preset policies here.
            
            #>

            # Check if IPAllowList < 0 and return inconclusive for manual checking of size
            If($IPAllowList.Count -gt 0)
            {
                # IP Allow list present
                ForEach($IPAddr in @($IPAllowList)) 
                {
                    # Check objects
                    $ConfigObject = [ORCACheckConfig]::new()
                    $ConfigObject.ConfigItem=$policyname
                    $ConfigObject.ConfigData=$IPAddr
                    $ConfigObject.ConfigPolicyGuid=$HostedConnectionFilterPolicy.Guid.ToString()
                    $ConfigObject.ConfigDisabled = $Config["PolicyStates"][$HostedConnectionFilterPolicy.Guid.ToString()].Disabled
                    $ConfigObject.ConfigWontApply = !$Config["PolicyStates"][$HostedConnectionFilterPolicy.Guid.ToString()].Applies
                    $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Fail")
                    $this.AddConfig($ConfigObject)  
                }
    
            } 
            else 
            {
                # Check objects
                $ConfigObject = [ORCACheckConfig]::new()
                $ConfigObject.ConfigItem=$policyname
                $ConfigObject.ConfigData="No IP detected"
                $ConfigObject.ConfigPolicyGuid=$HostedConnectionFilterPolicy.Guid.ToString()
                $ConfigObject.ConfigDisabled = $Config["PolicyStates"][$HostedConnectionFilterPolicy.Guid.ToString()].Disabled
                $ConfigObject.ConfigWontApply = !$Config["PolicyStates"][$HostedConnectionFilterPolicy.Guid.ToString()].Applies
                $ConfigObject.SetResult([ORCAConfigLevel]::Standard,"Pass")

                $this.AddConfig($ConfigObject) 
            }
        }        

    }

}
