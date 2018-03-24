//
//  3. Knuth–Morris–Pratt (KMP) pattern in Swift.swift
//  
//
//  Created by Inna Soboleva on 3/23/18.
//

func getArray(_ search: String) -> [Int] {
    var suffix = [Int]()
    var word = Array(search)
    var i = 0
    var j = 1
    var added = true
    suffix.append(0)
    for _ in 1..<word.count {
        if word[i] == word[j] {
            suffix.append(1 + i)
            i += 1
        } else {
            while i > 0 {
                i = suffix[i - 1]
                if word[i] == word[j] {
                    suffix.append(1 + i)
                    i += 1
                    added = false
                    break
                } else {
                    continue
                }
            }
            if added {
                suffix.append(i)
                added = true
            }
        }
        j += 1
    }
    return suffix
}

func isSubstring(_ s2: String, in s1: String) -> Bool {
    s1
    var suffix = getArray(s2)
    var arr_big = Array(s1)
    var arr_small = Array(s2)
    var i = 0
    var j = 0
    while j < arr_big.count {
        
        while i < arr_small.count && j < arr_big.count && arr_small[i] == arr_big[j] {
            i += 1
            j += 1
        }
        if i == arr_small.count { return true } else if j == arr_big.count {
            return false
        }
        while i > 0 {
            if i >= 1 {
                i = suffix[i-1]
            } else {
                i = 0
            }
            while i < arr_small.count && j < arr_big.count && arr_small[i] == arr_big[j] {
                i += 1
                j += 1
            }
            if i == arr_small.count { return true } else if j == arr_big.count {
                return false
            }
        }
        j += 1
    }
    if i == arr_small.count {
        return true
    }
    return false
}

print(isSubstring("abcaby", in: "abxabcabcaby"))
