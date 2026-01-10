import express from 'express';
import multer from 'multer';
import {
  signup,
  login,
  me,
  logout,
  uploadProfilePicture,
  verifyOtp,
  resendOtp,
} from '../controllers/auth.controller.js';
import { authMiddleware } from '../middlewares/auth.middleware.js';

const router = express.Router();

// Configure multer for memory storage
const upload = multer({
  storage: multer.memoryStorage(),
  limits: {
    fileSize: 5 * 1024 * 1024, // 5MB limit
  },
  fileFilter: (req, file, cb) => {
    // Log the file info for debugging
    console.log('File upload - mimetype:', file.mimetype);
    console.log('File upload - originalname:', file.originalname);

    // Accept only image files - check both mimetype and file extension
    const validMimeTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp', 'image/bmp'];
    const validExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'];

    // Get file extension
    const fileExtension = file.originalname.toLowerCase().substring(file.originalname.lastIndexOf('.'));
    const hasValidExtension = validExtensions.includes(fileExtension);

    // Check mimetype - be lenient with application/octet-stream if extension is valid
    const mimetype = file.mimetype ? file.mimetype.toLowerCase() : '';
    const isGenericMimeType = mimetype === 'application/octet-stream' ||
      mimetype === 'application/x-unknown-content-type' ||
      mimetype === '';
    const hasValidMimeType = mimetype.startsWith('image/') ||
      validMimeTypes.includes(mimetype);

    // Accept if: valid mimetype OR (generic mimetype with valid extension)
    if (hasValidMimeType || (isGenericMimeType && hasValidExtension) || hasValidExtension) {
      console.log('File accepted - mimetype:', file.mimetype, 'extension:', fileExtension);
      cb(null, true);
    } else {
      console.error('File rejected - mimetype:', file.mimetype, 'extension:', fileExtension);
      cb(new Error('Only image files are allowed (jpg, jpeg, png, gif, webp, bmp)'), false);
    }
  },
});

// Wrapper to handle multer errors
const uploadWithErrorHandling = (req, res, next) => {
  upload.single('profile_picture')(req, res, (err) => {
    if (err) {
      if (err instanceof multer.MulterError) {
        if (err.code === 'LIMIT_FILE_SIZE') {
          return res.status(400).json({ message: 'File too large. Maximum size is 5MB' });
        }
        return res.status(400).json({ message: 'File upload error: ' + err.message });
      }
      return res.status(400).json({ message: err.message || 'File upload error' });
    }
    next();
  });
};

router.post('/signup', signup);
router.post('/login', login);
router.post('/verify-otp', verifyOtp);
router.post('/resend-otp', resendOtp);
router.get('/me', authMiddleware, me);
router.post('/logout', authMiddleware, logout);
router.post('/upload-profile-picture', authMiddleware, uploadWithErrorHandling, uploadProfilePicture);

export default router;
