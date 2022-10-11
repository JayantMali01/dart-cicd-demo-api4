%dw 2.0
import * from dw::test::Asserts
---
payload must equalTo({
  "message": "sample API is up and running",
  "timeStamp": "2022-09-30T10:52:48.318+05:30",
  "status": "success",
  "code": 200
})