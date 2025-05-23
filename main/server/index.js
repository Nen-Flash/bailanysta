require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
require('dotenv').config();
const commentsRoute = require('./routes/comments');
const postsRoute = require('./routes/posts');

const app = express();
app.use(cors());
app.use(express.json());

app.use('/posts', postsRoute);
app.use('/comments', commentsRoute);

const PORT = process.env.PORT || 3000;

mongoose.connect(process.env.MONGODB_URI)
  .then(() => {
    console.log('✅ Connected to MongoDB');
    app.listen(PORT, () => console.log(`🚀 Server running on port ${PORT}`));
  })
  .catch(err => {
    console.error('❌ Failed to connect to MongoDB', err);
  });

  
