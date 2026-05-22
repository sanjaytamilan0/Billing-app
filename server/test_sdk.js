require('dotenv').config();
const { GoogleGenAI } = require('@google/genai');
const ai = new GoogleGenAI({ apiKey: process.env.GEMINI_API_KEY });

async function test() {
    try {
        const chat = ai.chats.create({
            model: 'gemini-2.5-flash',
            config: {
                systemInstruction: "You are a helpful assistant."
            }
        });
        const res = await chat.sendMessage({ message: "Hello" });
        console.log("Success:", res.text);
    } catch(e) {
        console.error("SDK ERROR:", e.message);
    }
}
test();
