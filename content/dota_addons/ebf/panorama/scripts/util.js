/// <reference path="dota.d.ts" />
function Clamp(num, min, max) {
    return num <= min ? min : (num >= max ? max : num);
}
function Lerp(percent, a, b) {
    return a + percent * (b - a);
}
function RemapVal(num, a, b, c, d) {
    if (a == b)
        return c;
    const percent = (num - a) / (b - a);
    return Lerp(percent, c, d);
}
function RemapValClamped(num, a, b, c, d) {
    if (a == b)
        return c;
    const percent = Clamp((num - a) / (b - a), 0.0, 1.0);
    return Lerp(percent, c, d);
}
function ToMap(arr, key) {
    const map = {};
    arr.forEach((v, i) => map[key(v, i, arr)] = v);
    return map;
}
function Compare(a, b) {
    return a < b ? -1 : a > b ? 1 : 0;
}
function SortBy(values, ...orderParams) {
    values.sort((a, b) => {
        for (const orderParam of orderParams) {
            let result;
            if (typeof orderParam === "function") {
                result = Compare(orderParam(a), orderParam(b));
            }
            else {
                result = Compare(a[orderParam], b[orderParam]);
            }
            if (result !== 0) {
                return result;
            }
        }
        return 0;
    });
}
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoidXRpbC5qcyIsInNvdXJjZVJvb3QiOiIiLCJzb3VyY2VzIjpbInV0aWwudHMiXSwibmFtZXMiOltdLCJtYXBwaW5ncyI6IkFBQUEsa0NBQWtDO0FBRWxDLFNBQVMsS0FBSyxDQUFFLEdBQVcsRUFBRSxHQUFXLEVBQUUsR0FBVztJQUVwRCxPQUFPLEdBQUcsSUFBSSxHQUFHLENBQUMsQ0FBQyxDQUFDLEdBQUcsQ0FBQyxDQUFDLENBQUMsQ0FBRSxHQUFHLElBQUksR0FBRyxDQUFDLENBQUMsQ0FBQyxHQUFHLENBQUMsQ0FBQyxDQUFDLEdBQUcsQ0FBRSxDQUFDO0FBQ3RELENBQUM7QUFFRCxTQUFTLElBQUksQ0FBRSxPQUFlLEVBQUUsQ0FBUyxFQUFFLENBQVM7SUFFbkQsT0FBTyxDQUFDLEdBQUcsT0FBTyxHQUFHLENBQUUsQ0FBQyxHQUFHLENBQUMsQ0FBRSxDQUFDO0FBQ2hDLENBQUM7QUFFRCxTQUFTLFFBQVEsQ0FBRSxHQUFXLEVBQUUsQ0FBUyxFQUFFLENBQVMsRUFBRSxDQUFTLEVBQUUsQ0FBUztJQUV6RSxJQUFLLENBQUMsSUFBSSxDQUFDO1FBQ1YsT0FBTyxDQUFDLENBQUM7SUFFVixNQUFNLE9BQU8sR0FBRyxDQUFFLEdBQUcsR0FBRyxDQUFDLENBQUUsR0FBRyxDQUFFLENBQUMsR0FBRyxDQUFDLENBQUUsQ0FBQztJQUN4QyxPQUFPLElBQUksQ0FBRSxPQUFPLEVBQUUsQ0FBQyxFQUFFLENBQUMsQ0FBRSxDQUFDO0FBQzlCLENBQUM7QUFFRCxTQUFTLGVBQWUsQ0FBRSxHQUFXLEVBQUUsQ0FBUyxFQUFFLENBQVMsRUFBRSxDQUFTLEVBQUUsQ0FBUztJQUVoRixJQUFLLENBQUMsSUFBSSxDQUFDO1FBQ1YsT0FBTyxDQUFDLENBQUM7SUFFVixNQUFNLE9BQU8sR0FBRyxLQUFLLENBQUUsQ0FBRSxHQUFHLEdBQUcsQ0FBQyxDQUFFLEdBQUcsQ0FBRSxDQUFDLEdBQUcsQ0FBQyxDQUFFLEVBQUUsR0FBRyxFQUFFLEdBQUcsQ0FBRSxDQUFDO0lBRTNELE9BQU8sSUFBSSxDQUFFLE9BQU8sRUFBRSxDQUFDLEVBQUUsQ0FBQyxDQUFFLENBQUM7QUFDOUIsQ0FBQztBQUVELFNBQVMsS0FBSyxDQUFnQyxHQUFRLEVBQUUsR0FBK0M7SUFFdEcsTUFBTSxHQUFHLEdBQWtCLEVBQUUsQ0FBQztJQUM5QixHQUFHLENBQUMsT0FBTyxDQUFFLENBQUUsQ0FBQyxFQUFFLENBQUMsRUFBRyxFQUFFLENBQUMsR0FBRyxDQUFDLEdBQUcsQ0FBRSxDQUFDLEVBQUUsQ0FBQyxFQUFFLEdBQUcsQ0FBRSxDQUFDLEdBQUcsQ0FBQyxDQUFFLENBQUM7SUFDckQsT0FBTyxHQUFHLENBQUM7QUFDWixDQUFDO0FBRUQsU0FBUyxPQUFPLENBQUssQ0FBSSxFQUFFLENBQUk7SUFFM0IsT0FBTyxDQUFDLEdBQUcsQ0FBQyxDQUFDLENBQUMsQ0FBQyxDQUFDLENBQUMsQ0FBQyxDQUFDLENBQUMsQ0FBQyxHQUFHLENBQUMsQ0FBQyxDQUFDLENBQUMsQ0FBQyxDQUFDLENBQUMsQ0FBQyxDQUFDLENBQUM7QUFDdEMsQ0FBQztBQUdELFNBQVMsTUFBTSxDQUFLLE1BQVcsRUFBRSxHQUFHLFdBQStCO0lBRS9ELE1BQU0sQ0FBQyxJQUFJLENBQUUsQ0FBRSxDQUFDLEVBQUUsQ0FBQyxFQUFHLEVBQUU7UUFFcEIsS0FBTSxNQUFNLFVBQVUsSUFBSSxXQUFXLEVBQ3JDO1lBQ0ksSUFBSSxNQUFjLENBQUM7WUFDbkIsSUFBSyxPQUFPLFVBQVUsS0FBSyxVQUFVLEVBQ3JDO2dCQUNJLE1BQU0sR0FBRyxPQUFPLENBQUUsVUFBVSxDQUFFLENBQUMsQ0FBRSxFQUFFLFVBQVUsQ0FBRSxDQUFDLENBQUUsQ0FBRSxDQUFDO2FBQ3hEO2lCQUVEO2dCQUNJLE1BQU0sR0FBRyxPQUFPLENBQUUsQ0FBQyxDQUFDLFVBQVUsQ0FBQyxFQUFFLENBQUMsQ0FBQyxVQUFVLENBQUMsQ0FBRSxDQUFDO2FBQ3BEO1lBQ0QsSUFBSyxNQUFNLEtBQUssQ0FBQyxFQUNqQjtnQkFDSSxPQUFPLE1BQU0sQ0FBQzthQUNqQjtTQUNKO1FBQ0QsT0FBTyxDQUFDLENBQUM7SUFDYixDQUFDLENBQUUsQ0FBQztBQUNSLENBQUMifQ==