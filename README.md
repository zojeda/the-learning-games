# the learning games
<a href="https://idx.google.com/import?url=https://github.com/zojeda/the-learning-games.git">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://cdn.idx.dev/btn/open_dark_32.svg">
    <source media="(prefers-color-scheme: light)" srcset="https://cdn.idx.dev/btn/open_light_32.svg">
    <img height="32" alt="Open in IDX" src="https://cdn.idx.dev/btn/open_purple_32.svg">
  </picture>
</a>

## Getting started



### start backend

```bash
$ cd backend
$ npm install # first time
$ export GOOGLE_API_KEY=<your_api_key>
$ npm run start:dev


```

```mermaid
sequenceDiagram
    User->>+FrontEnd: Generate StoryBook
    FrontEnd ->>+ BackEnd: Generate Index
    BackEnd ->>+ KnowledgeSource: Get Full Raw Content
    KnowledgeSource -->>- BackEnd: Raw Content
    BackEnd ->>+ LLM: Process Educ Content
    LLM -->>- BackEnd: Structured Content Json
    BackEnd ->>+ LLM: Generate Index
    LLM -->>- BackEnd: Index
    BackEnd -->>- FrontEnd: StoryBook cover
    FrontEnd -->>- User: Visual Book

    User ->>+ FrontEnd: Navigate Book chapters
    FrontEnd ->>+ BackEnd: Generate Chapter
    BackEnd ->>+ LLM: Generate Chapter Content
    LLM -->>- BackEnd: Chapter Content
    BackEnd ->>+ LLM: Generate Interaction Hooks
    LLM -->>- BackEnd: Interaction Hooks
    BackEnd -->>- FrontEnd: Chapter
    FrontEnd -->>- User: Visual Chapter 
```
