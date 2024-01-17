# iOS Technical Take-Home 

This document describes the assignment to be completed by candidates interviewing for an iOS position at [Shape](https://shape.dk).

👀 **Check out [our profile](https://github.com/shape-interviews) to better understand our technical interview process and the criteria we use to evaluate our candidates.**

## 🎯 Task

You need to develop an app that would use the Dog Breeds API to allow users to browse through the list of dog breeds, their pictures, and add pictures to favorites.

> **⚠️ Important Note**
> 
> The purpose of this task is for you to demonstrate your skill level. It would thus help if you were to **avoid** using frameworks for **networking** and for **images loading** (e.g.: Alamofire, Kingfisher, SDWebImage etc). That is, however, not a requirement, and you should feel free to use them; especially if you couldn't otherwise solve these tasks yourself.

## 📱 App Structure

We expect your app to have three screens with following features:

### 1. List of Breeds

- Shows the list of available breeds.
- Navigates the app to screen 2 when the user taps any of the breeds.
- Has "favorites" button that navigates the app to the screen [described in **3**]().

### 2. Breed Pictures

- Shows all the available pictures of a given breed.
- Allows users to like/unlike specific images by tapping the image or a like button.

### 3. Favorite Pictures

- Shows the images that the user liked.
- Shows which breed a particular image belongs to.
- Allows user to filter images by selecting a breed.

## 📋 Requirements

- You should use the following API: https://dog.ceo/dog-api
- Your app should be written in Swift.
- We encourage you to use UIKit, which is what we use in most of our projects at Shape.

## 💻 Practicalities

- We are not expecting you to spend more than 1 day (or 8 hours) on this task, but this is not a strict limitation. Feel free to exceed that time, if you feel like it.
- Rest assured that we are equally happy to evaluate an incomplete solution. We will only have less material to review, in such instance.
- Once your task is ready, please push it to this repository.
- Be prepared to the possibility to showcase your solution during a technical interview. In that case, you would be asked to run the app and show your solution from the user perspective, as well as to present the codebase, highlighting the most compelling parts of the solution, before answering ad-hoc questions concerning your app.
