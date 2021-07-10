import * as THREE from 'three';
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';
import earthAsset from '../assets/Earth.glb';

window.addEventListener("load", () => {
    var satellite_view_element = document.getElementById(('satellite-view'))
    if (satellite_view_element != null) {
       const renderer = new THREE.WebGLRenderer();
       var width = satellite_view_element.offsetWidth - 4; // Minus 4 to account for the 2px border on both left and right
       var height = satellite_view_element.offsetHeight - 4; // Minus 4 to account for the 2px border on both top and left
       renderer.setSize(width, height);
       satellite_view_element.appendChild(renderer.domElement);

        var scene = new THREE.Scene();

        var camera = new THREE.PerspectiveCamera(75, width / height, 1, 10000);
        camera.position.set( 0, 0, 100 );
        camera.lookAt( 0, 0, 0 );

        var controls = new OrbitControls(camera, satellite_view_element);
        controls.target.set(0, 0, 0);

        var loader = new GLTFLoader();
        loader.load(earthAsset, function (gltf) {
            var gltfScene = gltf.scene;
            //gltfScene.scale.set(1/783.928217261, 1/783.928217261, 1/783.928217261);
            scene.add(gltfScene);

        }, function (xhr) {
            console.log('Earth.glb ' + ( xhr.loaded / xhr.total * 100 ) + '% loaded');
        }, undefined, function (error) {
            console.error(error);
        });

        var light = new THREE.AmbientLight( 0xffffff );
        light.intensity = 5;
        scene.add(light);

        function animate() {
            requestAnimationFrame(animate);
            renderer.render(scene, camera);
        }

        animate();
    }
});
