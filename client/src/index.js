/**
 * @file index.js
 * @description Entry point for the React application for the Kennel Management System.
 *              This file is responsible for rendering the root component (App) into the DOM.
 *              It also includes global configurations such as importing styles and setting up service workers.
 * @module index
 * @requires react
 * @requires react-dom
 * @requires ./App
 * @requires ./index.css
 * @requires ./serviceWorker
 * @date 2024-06-07
 * @version 1.0.0
 * 
 */

import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
import './index.css';
import * as serviceWorker from './serviceWorker';

ReactDOM.render(<App />, document.getElementById('root'));
