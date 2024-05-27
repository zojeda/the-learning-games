import { definePrompt, generate, renderPrompt } from "@genkit-ai/ai";
import { configureGenkit } from "@genkit-ai/core";
import { gemini15Flash } from "@genkit-ai/googleai";
import * as z from "zod";
import { firebase } from "@genkit-ai/firebase";
import { googleAI } from "@genkit-ai/googleai";
import { defineFlow, startFlowsServer } from "@genkit-ai/flow";
import { dotprompt } from '@genkit-ai/dotprompt';

configureGenkit({
    plugins: [
        dotprompt(),
        firebase(),
        googleAI({
            apiVersion: "v1beta"
        }

        ),
    ],
    logLevel: "debug",
    enableTracingAndMetrics: true,
});
const supportedLanguages = z.enum(["spanish", "english", "portuguese"]);
const supportedAudiences = z.enum(["kids", "teenagers", "adults"]);
export const startStoryBookPrompt = definePrompt({
    name: 'startStoryBookPrompt',
    inputSchema: z.object({
        audience: z.enum(["kids", "teenagers", "adults"]),
        numChapters: z.number(),
        topic: z.string(),
        language: supportedLanguages
    }),
},
    async (input) => {
        const systemPrompt = `You are a learning tool for ${input.audience} as audience, generate storybooks for learning purpose about the given topic in markdown format and in language: ${input.language} using language expressions appropate for the audience`;
        const userPrompt = `Write an index page for a storybook with ${input.numChapters} chapters about: ${input.topic}.`;

        return {
            messages: [{
                role: 'system', content: [
                    { text: systemPrompt }]
            }, {
                role: 'user', content: [
                    { text: userPrompt }]
            }],
            config: { temperature: 0.9 },
            output: {
                schema: z.object({
                    topic: z.string(),
                    title: z.string(),
                    indexContent: z.string(),
                })
            }

        };
    }
);

export const generateChapterPrompt = definePrompt({
    name: "generateChapterPrompt",
    inputSchema: z.object({
        audience: supportedAudiences,
        indexContent: z.string(),
        chapter: z.number(),
        language: supportedLanguages
    }),

}, async (input) => {
    const systemPrompt = `You are a learning tool for ${input.audience} as audience, generate storybooks for learning purpose about the given topic in markdown format and in language: ${input.language} using language expressions appropate for the audience.
  here you have the index content: ${input.indexContent}`;
    const userPrompt = `write 2 page chapter ${input.chapter}, be elaborate`;

    return {
        messages: [{
            role: 'system', content: [
                { text: systemPrompt }]
        }, {
            role: 'user', content: [
                { text: userPrompt }]
        }],
        config: { temperature: 0.9 },
    };
});

export const storyBookFlow = defineFlow(
    {
        name: "storyBookFlow",
        inputSchema: z.object({
            audience: supportedAudiences,
            numChapters: z.number(),
            topic: z.string(),
            language: supportedLanguages,
        }),
        outputSchema: z.object({
            topic: z.string(),
            indexContent: z.string(),
            numChapters: z.number(),
            audience: supportedAudiences,
            language: supportedLanguages,
        })
    },
    async ({ numChapters, audience, topic, language }) => {
        const startingPrompt = await renderPrompt({
            prompt: startStoryBookPrompt,
            input: { numChapters, topic, audience, language },
            model: gemini15Flash
        });

        let result = await generate(startingPrompt);

        let response = {
            topic: topic,
            indexContent: result.text(),
            audience,
            language,
            numChapters

        }
        return response;
    }
);

export const generateChapterBookFlow = defineFlow(
    {
        name: "generateChapterBookFlow",
        inputSchema: z.object({
            chapter: z.number(),
            audience: supportedAudiences,
            indexContent: z.string(),
            language: supportedLanguages,
        }),
        outputSchema: z.object({
            chapter: z.number(),
            title: z.string(),
            text: z.string(),
        })
    },
    async ({ chapter, indexContent, audience, language }) => {
        const chapterPrompt = await renderPrompt({
            prompt: generateChapterPrompt,
            input: { indexContent, chapter, audience, language },
            model: gemini15Flash
        });

        let result = await generate(chapterPrompt);
        let response = {
            chapter,
            text: result.text(),
            title: 'title'
        }



        return response;
    }
);


async function* chapterNumbersGenerator(limit: number) {
    let i = 1;
    while (i <= limit) {
        yield i++;
    }
}


startFlowsServer({
    cors: {
        origin: '*',
    }
});
