import React from 'react';
import ReactDOM from 'react-dom';
import StolenWidget from '../components/StolenWidget';
import { defaultElementId } from '../utility';

export default class BikeIndex {
  static el;

  static init(options) {
    const { elementId = defaultElementId, ...rest } = options;
    const widget = <StolenWidget {...rest} />;

    function doRender() {
      if (BikeIndex.el) {
        throw new Error('BikeIndex is already mounted');
      }
      const el = document.getElementById(elementId);
      ReactDOM.render(widget, el);
      BikeIndex.el = el;
    }
    if (document.readyState === 'complete') {
      doRender();
    } else {
      window.addEventListener('load', () => {
        doRender();
      });
    }
  }
}
