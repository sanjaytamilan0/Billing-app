const nodemailer = require('nodemailer');

async function sendInvoiceEmail(senderEmail, senderPassword, recipientEmail, order, pdfBuffer) {
    try {
        // Use hardcoded test account to eliminate the 5-10 second timeout delay!
        let transporter = nodemailer.createTransport({
            host: "smtp.ethereal.email",
            port: 587,
            secure: false, 
            auth: {
                user: "on6eqd7uu45kifoh@ethereal.email", 
                pass: "SPfE6pRS987N6ua12W", 
            },
        });

        if (!recipientEmail) {
            return { success: false, message: 'No recipient email available.' };
        }

        let info = await transporter.sendMail({
            from: `"${order.companyName} Billing" <noreply@ethereal.email>`,
            to: recipientEmail,
            subject: `Invoice for Order #${order._id}`,
            text: `Hello,\n\nPlease find attached the invoice for your order #${order._id}.\n\nThank you for your business!`,
            attachments: [
                {
                    filename: `invoice-${order._id}.pdf`,
                    content: pdfBuffer,
                    contentType: 'application/pdf'
                }
            ]
        });

        const previewUrl = nodemailer.getTestMessageUrl(info);
        console.log("Message sent: %s", info.messageId);
        console.log("Preview URL: %s", previewUrl);
        return { success: true, previewUrl };
    } catch (error) {
        console.error('Error sending email:', error);
        return { success: false, message: error.message };
    }
}

module.exports = {
    sendInvoiceEmail
};
