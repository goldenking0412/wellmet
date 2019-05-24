var ExtractTextPlugin = require("extract-text-webpack-plugin");
module.exports = {
  entry: "./entry.js",
  output: {
    path: __dirname,
    filename: "../public/bundle.js"
  },
  module: {
    loaders: [
      {
        test: /\.css$/,
        loader: ExtractTextPlugin.extract("style-loader", "css-loader") },
      {
        test: /\.js$/,
        exclude: /(node_modules|bower_components)/,
        loader: 'babel', // 'babel-loader' is also a legal name to reference
        query: {
          presets: ['es2015']
        }
      },
      {
        loader: 'json-loader',
        test: /\.json$/
      },
      {
        test: /\.html$/,
        loader: 'ngtemplate?relativeTo=' + __dirname + '/!html'
      },
      {
        test: /isotope\-|fizzy\-ui\-utils|desandro\-|masonry|outlayer|get\-size|doc\-ready|eventie|eventemitter/,
        loader: 'imports?define=>false&this=>window'
      },
      {
        test: /isotope-layout/,
        loader: 'imports?define=>false&this=>window'
      },
      {
        test: /isotope-packery/,
        loader: 'imports?define=>false&this=>window'
      }
    ]
  },
  plugins: [
    new ExtractTextPlugin("../public/bundle.css")
  ]
};
