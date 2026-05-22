require('dotenv').config();
const { GoogleGenAI } = require('@google/genai');
const ai = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY });

async function test() {
    try {
        const chat = ai.chats.create({ model: 'gemini-2.5-flash' });
        await chat.sendMessage("Hello");
        const toolResults = [{ functionResponse: { name: "test", response: { ok: true } } }];
        
        // Let's try passing it inside a parts array
        await chat.sendMessage([{ functionResponse: { name: "test", response: { ok: true } } }]);
        console.log("Success");
    } catch(e) {
        console.error("SDK ERROR:", e.message);
    }
}
test();
