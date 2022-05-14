BEGIN{
    max=1;
}
{
    split($0,cant,"|")
    print $cant[0]
    print $cant[2]
    current=$cant[1]
    if($current -gt $max){
        max=$current
    }
}
END	{
    print $current
}