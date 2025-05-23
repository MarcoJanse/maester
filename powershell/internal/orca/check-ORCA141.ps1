# Generated on 04/16/2025 21:38:23 by .\build\orca\Update-OrcaTests.ps1

using module ".\orcaClass.psm1"

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingEmptyCatchBlock', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSPossibleIncorrectComparisonWithNull', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidGlobalVars', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSAvoidUsingCmdletAliases', '')]
param()




class ORCA141 : ORCACheck
{
    <#
    
        CONSTRUCTOR with Check Header Data
    
    #>

    ORCA141()
    {
        $this.Control=141
        $this.Area="Anti-Spam Policies"
        $this.Name="Bulk Action"
        $this.PassText="Bulk action set to Move message to Junk Email Folder"
        $this.FailRecommendation="Change bulk action to move messages to junk mail folder"
        $this.Importance="It is recommended to configure Bulk detection action to Move messages to Junk Email folder."
        $this.ExpandResults=$True
        $this.ItemName="Anti-Spam Policy"
        $this.DataType="Action"
        $this.Links= @{
            "Microsoft 365 Defender Portal - Anti-spam settings"="https://security.microsoft.com/antispam"
            "Recommended settings for EOP and Microsoft Defender for Office 365"="https://aka.ms/orca-atpp-docs-6"
        }
    }

    <#
    
        RESULTS
    
    #>

    GetResults($Config)
    {
        #$CountOfPolicies = ($Config["HostedContentFilterPolicy"]).Count  
        $CountOfPolicies = ($global:HostedContentPolicyStatus| Where-Object {$_.IsEnabled -eq $True}).Count
       
        ForEach($Policy in $Config["HostedContentFilterPolicy"]) 
        {
            $IsPolicyDisabled = !$Config["PolicyStates"][$Policy.Guid.ToString()].Applies
            $BulkSpamAction = $($Policy.BulkSpamAction)

            $IsBuiltIn = $false
            $policyname = $Config["PolicyStates"][$Policy.Guid.ToString()].Name

            # Check objects
            $ConfigObject = [ORCACheckConfig]::new()
            $ConfigObject.ConfigItem=$policyname
            $ConfigObject.ConfigReadonly=$Policy.IsPreset
            $ConfigObject.ConfigDisabled = $Config["PolicyStates"][$Policy.Guid.ToString()].Disabled
            $ConfigObject.ConfigWontApply = !$Config["PolicyStates"][$Policy.Guid.ToString()].Applies
            $ConfigObject.ConfigPolicyGuid=$Policy.Guid.ToString()

            # For standard Fail if BulkSpamAction is not set to MoveToJmf
    
            If($BulkSpamAction -ne "MoveToJmf") 
            {
                $ConfigObject.ConfigData=$($BulkSpamAction)
                $ConfigObject.SetResult([ORCAConfigLevel]::Standard,[ORCAResult]::Fail)
            } 
            else 
            {
                $ConfigObject.ConfigData=$($BulkSpamAction)
                $ConfigObject.SetResult([ORCAConfigLevel]::Standard,[ORCAResult]::Pass)
            }

            # For strict Fail if BulkSpamAction is not set to Quarantine

            If($BulkSpamAction -ne "Quarantine") 
            {
                $ConfigObject.ConfigData=$($BulkSpamAction)
                $ConfigObject.SetResult([ORCAConfigLevel]::Strict,[ORCAResult]::Fail)
            } 
            else 
            {
                $ConfigObject.ConfigData=$($BulkSpamAction)
                $ConfigObject.SetResult([ORCAConfigLevel]::Strict,[ORCAResult]::Pass)
            }

            # For either Delete or Quarantine we should raise an informational

            If($BulkSpamAction -eq "Delete" -or $BulkSpamAction -eq "Redirect")
            {
                $ConfigObject.ConfigData=$($BulkSpamAction)
                $ConfigObject.SetResult([ORCAConfigLevel]::All,[ORCAResult]::Informational)
                $ConfigObject.InfoText = "The $($BulkSpamAction) option may impact the users ability to release emails and may impact user experience."
            }
            
            $this.AddConfig($ConfigObject)

        }        

    }

}
