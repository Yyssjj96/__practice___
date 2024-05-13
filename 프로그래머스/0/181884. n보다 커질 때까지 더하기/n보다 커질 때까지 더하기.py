def solution(numbers, n):
    answer = 0
    for i in numbers :
        if n < answer :
            return answer
        else :
            answer += i
    return answer
        