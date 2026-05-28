const nodemailer = require('nodemailer');

async function sendInvoiceEmail(toEmail, adminEmail, order, pdfBuffer) {
    try {
        // Generate test SMTP service account from ethereal.email
        let testAccount = await nodemailer.createTestAccount();

        // create reusable transporter object using the default SMTP transport
        let transporter = nodemailer.createTransport({
            host: "smtp.ethereal.email",
            port: 587,
            secure: false, // true for 465, false for other ports
            auth: {
                user: testAccount.user, // generated ethereal user
                pass: testAccount.pass, // generated ethereal password
            },
        });

        let recipients = [];
        if (toEmail) recipients.push(toEmail);
        if (adminEmail) recipients.push(adminEmail);

        // If no emails are available to send to, we skip
        if (recipients.length === 0) {
            console.log('No recipients to send the invoice email to.');
            return;
        }

        let info = await transporter.sendMail({
            from: '"Billing App" <noreply@billingapp.com>',
            to: recipients.join(', '),
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
        // Preview URL is extremely useful for ethereal testing
        console.log("Preview URL: %s", nodemailer.getTestMessageUrl(info));
        return nodemailer.getTestMessageUrl(info);
    } catch (error) {
        console.error('Error sending email:', error);
    }
}

module.exports = {
    sendInvoiceEmail
};
