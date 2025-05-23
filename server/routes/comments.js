const express = require('express');
const router = express.Router();
const Comment = require('../models/Comment');

// Получить комментарии по postId
router.get('/:postId', async (req, res) => {
  try {
    const comments = await Comment.find({ postId: req.params.postId });
    res.json(comments);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Добавить комментарий
router.post('/', async (req, res) => {
  const { postId, author, content } = req.body;
  const comment = new Comment({ postId, author, content });
  try {
    await comment.save();
    res.status(201).json(comment);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

module.exports = router;
