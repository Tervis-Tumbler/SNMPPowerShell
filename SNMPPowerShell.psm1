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
