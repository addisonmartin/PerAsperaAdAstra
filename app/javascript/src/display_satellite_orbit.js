// Used to check if the user's device supports WebGL.
import { WEBGL } from './WebGL.js';
// Load the three.js library.
var THREE = window.THREE = require('three');
// Used to load .glb and .gltf 3D models in three.js
require('three/examples/js/loaders/GLTFLoader');
// Used to enable orbit controls with three.js
require('three/examples/js/controls/OrbitControls');

document.addEventListener("turbolinks:load", () => {
    // Return unless the page is a satellite's show page.
    if ( !( ($('body').data('controller') == 'satellites') && ($('body').data('action') == 'show') ) ) { return; }

    // Only render the scene if the user's device supports WebGL rendering.
    if ( WEBGL.isWebGLAvailable() ) {
        //The satellite information from Rails.
        var satellite = $('.satellite-information').data('satellite');
        // The div that the three.js is rendered within.
        var container = document.getElementById('satellite-orbit-view');
        // The scene is what all the rendered objects will live in.
        var scene = new THREE.Scene();
        // First option: field of view, in degrees.
        // FOV is the extent of the scene that is seen on the display at any given moment.
        // Second option: aspect ratio.
        // Aspect ratio should always be the width of the window divided by the height.
        // Third option: near clipping plane.
        // Objects closer to the camera than near clipping plane will not be rendered.
        // Fourth option: far clipping plane.
        // Objects further away from the camera than far clipping plane will not be rendered.
        // Near and far clipping plane can affect performance!
        var camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 0.1, 100000 );
        camera.position.set( 0, 100, 0 );
        // Use WebGL as the renderer.
        var renderer = new THREE.WebGLRenderer();
        // Sets the size for the renderer to render the app.
        // This can be decreased to improve performance!
        renderer.setSize( window.innerWidth, window.innerHeight );
        // Add the renderer to the HTML document as a <canvas> object.
        container.appendChild( renderer.domElement );

        // Enables orbit controls:
        // Clicking and dragging mouse rotates the camera, scrolling with the mouse wheel changes zoom.
        var controls = new THREE.OrbitControls( camera, container );
        controls.target.set(0, 0, 0);

        // Adds a white, ambient light to illuminate the model and scene.
        var light = new THREE.AmbientLight( 0xffffff );
        light.intensity = 5;
        scene.add( light );

        // Load a 3D model of Earth.
        var loader = new THREE.GLTFLoader();
        loader.load('/assets/Earth.glb', function ( gltf ) {
            var gltfScene = gltf.scene;
            // Scale the model so 1 three.js unit = 1 km.
            gltfScene.scale.set(1/783.928217261, 1/783.928217261, 1/783.928217261);

            // Rotate the model so the equator faces the camera at its initial position.
            // var rotationMatrix = new THREE.Matrix4();
            // var axis = new THREE.Vector3(1, 1, 0);
            // rotationMatrix.makeRotationAxis(axis.normalize(), -90);
            // gltfScene.matrix.multiply(rotationMatrix);
            // gltfScene.rotation.setFromRotationMatrix(gltfScene.matrix);

            // Add the 3D model to the scene.
            scene.add( gltfScene );

        }, function ( xhr ) {
            // Log the loading progress of the model.
            console.log( 'Earth.glb ' + ( xhr.loaded / xhr.total * 100 ) + '% loaded' );

        }, undefined, function ( error ) {
            // Log any errors that occur when loading the model.
            console.error( error );
        });

        // Add an ellipse in the shape of the satellite's orbit.
        var orbit_curve = new THREE.EllipseCurve(
            0,  0,
            (satellite['apogee'] + 6378.135) / 10000, -1 * ((satellite['pergee'] + 6378.135) / 10000),
            0,  2 * Math.PI,
            false,
            (satellite['inclination'] / (Math.PI * 180))
        );
        var points = orbit_curve.getPoints( 1000 );
        var geometry = new THREE.BufferGeometry().setFromPoints( points );
        var material = new THREE.LineBasicMaterial( { color : 0xbfff00 } );
        var orbit = new THREE.Line( geometry, material );

        scene.add( orbit );

        // Render the scene.
        function animate() {
            requestAnimationFrame( animate );

            renderer.render( scene, camera );
        }
        animate();

    // Display a message if the user's device does not support WebGL, and do not render anything with three.js
    } else {
        var warning = WEBGL.getWebGLErrorMessage();
        document.getElementById( 'satellite-orbit-view' ).appendChild( warning );
    }

})
