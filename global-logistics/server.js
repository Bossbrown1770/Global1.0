require('dotenv').config();
const express = require('express');
const path = require('path');
const fs = require('fs');

const app = express();
const PORT = process.env.PORT || 3000;
const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_ANON_KEY = process.env.SUPABASE_ANON_KEY;
const GROQ_API_KEY = process.env.GROQ_API_KEY;

app.use(express.json());
app.use(express.static(__dirname));

app.post('/api/chat', async (req, res) => {
  try {
    const { message } = req.body;
    const response = await fetch('https://api.groq.com/openai/v1/chat/completions', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${GROQ_API_KEY}`,
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({
        model: 'llama3-8b-8192',
        messages: [
          {
            role: 'system',
            content: 'You are a helpful logistics assistant for Global Logistics. Only answer questions related to shipping, tracking, logistics, deliveries, packages, freight, supply chain, and our services. If the user asks about anything unrelated to logistics, politely refuse and suggest they ask a logistics-related question. Keep responses concise and professional.'
          },
          { role: 'user', content: message }
        ],
        max_tokens: 500,
        temperature: 0.7
      })
    });
    const data = await response.json();
    if (data.choices && data.choices[0]) {
      res.json({ reply: data.choices[0].message.content });
    } else {
      res.status(500).json({ error: 'Invalid response from AI service' });
    }
  } catch (error) {
    res.status(500).json({ error: 'Failed to get AI response. Please try again later.' });
  }
});

app.get('/api/config', (req, res) => {
  res.json({ url: SUPABASE_URL, anonKey: SUPABASE_ANON_KEY });
});

app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
