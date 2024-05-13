def solution(arr):
    for i in range(len(arr)):  # 리스트의 각 요소에 접근하기 위해 인덱스를 사용
        if arr[i] >= 50 and arr[i] % 2 == 0:  # 값이 50 이상이고 짝수인 경우
            arr[i] //= 2  # 2로 나눈다
        elif arr[i] < 50 and arr[i] % 2 != 0:  # 값이 50 미만이고 홀수인 경우
            arr[i] *= 2  # 2를 곱한다
    return arr