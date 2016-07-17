import UIKit

extension NSRange {
    func rangeForString(str: String) -> Range<String.Index>? {
        guard location != NSNotFound else { return nil }
        return str.startIndex.advancedBy(location) ..< str.startIndex.advancedBy(location + length)
    }
}

do {
    let teest = "\" style=\"\" data-aura-rendered-by=\"774:1345;a\" data-aura-class=\"uiInfiniteListRow forceActionRow forceListRecord forceRecordLayout\"><div class=\"body\" data-aura-rendered-by=\"775:1345;a\"><div class=\"sash hidden offlineSash\" data-aura-rendered-by=\"749:1345;a\" data-aura-class=\"offlineSash\"><span class=\"icon-fallback-text sashIcon forceIcon\" aria-hidden=\"true\" data-icon=\"\" data-key=\"arrowup\" data-aura-rendered-by=\"754:1345;a\" data-aura-class=\"forceIcon\"><span class=\"icon icon-key\" data-aura-rendered-by=\"755:1345;a\"></span></span><span class=\"newAssistiveText forceIcon\" data-aura-rendered-by=\"756:1345;a\" data-aura-class=\"forceIcon\"></span></div><a href=\"javascript:void(0);\" data-aura-rendered-by=\"759:1345;a\"><h3 class=\"itemTitle\" data-aura-rendered-by=\"761:1345;a\"><span class=\"photoContainer forceSocialPhoto forceOutputLookup\" data-aura-rendered-by=\"702:1345;a\" data-aura-class=\"forceSocialPhoto forceOutputLookup\"></span><span dir=\"ltr\" data-aura-rendered-by=\"706:1345;a\" class=\"uiOutputText forceOutputLookup\" data-aura-class=\"uiOutputText forceOutputLookup\">TCH-07-15-2016-1144835</span></h3><ul class=\"itemRows truncate\" data-aura-rendered-by=\"763:1345;a\"><li class=\"tableRowGroup\" data-aura-rendered-by=\"765:1345;a\"><div data-aura-rendered-by=\"716:1345;a\" class=\"forceListRecordItem\" data-aura-class=\"forceListRecordItem\"><div class=\"label recordCell truncate\" data-aura-rendered-by=\"717:1345;a\">Resource:</div><div class=\"value recordCell truncate\" data-aura-rendered-by=\"719:1345;a\"><!--render facet: 710:1345;a--><span dir=\"ltr\" data-aura-rendered-by=\"714:1345;a\" class=\"uiOutputText forceOutputLookup\" data-aura-class=\"uiOutputText forceOutputLookup\">Li Hongjing</span></div></div></li><li class=\"tableRowGroup\" data-aura-rendered-by=\"767:1345;a\"><div data-aura-rendered-by=\"730:1345;a\" class=\"forceListRecordItem\" data-aura-class=\"forceListRecordItem\"><div class=\"label recordCell truncate\" data-aura-rendered-by=\"731:1345;a\">Assignment:</div><div class=\"value recordCell truncate\" data-aura-rendered-by=\"733:1345;a\"><!--render facet: 724:1345;a--><span dir=\"ltr\" data-aura-rendered-by=\"728:1345;a\" class=\"uiOutputText forceOutputLookup\" data-aura-class=\"uiOutputText forceOutputLookup\"></span></div></div></li><li class=\"tableRowGroup\" data-aura-rendered-by=\"769:1345;a\"><div data-aura-rendered-by=\"740:1345;a\" class=\"forceListRecordItem\" data-aura-class=\"forceListRecordItem\"><div class=\"label recordCell truncate\" data-aura-rendered-by=\"741:1345;a\">Start Date:</div><div class=\"value recordCell truncate\" data-aura-rendered-by=\"743:1345;a\"><span data-aura-rendered-by=\"738:1345;a\" class=\"uiOutputDate\" data-aura-class=\"uiOutputDate\">2016-7-11</span></div></div></li></ul></a></div><div class=\"swipeBody\" aria-hidden=\"true\" data-aura-rendered-by=\"777:1345;a\"><!--render facet: 778:1345;a--></div></li><li class=\""
    
    let aarr = teest.componentsSeparatedByString("tableRowGroup")
    var contextStr = ""
    for context in aarr {
        if context.containsString("Resource:")
        {
            contextStr = context
            break
        }
    }
    
    let input = "\" data-aura-rendered-by=\"163:1345;a\"><div data-aura-rendered-by=\"114:1345;a\" class=\"forceListRecordItem\" data-aura-class=\"forceListRecordItem\"><div class=\"label recordCell truncate\" data-aura-rendered-by=\"115:1345;a\">Resource:</div><div class=\"value recordCell truncate\" data-aura-rendered-by=\"117:1345;a\"><!--render facet: 108:1345;a--><span dir=\"ltr\" data-aura-rendered-by=\"112:1345;a\" class=\"uiOutputText forceOutputLookup\" data-aura-class=\"uiOutputText forceOutputLookup\">Zhang Mingyun</span></div></div></li><li class=\""
    
    let regex = try NSRegularExpression(pattern: "uiOutputText forceOutputLookup\">(.*)</span></div></div>", options: NSRegularExpressionOptions.CaseInsensitive)
    let matches = regex.matchesInString(input, options: [], range: NSRange(location: 0, length: input.utf16.count))
    
    if let match = matches.first {
        let range = match.rangeAtIndex(1)
        if let swiftRange = range.rangeForString(input) {
            let name = input.substringWithRange(swiftRange)
            print(name)
        }
    }
} catch {
    // regex was bad!
}














