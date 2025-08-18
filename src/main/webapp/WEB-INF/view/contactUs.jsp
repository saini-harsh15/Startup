<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Contact Us</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f7f6;
            margin: 0;
            padding-top: 60px;
            text-align: center;
        }

        .navbar {
            background-color: #ffffff;
            padding: 10px 20px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            box-sizing: border-box;
            z-index: 1000;
            text-align: left;
        }

        .logo {
            font-size: 1.5em;
            font-weight: bold;
            color: #28a745;
        }

        .container {
            max-width: 600px;
            margin: 20px auto;
            padding: 40px;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .form-group {
            margin-bottom: 20px;
            text-align: left;
        }

        .form-group label {
            display: block;
            font-weight: bold;
            margin-bottom: 8px;
            color: #555;
        }

        .form-group input,
        .form-group textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-sizing: border-box;
            font-size: 16px;
        }

        .form-group textarea {
            resize: vertical;
            min-height: 150px;
        }

        .submit-button {
            background-color: #28a745;
            color: white;
            padding: 15px 25px;
            border: none;
            border-radius: 5px;
            font-size: 18px;
            cursor: pointer;
            transition: background-color 0.3s ease;
            width: 100%;
        }

        .submit-button:hover {
            background-color: #218838;
        }

        h1 {
            color: #28a745;
            margin-bottom: 20px;
            font-size: 2em;
        }
    </style>
</head>
<body>

<div class="navbar">
    <div class="logo">Startup Ecosystem</div>
</div>

<div class="container">
    <h1>Contact Us</h1>
    <p>Please fill out the form below and we'll get back to you as soon as possible.</p>
    <form action="/contact" method="post">
        <div class="form-group">
            <label for="name">Your Name</label>
            <input type="text" id="name" name="name" required>
        </div>
        <div class="form-group">
            <label for="email">Your Email</label>
            <input type="email" id="email" name="email" required>
        </div>
        <div class="form-group">
            <label for="message">Your Message</label>
            <textarea id="message" name="message" required></textarea>
        </div>
        <button type="submit" class="submit-button">Send Message</button>
    </form>
</div>

</body>
</html>
