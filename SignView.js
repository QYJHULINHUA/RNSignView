import React, {Component} from 'react';
import PropTypes from 'prop-types';
import {requireNativeComponent, NativeModules,findNodeHandle} from 'react-native';

var RNTSignView = requireNativeComponent('SignView', SignView);


export default class SignView extends Component {

    constructor(props){
        super(props);
        this.clearSign = this.clearSign.bind(this);
        this.signDone = this.signDone.bind(this);

    }


    static propTypes = {
        signLineColor: PropTypes.string,//签名笔划颜色
        signViewColor: PropTypes.string,//签名背景颜色
        placeHoalderColor: PropTypes.string,//无签名时占位文字颜色
        signLineWidth: PropTypes.number,//签名笔划宽度
        signPlaceHoalder: PropTypes.string,//无签名时占位文字

    };


    // 清除签名
    clearSign() {
        NativeModules.SignView.clearSignAction(findNodeHandle(this.signView))
    }

    signDone(callBack){
        NativeModules.SignView.signDone(
            findNodeHandle(this.signView)
        ).then(image => {
            callBack(image['imagePath']);
        });
    }


    render() {
        return (
            <RNTSignView
                ref={(ref) => {
                    this.signView = ref
                }}
                {...this.props}/>
        );

    }
}
