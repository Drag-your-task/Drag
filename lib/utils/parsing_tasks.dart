List<String> extractWordsAndCount(String tasks) {
  // 불용어 리스트
  Set<String> stopWords = Set.from([
    'the', 'is', 'and', 'of', 'in', 'on', 'a', 'about', 'above', 'after', 'again', 'against',
    'all', 'am', 'an', 'any', 'are', 'as', 'at', 'be', 'because', 'been', 'before', 'being',
    'below', 'between', 'both', 'but', 'by', 'could', 'did', 'do', 'does', 'doing', 'down',
    'during', 'each', 'few', 'for', 'from', 'further', 'had', 'has', 'have', 'having', 'he',
    'her', 'here', 'hers', 'herself', 'him', 'himself', 'his', 'how', 'i', 'if', 'into', 'it',
    'its', 'itself', 'just', 'me', 'more', 'most', 'my', 'myself', 'no', 'nor', 'not', 'now',
    'than', 'their', 'theirs', 'them', 'themselves', 'then', 'there', 'these', 'they', 'this',
    'those', 'through', 'to', 'too', 'under', 'until', 'up', 'very', 'was', 'we', 'were', 'what',
    'when', 'where', 'which', 'while', 'who', 'whom', 'why', 'with', 'would', 'you', 'your',
    'yours', 'yourself', 'yourselves', 'without', 'something', 'become', 'else', 'mine', 'ours',
    'somebody', 'someone', 'something', 'their', 'theirs', 'what', 'which', 'who', 'whom', 'whose',
    'whoever', 'whomever', 'whichever', 'whatever', 'whosesoever', 'whomsoever', 'whicheversoever',
    'whateversoever', 'whosesoever'
  ]);

  // 정규 표현식을 사용하여 알파벳과 숫자를 제외한 모든 문자 제거
  var words = tasks.replaceAll(RegExp(r'[^a-zA-Z0-9\s]'), ' ').split(' ');

  // 빈 문자열을 제거하고 소문자로 변환
  words = words.map((word) => word.toLowerCase()).where((word) => word.isNotEmpty).toList();

  // 불용어 제거 및 빈도 수 계산
  Map<String, int> frequencyMap = {};
  for (String word in words) {
    if (!stopWords.contains(word)) {
      frequencyMap[word] = (frequencyMap[word] ?? 0) + 1;
    }
  }

  // 빈도 수가 많은 순으로 정렬 (선택적)
  List<MapEntry<String, int>> sortedEntries = frequencyMap.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  // 결과 반환
  return sortedEntries.map((entry) => entry.key).toList();
}

/*

이 코드의 시간 복잡도를 분석하면 다음과 같습니다:

1. **텍스트 정제 (`replaceAll` 및 `split`)**: 문자열의 길이를 \( n \)이라고 할 때, `replaceAll` 및 `split` 작업은 각각 \( O(n) \)의 시간 복잡도를 가집니다.

2. **단어 소문자 변환 및 빈 문자열 제거**: 이 부분도 \( O(n) \) 시간 복잡도를 가지며, 모든 단어에 대해 반복 작업을 수행합니다.

3. **불용어 제거 및 빈도 수 계산**: 각 단어에 대해 불용어 집합에서의 포함 여부를 확인하고 빈도 수를 업데이트합니다. 불용어 집합에서의 조회는 \( O(1) \)이며, 전체 단어의 개수를 \( m \)이라 할 때, 이 부분의 시간 복잡도는 \( O(m) \)입니다.

4. **정렬**: \( m \)개의 단어를 기반으로 정렬하는데, 평균적으로 \( O(m \log m) \)의 시간 복잡도를 가집니다.

따라서 전체적인 시간 복잡도는 \( O(n) + O(m) + O(m \log m) \)이 됩니다. 여기서 \( n \)은 원래 텍스트의 길이, \( m \)은 추출된 단어의 개수입니다. 텍스트의 길이가 단어의 개수보다 훨씬 클 경우 \( O(n) \)이 지배적일 수 있고, 그렇지 않은 경우 \( O(m \log m) \)이 지배적일 수 있습니다.

*/