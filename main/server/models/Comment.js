const mongoose = require('mongoose');

const commentSchema = new mongoose.Schema({
  postId: String,
  author: String,
  content: String,
});

module.exports = mongoose.model('Comment', commentSchema);
