const express = require('express');
const router = express.Router();
const Post = require('../models/Post');

// Получить все посты
router.get('/', async (req, res) => {
  try {
    const posts = await Post.find().sort({ createdAt: -1 });
    res.json(posts);
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
});

// Создать новый пост
router.post('/', async (req, res) => {
  const { author, content } = req.body;
  const post = new Post({ author, content });

  try {
    const newPost = await post.save();
    res.status(201).json(newPost);
  } catch (err) {
    res.status(400).json({ message: err.message });
  }
});

module.exports = router;
