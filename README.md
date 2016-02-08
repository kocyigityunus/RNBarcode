# RNBarcode
react native barcode view

```javascript
<RNBarcode
              text={this.state.barcodeText}
              format={'qr'}
              onBarcodeError={ (p1) => { console.log("barcode error : ", p1.nativeEvent); } }
              style={ { width : 200, height : 80, backgroundColor : 'white' } }
              />
```


