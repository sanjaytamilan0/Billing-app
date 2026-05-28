const nodemailer = require('nodemailer');

async function sendInvoiceEmail(senderEmail, senderPassword, recipientEmail, order) {
    try {
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

        // Build text info for the email
        let itemsText = order.items.map(i => `- ${i.name}: ${i.quantity} x $${i.price} = $${(i.quantity * i.price).toFixed(2)}`).join('\n');
        let emailText = `Hello,\n\nYour order #${order._id} has been completed.\n\nOrder Details:\n${itemsText}\n\nGrand Total: $${order.totalAmount.toFixed(2)}\n\nThank you for your business!`;

        let info = await transporter.sendMail({
            from: `"${order.companyName} Billing" <noreply@ethereal.email>`,
            to: recipientEmail,
            subject: `Order Completed - #${order._id}`,
            text: emailText
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
