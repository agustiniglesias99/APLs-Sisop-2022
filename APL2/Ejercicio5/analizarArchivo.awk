BEGIN{
    max=1;
}
{
    split($0,cant,"|")
    current=cant[1]
    if($current -gt $max){
        max=$current
    }
}
END	{
    print $current
}