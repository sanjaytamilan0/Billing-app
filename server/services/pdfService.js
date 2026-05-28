const PDFDocument = require('pdfkit');

function generateInvoicePDF(order) {
    return new Promise((resolve, reject) => {
        try {
            const doc = new PDFDocument({ margin: 50 });
            let buffers = [];
            
            doc.on('data', buffers.push.bind(buffers));
            doc.on('end', () => {
                const pdfData = Buffer.concat(buffers);
                resolve(pdfData);
            });
            doc.on('error', reject);

            // Header
            doc.fillColor('#444444')
               .fontSize(20)
               .text('INVOICE', 110, 57)
               .fontSize(10)
               .text(order.companyName, 200, 65, { align: 'right' })
               .text('Billing App System', 200, 80, { align: 'right' })
               .moveDown();

            // Order Info
            doc.fillColor('#000000')
               .fontSize(10)
               .text(`Order ID: ${order.id}`, 50, 150)
               .text(`Date: ${new Date(order.createdAt).toLocaleDateString()}`, 50, 165)
               .text(`Status: ${order.status.toUpperCase()}`, 50, 180)
               .moveDown();

            // Table Header
            const tableTop = 230;
            doc.font('Helvetica-Bold');
            doc.text('Item', 50, tableTop);
            doc.text('Quantity', 250, tableTop, { width: 90, align: 'right' });
            doc.text('Price', 340, tableTop, { width: 90, align: 'right' });
            doc.text('Total', 430, tableTop, { width: 90, align: 'right' });
            doc.moveTo(50, tableTop + 15).lineTo(520, tableTop + 15).stroke();

            // Table Rows
            let position = tableTop + 30;
            doc.font('Helvetica');
            order.items.forEach(item => {
                doc.text(item.name, 50, position);
                doc.text(item.quantity.toString(), 250, position, { width: 90, align: 'right' });
                doc.text(`$${item.price.toFixed(2)}`, 340, position, { width: 90, align: 'right' });
                doc.text(`$${(item.price * item.quantity).toFixed(2)}`, 430, position, { width: 90, align: 'right' });
                position += 20;
            });

            // Summary
            doc.moveTo(50, position + 10).lineTo(520, position + 10).stroke();
            doc.font('Helvetica-Bold');
            doc.fontSize(12)
               .text('GRAND TOTAL:', 340, position + 25, { width: 90, align: 'right' })
               .text(`$${order.totalAmount.toFixed(2)}`, 430, position + 25, { width: 90, align: 'right' });

            doc.end();
        } catch (error) {
            reject(error);
        }
    });
}

module.exports = {
    generateInvoicePDF
};
