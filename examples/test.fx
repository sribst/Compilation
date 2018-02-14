def z(x) = x * 2
def f(x) =
    val y = z (x) in
    x + y end

val res =
    val x = f(4) in
    	0 - x
    end