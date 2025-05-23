# Generated on 04/16/2025 21:38:23 by .\build\orca\Update-OrcaTests.ps1

[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseDeclaredVarsMoreThanAssignments', '')]
[Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSUseSingularNouns', '')]
param()

Function Get-PolicyStates
{
    <#
    .SYNOPSIS
        Returns hashtable of all policy GUIDs and if they are applied
    #>

    Param(
        $AntiphishPolicies,
        $AntiphishRules,
        $AntimalwarePolicies,
        $AntimalwareRules,
        $AntispamPolicies,
        $AntispamRules,
        $OutboundSpamPolicies,
        $OutboundSpamRules,
        $SafeLinksPolicies,
        $SafeLinksRules,
        $SafeAttachmentsPolicies,
        $SafeAttachmentRules,
        $ProtectionPolicyRulesATP,
        $ProtectionPolicyRulesEOP,
        $BuiltInProtectionRule
    )

    $ReturnPolicies = @{}

    $ReturnPolicies += Get-PolicyStateInt -Policies $AntiphishPolicies -Rules $AntiphishRules -Type ([PolicyType]::Antiphish) -ProtectionPolicyRules $ProtectionPolicyRulesEOP -BuiltInProtectionRule $BuiltInProtectionRule
    $ReturnPolicies += Get-PolicyStateInt -Policies $AntimalwarePolicies -Rules $AntimalwareRules -Type ([PolicyType]::Malware) -ProtectionPolicyRules $ProtectionPolicyRulesEOP
    $ReturnPolicies += Get-PolicyStateInt -Policies $AntispamPolicies -Rules $AntispamRules -Type ([PolicyType]::Spam) -ProtectionPolicyRules $ProtectionPolicyRulesEOP
    $ReturnPolicies += Get-PolicyStateInt -Policies $SafeLinksPolicies -Rules $SafeLinksRules -Type ([PolicyType]::SafeLinks) -ProtectionPolicyRules $ProtectionPolicyRulesATP -BuiltInProtectionRule $BuiltInProtectionRule
    $ReturnPolicies += Get-PolicyStateInt -Policies $SafeAttachmentsPolicies -Rules $SafeAttachmentRules -Type ([PolicyType]::SafeAttachments) -ProtectionPolicyRules $ProtectionPolicyRulesATP -BuiltInProtectionRule $BuiltInProtectionRule
    $ReturnPolicies += Get-PolicyStateInt -Policies $OutboundSpamPolicies -Rules $OutboundSpamRules -Type ([PolicyType]::OutboundSpam) -ProtectionPolicyRules $ProtectionPolicyRulesATP -BuiltInProtectionRule $BuiltInProtectionRule


    return $ReturnPolicies
}
