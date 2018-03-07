/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, {Component} from 'react';
import {
    Platform,
    StyleSheet,
    Text,
    View,
    Image,
    Alert,
    Button
} from 'react-native';


import SignView from './SignView'



const instructions = Platform.select({
    ios: 'Press Cmd+R to reload,\n' +
    'Cmd+D or shake for dev menu',
    android: 'Double tap R on your keyboard to reload,\n' +
    'Shake or press menu button for dev menu',
});


export default class App extends Component {


    constructor(props){

        super(props);

        this.state={
            imgPath:'http://1'
        }

    }

    render() {
        return (
            <View style={styles.container}>

                <View style={{width:100,height:100}}/>

                <SignView style={styles.signView}/>


                <View style={{width:100,height:100}}/>
            </View>
        );
    }
}

const styles = StyleSheet.create({
    container: {

        justifyContent:'center',
        alignItems:'center',
        backgroundColor: '#F5FCFF',
    },
    signView: {

        backgroundColor:'red',
        width: 350,
        height: 200,

    },
    welcome: {
        fontSize: 20,
        textAlign: 'center',
        margin: 10,
    },
    instructions: {
        textAlign: 'center',
        color: '#333333',
        marginBottom: 5,
    },
});
