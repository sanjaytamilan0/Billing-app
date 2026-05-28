const nodemailer = require('nodemailer');

async function sendInvoiceEmail(senderEmail, senderPassword, recipientEmail, order, pdfBuffer) {
    try {
        // Generate test SMTP service account from ethereal.email (Zero setup required!)
        let testAccount = await nodemailer.createTestAccount();

        // create reusable transporter object using the default SMTP transport
        let transporter = nodemailer.createTransport({
            host: "smtp.ethereal.email",
            port: 587,
            secure: false, 
            auth: {
                user: testAccount.user, 
                pass: testAccount.pass, 
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
