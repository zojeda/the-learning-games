"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || function (mod) {
    if (mod && mod.__esModule) return mod;
    var result = {};
    if (mod != null) for (var k in mod) if (k !== "default" && Object.prototype.hasOwnProperty.call(mod, k)) __createBinding(result, mod, k);
    __setModuleDefault(result, mod);
    return result;
};
var __await = (this && this.__await) || function (v) { return this instanceof __await ? (this.v = v, this) : new __await(v); }
var __asyncGenerator = (this && this.__asyncGenerator) || function (thisArg, _arguments, generator) {
    if (!Symbol.asyncIterator) throw new TypeError("Symbol.asyncIterator is not defined.");
    var g = generator.apply(thisArg, _arguments || []), i, q = [];
    return i = {}, verb("next"), verb("throw"), verb("return", awaitReturn), i[Symbol.asyncIterator] = function () { return this; }, i;
    function awaitReturn(f) { return function (v) { return Promise.resolve(v).then(f, reject); }; }
    function verb(n, f) { if (g[n]) { i[n] = function (v) { return new Promise(function (a, b) { q.push([n, v, a, b]) > 1 || resume(n, v); }); }; if (f) i[n] = f(i[n]); } }
    function resume(n, v) { try { step(g[n](v)); } catch (e) { settle(q[0][3], e); } }
    function step(r) { r.value instanceof __await ? Promise.resolve(r.value.v).then(fulfill, reject) : settle(q[0][2], r); }
    function fulfill(value) { resume("next", value); }
    function reject(value) { resume("throw", value); }
    function settle(f, v) { if (f(v), q.shift(), q.length) resume(q[0][0], q[0][1]); }
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.generateChapterBookFlow = exports.storyBookFlow = exports.generateChapterPrompt = exports.startStoryBookPrompt = void 0;
const ai_1 = require("@genkit-ai/ai");
const core_1 = require("@genkit-ai/core");
const googleai_1 = require("@genkit-ai/googleai");
const z = __importStar(require("zod"));
const firebase_1 = require("@genkit-ai/firebase");
const googleai_2 = require("@genkit-ai/googleai");
const flow_1 = require("@genkit-ai/flow");
const dotprompt_1 = require("@genkit-ai/dotprompt");
(0, core_1.configureGenkit)({
    plugins: [
        (0, dotprompt_1.dotprompt)(),
        (0, firebase_1.firebase)(),
        (0, googleai_2.googleAI)({
            apiVersion: "v1beta"
        }),
    ],
    logLevel: "debug",
    enableTracingAndMetrics: true,
});
const supportedLanguages = z.enum(["spanish", "english", "portuguese"]);
const supportedAudiences = z.enum(["kids", "teenagers", "adults"]);
exports.startStoryBookPrompt = (0, ai_1.definePrompt)({
    name: 'startStoryBookPrompt',
    inputSchema: z.object({
        audience: z.enum(["kids", "teenagers", "adults"]),
        numChapters: z.number(),
        topic: z.string(),
        language: supportedLanguages
    }),
}, async (input) => {
    const systemPrompt = `You are a learning tool for ${input.audience} as audience, generate storybooks for learning purpose about the given topic in markdown format and in language: ${input.language} using language expressions appropate for the audience`;
    const userPrompt = `Write an index page for a storybook with ${input.numChapters} chapters about: ${input.topic}.`;
    return {
        messages: [{
                role: 'system', content: [
                    { text: systemPrompt }
                ]
            }, {
                role: 'user', content: [
                    { text: userPrompt }
                ]
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
});
exports.generateChapterPrompt = (0, ai_1.definePrompt)({
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
                    { text: systemPrompt }
                ]
            }, {
                role: 'user', content: [
                    { text: userPrompt }
                ]
            }],
        config: { temperature: 0.9 },
    };
});
exports.storyBookFlow = (0, flow_1.defineFlow)({
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
}, async ({ numChapters, audience, topic, language }) => {
    const startingPrompt = await (0, ai_1.renderPrompt)({
        prompt: exports.startStoryBookPrompt,
        input: { numChapters, topic, audience, language },
        model: googleai_1.gemini15Flash
    });
    let result = await (0, ai_1.generate)(startingPrompt);
    let response = {
        topic: topic,
        indexContent: result.text(),
        audience,
        language,
        numChapters
    };
    return response;
});
exports.generateChapterBookFlow = (0, flow_1.defineFlow)({
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
}, async ({ chapter, indexContent, audience, language }) => {
    const chapterPrompt = await (0, ai_1.renderPrompt)({
        prompt: exports.generateChapterPrompt,
        input: { indexContent, chapter, audience, language },
        model: googleai_1.gemini15Flash
    });
    let result = await (0, ai_1.generate)(chapterPrompt);
    let response = {
        chapter,
        text: result.text(),
        title: 'title'
    };
    return response;
});
function chapterNumbersGenerator(limit) {
    return __asyncGenerator(this, arguments, function* chapterNumbersGenerator_1() {
        let i = 1;
        while (i <= limit) {
            yield yield __await(i++);
        }
    });
}
(0, flow_1.startFlowsServer)({
    cors: {
        origin: '*',
    }
});
//# sourceMappingURL=index.js.map