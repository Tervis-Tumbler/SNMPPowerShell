function Get-SNMPTreeWalk {
    param (
        [Parameter(Mandatory)]$ComputerName
    )

    $SNMP = new-object -ComObject olePrn.OleSNMP
    $SNMP.open($ComputerName,"public",2,3000)
    1..1000 | % {
        $Result = $SNMP.gettree($_)
        if ($Result) {
            ConvertFrom-TwoDimensionalArray -Array $Result
        }
    }    
    $SNMP.Close()
}


function ConvertFrom-TwoDimensionalArray {
    param (
        [Parameter(Mandatory)]$Array
    )

    $NumberOfDimensions = $Array.Rank
    if ($NumberOfDimensions -gt 2 ) { Throw "Array has more than 2 dimensions" }
    
    $Object = [PSCustomObject]@{}
    
    foreach ($ElementIndex in 0..($Array.GetLength(1)-1)) {
        $Object | Add-Member -MemberType NoteProperty -Name $Array[0,$ElementIndex] -Value $Array[1,$ElementIndex]
    }

    $Object
}

#Comment by David here: http://powershelldistrict.com/how-to-combine-powershell-objects/
function Merge-Object {
    param(
        [Parameter(Mandatory)][PSCustomObject]$Object1,
        [Parameter(Mandatory)][PSCustomObject]$Object2
    )

    $object3 = New-Object -TypeName PSObject

    foreach ( $Property in $Object1.PSObject.Properties) {
        $arguments += @{$Property.Name = $Property.value}

        $object3 | Add-Member -MemberType NoteProperty -Name $Property.Name -Value $Property.value
    }

    foreach ( $Property in $Object2.PSObject.Properties) {
        $object3 | Add-Member -MemberType NoteProperty -Name $Property.Name -Value $Property.value
    }

    return $object3
}