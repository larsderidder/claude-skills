---
description: "Draft content for a platform (x, linkedin, medium) into a review pipeline"
argument-hint: "[platform] [topic or instructions]"
allowed-tools: ["Write", "Read"]
---

# Draft Content

Create a content draft following a structured review pipeline.

## Instructions

1. Parse the arguments: first word is the platform (`x`, `linkedin`, `medium`), rest is the topic/instructions
2. If no platform specified, ask which one

3. Based on platform, follow these guidelines:
   - **x**: Short, punchy. Max 280 chars. English. Technical audience. No hashtags.
   - **linkedin**: Professional tone. Can be longer. Include a hook in the first line.
   - **medium**: Article outline with title, subtitle, sections, and key points.

4. Write the draft to a file:
   - Path: `content/drafts/YYYY-MM-DD-<platform>-<slug>.md`
   - Create the `content/drafts/` directory if it doesn't exist

5. Use this frontmatter format:
   ```
   ---
   platform: <x|linkedin|medium>
   title: "<descriptive title>"
   status: draft
   created: YYYY-MM-DD
   ---
   ```

6. Write the draft content after the frontmatter

7. Report: what you wrote, the file path, and suggest next steps (review, edit, or refine)

IMPORTANT: Never set status to anything other than "draft". Never write to approved/ or posted/ directories. Drafts only.
