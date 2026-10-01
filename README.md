# Folio Studio

문서(TXT, MD, HTML, PDF, DOCX, PPTX)를 브라우저에서 읽어 Gemini로 전자책을 구성하고 HTML, EPUB, 인쇄용 PDF, 웹 배포 ZIP으로 내보내는 로컬 웹 앱입니다.

## 실행

```bash
chmod +x scripts/*.sh
./scripts/serve_supervised.sh 4173
```

브라우저에서 `http://127.0.0.1:4173`을 엽니다. 서버 프로세스가 종료되면 부모 감시기가 2초 뒤 자동 재시작합니다.

## 사용자가 준비할 것

Google AI Studio에서 발급한 Gemini API 키 1개만 필요합니다. 앱의 **AI 연결**에서 입력하며 키는 현재 탭의 `sessionStorage`에만 보관됩니다. 내보낸 전자책에는 키가 들어가지 않습니다.

## 제한

- 스캔 이미지로만 구성된 PDF는 OCR 후 넣어야 합니다.
- 파일당 20MB, 전체 텍스트 200,000자를 권장 상한으로 표시합니다.
- 문서 파싱과 ZIP/EPUB 생성용 라이브러리를 CDN에서 불러오므로 최초 실행에는 인터넷 연결이 필요합니다.
- Gemini API의 429 및 5xx 응답은 지수 백오프로 최대 5회 재시도합니다. 완료한 장은 매 장마다 저장됩니다.

## 감시기 복구 시험

```bash
./scripts/watchdog_selftest.sh
```

자식 서버를 강제 종료한 뒤 새 PID로 복구되고 페이지가 응답하는지 확인합니다.
