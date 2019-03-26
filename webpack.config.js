const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const CleanWebpackPlugin = require('clean-webpack-plugin');
const JavaScriptObfuscator = require('webpack-obfuscator');

const devMode = process.env.NODE_ENV !== 'production';

const defaultConfig = {
  mode: 'production',
  plugins: [
    new CleanWebpackPlugin(['dist/']),
    new MiniCssExtractPlugin({
      // Options similar to the same options in webpackOptions.output
      // both options are optional
      filename: devMode ? '[name].css' : '[name].[hash].css',
      chunkFilename: devMode ? '[id].css' : '[id].[hash].css',
    }),
    devMode ? null : new JavaScriptObfuscator(),
  ].filter(i => i),
  module: {
    rules: [
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        use: ['babel-loader'],
      },
      {
        test: /\.(svg)$/,
        use: [
          {
            loader: 'svg-url-loader',
            options: {
              noquotes: true,
            },
          },
        ],
      },
      {
        test: /\.(scss|css)$/,
        use: [
          // fallback to style-loader in development
          // devMode ? 'style-loader' : MiniCssExtractPlugin.loader,
          'style-loader',
          'css-loader',
          'cssimportant-loader',
          'sass-loader',
        ],
      },
    ],
  },
  resolve: {
    extensions: ['*', '.js', '.jsx'],
  },

};

module.exports = [{
  ...defaultConfig,
  entry: './src/outputs/bike-index.js',
  output: {
    path: __dirname + '/dist',
    publicPath: '/',
    filename: 'stolen-widget.js',
    library: 'BikeIndex',
    libraryExport: 'default',
    libraryTarget: 'window',
  }
}];
