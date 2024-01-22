import quiz_list
import random
import voice

# 퀴즈 리스트를 가져와 랜덤으로 골라주는 함수 입니다.
def get_random_quiz():
  # import된 퀴즈를 사용합니다.
  quiz_lists = quiz_list.quiz_lists
  # 퀴즈의 개수를 사용하여 랜덤으로 숫자를 하나 선택해줍니다.
  random_quiz_number = random.randint(0, len(quiz_lists)-1)
  # 랜덤숫자를 사용해 하나의 퀴즈를 가져옵니다.
  quiz = quiz_lists[random_quiz_number]
  # 퀴즈의 정답과 힌트를 가져와 리턴해줍니다.
  quiz_answer = quiz["answer"]
  quiz_hints = quiz["questions"]
  return quiz_answer, quiz_hints

# 선택된 문제를 풀어보는 함수 입니다.
def solve_quiz(quiz_answer, quiz_hint) :
  score = 10 # 초기 점수를 10으로 설정합니다.

  # for문을 사용하여 힌트를 하나씩 가져옵니다.
  for hint in quiz_hint :
    # 몇번째 힌트인지 안내합니다.
    voice.speech("%d번 힌트 입니다."%(quiz_hint.index(hint)+1))
    # 힌트를 음성출력합니다.
    voice.speech(hint)
    # STT를 통해 정답을 인식합니다.
    input_text = voice.get_text_from_voice()
    # 인식된 결과가 정답일 경우 정답이라고 말하고 점수를 리턴합니다.
    if input_text.find(quiz_answer) != -1 :
      voice.speech("정답입니다.")
      return score
    # 인식된 결과가 없거나 다음이라고 인식되면 1점을 감점하고 다음힌트를 출력합니다.
    elif input_text == "" or input_text.find("다음") != -1 :
      voice.speech("땡 오답입니다.")
      score -= 1
      continue
    # 인식된 답이 틀린 답이라면 2점을 감점합니다.
    else :
      voice.speech("땡 오답입니다.")
      score -= 2
      continue
  # 끝까지 정답을 인식하지 못한 경우에는 정답을 안내하고 점수를 리턴합니다.
  else :
    answer_text = "정답은 %s입니다."%quiz_answer
    return score
    print(answer_text)

def main() :
  voice.speech("지금부터 퀴즈를 시작하겠습니다. 힌트를 듣고 정답을 말해주세요")
  quiz_answer, quiz_hint = get_random_quiz() #랜덤 퀴즈를 받아옵니다.
  # 랜덤 퀴즈를 입력해주고 퀴즈 결과 점수를 받아옵니다
  result_score = solve_quiz(quiz_answer, quiz_hint)
  # 점수를 음성출력해줍니다.
  voice.speech("점수는 %d점 입니다."%result_score)



if __name__ == "__main__" :
  main()