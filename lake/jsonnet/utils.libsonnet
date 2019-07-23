{
    f(acc, elem)::
        if std.isArray(elem) then
            if std.length(elem) > 1 then
               acc + $.f([], elem[0]) + $.f([], elem[1:std.length(elem)])
            else if std.length(elem) == 1 then
               acc + $.f([], elem[0])
            else
               acc
        else
            acc + [elem],

    deepFlatten(arrs)::
        std.foldl($.f, arrs, [])
}