import cv2
import numpy as np
import mediapipe as mp
import os
import math
import matplotlib.pyplot as plt

mp_face_mesh = mp.solutions.face_mesh

def distances(points):
    dist = []
    for i in range(points.shape[0]):
        for j in range(points.shape[0]):
            p1 = points[i, :]
            p2 = points[j, :]
            dist.append(math.sqrt((p1[0] - p2[0]) ** 2 + (p1[1] - p2[1]) ** 2))
    return dist

def get_landmarks(images, labels, save_directory="", num_coords=5, to_save=False):
    print("Getting facial landmarks using Mediapipe")
    landmarks = []
    new_labels = []
    img_ct = 0

    # FaceMesh setup
    with mp_face_mesh.FaceMesh(static_image_mode=True, max_num_faces=1,
                                refine_landmarks=True, min_detection_confidence=0.5) as face_mesh:
        for img, label in zip(images, labels):
            img_ct += 1
            img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
            results = face_mesh.process(img_rgb)

            if results.multi_face_landmarks:
                for face_landmarks in results.multi_face_landmarks:
                    # Choose only first 'num_coords' points
                    coords = np.array([
                        [int(p.x * img.shape[1]), int(p.y * img.shape[0])]
                        for p in face_landmarks.landmark[:num_coords]
                    ])

                    dist = distances(coords)
                    landmarks.append(dist)
                    new_labels.append(label)

                    if to_save:
                        for (x_, y_) in coords:
                            cv2.circle(img, (x_, y_), 1, (0, 255, 0), -1)

                        plt.figure()
                        plt.imshow(cv2.cvtColor(img, cv2.COLOR_BGR2RGB))
                        if not os.path.isdir(save_directory):
                            os.mkdir(save_directory)
                        plt.savefig(os.path.join(save_directory, f"{label}{img_ct}.png"))
                        plt.close()

            if img_ct % 50 == 0:
                print(f"{img_ct} images with facial landmarks completed.")

    return np.array(landmarks), np.array(new_labels)