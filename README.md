# pixster

pixster is an iOS app for browsing movies using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: 12.75 hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can view a list of movies currently playing in theaters. Poster images load asynchronously.
- [x] User can view movie details by tapping on a cell.
- [x] User sees loading state while waiting for the API.
- [x] User sees an error message when there is a network error.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x] Add a tab bar for **Now Playing** movies and **Popular Shows** for TV.
- [x] Implement segmented control to switch between list view and grid view.
- [ ] Add a search bar.
- [x] All images fade in.
- [ ] For the large poster, load the low-res image first, switch to high-res when complete.
- [x] Customize the highlight and selection effect of the cell.
- [x] Customize the navigation bar.

The following **additional** features are implemented:

- [x] Handle TV shows in addition to movies
- [x] Remember user preference for list view or grid view across tabs and across app restarts
- [x] Customize the tab bar
- [x] Grid view displays 3 columns of full-fill posters
- [x] Animate entrance of details on details screen

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='anim_pixster_v2.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

When creating the movie details view controller, I made the VC class a UICollectionViewController instead of a UIViewController and had runtime issues. Now I know these are two different things.

I wanted to make the table cells pretty and responsive on all device sizes but I think it will be more efficient to use next week's lesson in AutoLayout to accomplish this.

## License
Graphics credits:
- "tickets" by Daouna Jeong from [the Noun Project](https://thenounproject.com)
- "TV" by Manasa from [the Noun Project](https://thenounproject.com)
- "list" by unlimicon from [the Noun Project](https://thenounproject.com)
- "grid" by O s t r e a from [the Noun Project](https://thenounproject.com)

  MIT License

  Copyright (c) 2017 Angela Yu

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in all
  copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  SOFTWARE.
