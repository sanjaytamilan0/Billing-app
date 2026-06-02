const Tesseract = require('tesseract.js');

async function extractFormData(imageBuffer) {
    try {
        // Tesseract accepts buffer directly
        const { data: { text } } = await Tesseract.recognize(imageBuffer, 'eng');
        console.log("Raw OCR Text Extracted:", text);

        return parseFormFields(text);
    } catch (error) {
        console.error("Tesseract Error:", error);
        throw error;
    }
}

function parseFormFields(rawText) {
    const result = {};
    const lines = rawText.split('\n');

    for (let line of lines) {
        line = line.trim();
        if (!line) continue;

        // Hunt for specific fields (Name, Age, Product)
        // using case-insensitive regex that handles colons or hyphens
        
        // Match "Name : Sanjay" or "name-sanjay"
        const nameMatch = line.match(/(?:name|customer name|full name)\s*[:\-]\s*(.+)/i);
        if (nameMatch && !result.name) {
            result.name = nameMatch[1].trim();
        }

        // Match "Age : 10"
        const ageMatch = line.match(/age\s*[:\-]\s*(\d+)/i);
        if (ageMatch && !result.age) {
            result.age = ageMatch[1].trim();
        }

        // Match "Product : Apple"
        const productMatch = line.match(/product\s*[:\-]\s*(.+)/i);
        if (productMatch && !result.product) {
            result.product = productMatch[1].trim();
        }
    }

    // If it found absolutely nothing structured, return raw text for debugging
    if (Object.keys(result).length === 0) {
        return { rawText: rawText };
    }

    return result;
}

module.exports = { extractFormData };
