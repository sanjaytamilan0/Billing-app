const nodemailer = require('nodemailer');

async function sendInvoiceEmail(senderEmail, senderPassword, recipientEmail, order, pdfBuffer) {
    try {
        // create reusable transporter object using generic SMTP (e.g., Gmail)
        let transporter = nodemailer.createTransport({
            service: 'gmail', // You can change this to standard host/port if not using Gmail
            auth: {
                user: senderEmail,
                pass: senderPassword,
            },
        });

        if (!recipientEmail) {
            console.log('No recipient email available to send the invoice email to.');
            return;
        }

        let info = await transporter.sendMail({
            from: `"${order.companyName} Billing" <${senderEmail}>`,
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

        console.log("Message sent: %s", info.messageId);
        return true;
    } catch (error) {
        console.error('Error sending email:', error);
        throw error;
    }
}

module.exports = {
    sendInvoiceEmail
};
