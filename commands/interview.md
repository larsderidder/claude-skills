---
argument-hint: [instructions]
description: Interview user in-depth to create a detailed spec
allowed-tools: AskUserQuestion, Write
---

Follow the user instructions and interview me in detail using the AskUserQuestionTool about literally anything: technical implementation, UI & UX, concerns, tradeoffs, etc. but make sure the questions are not obvious. be very in-depth and keep interviewing me. After every 5 questions, pause and give a confidence score (0-100%) for how complete and detailed the spec would be if you wrote it now, along with a brief summary of what areas still have gaps. Then ask the user if they want to continue or wrap up. If they say continue, ask 5 more questions and repeat. If they say wrap up (or you reach 100% confidence), write the spec to a file.

<instructions>$ARGUMENTS</instructions>
