document.addEventListener('DOMContentLoaded', function () {
    // Load the three.js library.
    var THREE = require('three');
    // The scene is where all the rendered objects will live in.
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
    var camera = new THREE.PerspectiveCamera( 75, window.innerWidth / window.innerHeight, 0.1, 1000 );
    // Use WebGL as the renderer.
    var renderer = new THREE.WebGLRenderer();
    // Sets the size for the renderer to render the app.
    // This can be decreased to improve performance!
    renderer.setSize( window.innerWidth, window.innerHeight );
    // Add the renderer to the HTML document as a <canvas> object.
    document.body.appendChild( renderer.domElement );

    // Add a basic cube to the scene.
    var geometry = new THREE.BoxGeometry();
    var material = new THREE.MeshBasicMaterial( { color: 0x00ff00 } );
    var cube = new THREE.Mesh( geometry, material );
    scene.add( cube );
    camera.position.z = 5;

    // Render the scene.
    function animate() {
        requestAnimationFrame( animate );

        cube.rotation.x += 0.01;
        cube.rotation.y += 0.01;

        renderer.render( scene, camera );
    }
    animate();
});