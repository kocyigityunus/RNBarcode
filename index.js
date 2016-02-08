/*jslint node: true */
'use strict';

var React = require('react-native');
var { requireNativeComponent } = React;

class RNBarcode extends React.Component {
  render() {
    return <RCTBarcodeView {...this.props} />;
  }
}

RNBarcode.propTypes = {
  text: React.PropTypes.string,
  onBarcodeError : React.PropTypes.func,
  format : React.PropTypes.oneOf(['qr', 'qrL', 'qrM', 'qrQ', 'qrH',
    'aztec', 'codabar', 'code39', 'code93', 'code128', 'datamatrix', 'ean8',
    'ean13', 'itf', 'maxicode', 'pdf417', 'rss14',
    'rssexpanded', 'upca', 'upce', 'upceanextension' ])

  // list of formats that not available for encoding
  // upceanextension , upca, rssexpanded, rss14, maxicode,
  // code 93

};

var RCTBarcodeView = requireNativeComponent('RNBarcodeView', RNBarcode);

module.exports = RNBarcode;
