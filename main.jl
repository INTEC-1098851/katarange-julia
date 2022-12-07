println("Esto es Kata Range")

# Julia
mutable struct Range
    startOpen::Bool
    startValue::Int64
    endValue::Int64
    endOpen::Bool
    Contains
    GetPoints
    ContainsRange
    EndPoints
    OverLapRange
    Equals
   

    function Range(rangeStr)
        this = new()

        validationRegex=r"(\(|\[)\d+\,\d+(\)|\])"
        matchInput = match(validationRegex,rangeStr)
        if string(matchInput) == "nothing"
            error("Rango invalido")
        end
        rangeArray = split(rangeStr,",")

        fromRange =first(rangeArray)
        this.startOpen= fromRange[1]=='('
        this.startValue = parse(Int64,string(fromRange[2:end]))

        toRange = last(rangeArray)
        this.endOpen = toRange[end]==')'
        this.endValue= parse(Int64,string(toRange[1:end-1]))
        if this.startValue>= this.endValue
            error("Rango invalido")
        end


        this.Contains = function(range::Vector{Int})
            sortedRange = sort(range)
            isOpenValid = (sortedRange[1]>= this.startValue && !this.startOpen) || (sortedRange[1]>this.startValue && this.startOpen);
            isEndValid = (sortedRange[length(sortedRange)]<= this.endValue && !this.endOpen) || (sortedRange[length(sortedRange)] < this.endValue && this.endOpen)
            return isOpenValid && isEndValid
        end

        this.GetPoints = function()
            startPointStr = if this.startOpen this.startValue+1 else this.startValue end
            endPointStr = if this.endOpen this.endValue-1 else this.endValue end
            startPoint = parse(Int64,string(startPointStr));
            endPoint = parse(Int64,string(endPointStr))
            return collect(startPoint:endPoint)
        end

        this.ContainsRange = function(other::Range)
            return this.Contains(other.GetPoints());
        end

        this.EndPoints = function()
            points = this.GetPoints()
            return collect([points[1]:points[end]])
        end

        this.OverLapRange = function(other::Range)
            return this.startValue<=other.endValue && this.endValue>= other.startValue
        end

        this.Equals = function(other::Range)
            return this.EndPoints()==other.EndPoints()
        end
        return this
    end

  

end
ex = Range("[2,6)")
ex1 = Range("(0,10)")

println(ex.GetPoints())
println([2,4])
println("Contains ",ex.Contains([2,4]))
println("")
ctr = Range("[2,5)")
ctr2 =Range("[7,10)")
ctr3 = Range("[2,10)")
ctr4 = Range("[3,5]")
println(ctr.GetPoints())
println(ctr2.GetPoints())
println("Contains Range ",ctr.ContainsRange(ctr2))
println("")
println(ctr3.GetPoints())
println(ctr4.GetPoints())
println("Contains Range ",ctr3.ContainsRange(ctr4))
println("")

ovl = Range("[2,5)")
ovl2 = Range("[7,10)")
println(ovl.GetPoints())
println(ovl2.GetPoints())
println("Overlaps ",ovl.OverLapRange(ovl2))
println("")


ovl3 = Range("[2,10)")
ovl4 = Range("[3,5)")
println(ovl3.GetPoints())
println(ovl4.GetPoints())
println("Overlaps ",ovl3.OverLapRange(ovl4))
println("")

eq = Range("[3,5)")
eq1 = Range("(2,4]")
println(eq.GetPoints())
println(eq1.GetPoints())
println("Equals ",eq.Equals(eq1))
println("")

eq3 = Range("[2,19)")
eq4 = Range("[3,5)")
println(eq3.GetPoints())
println(eq4.GetPoints())
println("Equals ",eq3.Equals(eq4))
println("")


