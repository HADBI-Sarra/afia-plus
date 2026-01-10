import nodemailer from 'nodemailer';
import dotenv from 'dotenv';
dotenv.config();

// Usage: await sendEmail({ to, subject, html })
export async function sendEmail({ to, subject, html }) {
  const transporter = nodemailer.createTransport({
    host: process.env.EMAIL_HOST,
    port: parseInt(process.env.EMAIL_PORT, 10) || 465,
    secure: !!(process.env.EMAIL_SECURE === 'true' || process.env.EMAIL_PORT === '465'), // true for 465, false for 587
    auth: {
      user: process.env.EMAIL_USER,
      pass: process.env.EMAIL_PASS,
    },
  });

  const mailOptions = {
    from: process.env.EMAIL_FROM || process.env.EMAIL_USER,
    to,
    subject,
    html,
  };

  try {
    // Add timeout wrapper to prevent hanging indefinitely
    const timeoutPromise = new Promise((_, reject) => {
      setTimeout(() => reject(new Error('Email sending timeout after 15 seconds')), 15000);
    });
    
    const sendPromise = transporter.sendMail(mailOptions);
    const info = await Promise.race([sendPromise, timeoutPromise]);
    
    console.log('Verification email sent:', info.response);
    return true;
  } catch (error) {
    console.error('Failed to send verification email:', error);
    return false;
  }
}

