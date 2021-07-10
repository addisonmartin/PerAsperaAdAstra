import * as THREE from 'three';
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';
import earthAsset from '../assets/Earth.glb';
import { EARTH_RADIUS } from '../source/constants';

window.addEventListener("load", () => {
    var satellite_view_element = document.getElementById(('satellite-view'))
    if (satellite_view_element != null) {
       const renderer = new THREE.WebGLRenderer();
       var width = satellite_view_element.offsetWidth - 4; // Minus 4 to account for the 2px border on both left and right
       var height = satellite_view_element.offsetHeight - 4; // Minus 4 to account for the 2px border on both top and left
       renderer.setSize(width, height);
       satellite_view_element.appendChild(renderer.domElement);

        var scene = new THREE.Scene();

        var camera = new THREE.PerspectiveCamera(75, width / height, EARTH_RADIUS / 100, 100 * EARTH_RADIUS);
        camera.position.set( 0, 0, EARTH_RADIUS * 2 );
        camera.lookAt( 0, 0, 0 );

        var controls = new OrbitControls(camera, satellite_view_element);
        controls.target.set(0, 0, 0);

        const orbitHeight = 100;
        const curve = new THREE.EllipseCurve(
            0, 0, EARTH_RADIUS + orbitHeight, EARTH_RADIUS + orbitHeight, 0, 2 * Math.PI, true, 0
        );
        const points = curve.getPoints(100);
        const geometry = new THREE.BufferGeometry().setFromPoints(points);
        const material = new THREE.LineBasicMaterial({ color : 0xff0000 });
        const ellipse = new THREE.Line(geometry, material);
        scene.add(ellipse);

        var loader = new GLTFLoader();
        loader.load(earthAsset, function (gltf) {
            var gltfScene = gltf.scene;

            // Credit: https://stackoverflow.com/questions/52271397/centering-and-resizing-gltf-models-automatically-in-three-js
            var bounding_box = new THREE.Box3().setFromObject(gltfScene);
            var center = bounding_box.getCenter(new THREE.Vector3());
            var size = bounding_box.getSize(new THREE.Vector3());

            // Rescale the object to normalized space
            var maxAxis = Math.max(size.x, size.y, size.z);
            gltfScene.scale.multiplyScalar(EARTH_RADIUS / maxAxis);
            bounding_box.setFromObject(gltfScene);
            bounding_box.getCenter(center);
            bounding_box.getSize(size);
            // Reposition to 0, 0, 0
            gltfScene.position.copy(center).multiplyScalar(-1);

            scene.add(gltfScene);

        }, function (xhr) {
            console.log('Earth.glb ' + (xhr.loaded / xhr.total * 100 ) + '% loaded');
        }, undefined, function (error) {
            console.error(error);
        });

        var light = new THREE.AmbientLight(0xffffff);
        light.intensity = 5;
        scene.add(light);

        function animate() {
            requestAnimationFrame(animate);
            renderer.render(scene, camera);
        }

        animate();
    }
});
