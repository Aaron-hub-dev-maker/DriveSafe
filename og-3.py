import cv2
import dlib
import numpy as np
from scipy.spatial import distance
import threading
import pyttsx3
import time
import os

# Initialize text-to-speech engine
engine = pyttsx3.init()
engine.setProperty('rate', 150)

script_dir = os.path.dirname(os.path.abspath(__file__))

# Load models
detector = dlib.get_frontal_face_detector()
predictor = dlib.shape_predictor(os.path.join(script_dir, 'shape_predictor_68_face_landmarks.dat'))

def eye_aspect_ratio(eye):
    A = distance.euclidean(eye[1], eye[5])
    B = distance.euclidean(eye[2], eye[4])
    C = distance.euclidean(eye[0], eye[3])
    return (A + B) / (2.0 * C)

def mouth_aspect_ratio(mouth):
    A = distance.euclidean(mouth[2], mouth[10])
    B = distance.euclidean(mouth[4], mouth[8])
    C = distance.euclidean(mouth[0], mouth[6])
    return (A + B) / (2.0 * C)

def log_drowsiness(status):
    with open(os.path.join(script_dir, "drowsiness_log.txt"), "a") as file:
        file.write(f"{time.strftime('%Y-%m-%d %H:%M:%S')} - {status}\n")

def log_yawning(status):
    with open(os.path.join(script_dir, "yawning_log.txt"), "a") as file:
        file.write(f"{time.strftime('%Y-%m-%d %H:%M:%S')} - {status}\n")

def speak_alert(message):
    threading.Thread(target=lambda: engine.say(message) or engine.runAndWait(), daemon=True).start()

def draw_dotted_polyline(img, points, color, thickness=1, gap=2):
    for i in range(len(points)):
        pt1 = points[i]
        pt2 = points[(i + 1) % len(points)]
        dist = int(np.linalg.norm(np.array(pt1) - np.array(pt2)))
        for j in range(0, dist, 2 * gap):
            r = j / dist
            x = int((1 - r) * pt1[0] + r * pt2[0])
            y = int((1 - r) * pt1[1] + r * pt2[1])
            cv2.circle(img, (x, y), thickness, color, -1)

# Thresholds
EAR_THRESHOLD = 0.28
FPS = 30
EAR_CONSEC_FRAMES = int(FPS * 0.3)
MAR_THRESHOLD = 0.55
MOUTH_CONSEC_FRAMES = int(FPS * 0.6)

drowsiness_counter = 0
drowsiness_score = 0
yawning_counter = 0
yawning_score = 0

no_face_alert_active = False
drowsiness_alert_active = False
yawning_alert_active = False

# Video capture
cap = cv2.VideoCapture(0)
cap.set(cv2.CAP_PROP_FRAME_WIDTH, 640)
cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 480)

# Warm-up
for _ in range(30):
    cap.read()

fourcc = cv2.VideoWriter_fourcc(*'XVID')
out = cv2.VideoWriter(os.path.join(script_dir, 'video_log.avi'), fourcc, 20.0, (640, 480))

while True:
    ret, frame = cap.read()
    if not ret:
        break

    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    gray = cv2.equalizeHist(gray)
    faces = detector(gray)

    if len(faces) == 0:
        cv2.putText(frame, "NO FACE DETECTED!", (50, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
        if not no_face_alert_active:
            speak_alert("No face detected")
            no_face_alert_active = True
    else:
        no_face_alert_active = False
        for face in faces:
            padding = 20
            x, y, w, h = face.left(), face.top(), face.width(), face.height()
            x1, y1 = max(0, x - padding), max(0, y - padding)
            x2, y2 = x + w + padding, y + h + padding
            cv2.rectangle(frame, (x1, y1), (x2, y2), (0, 255, 0), 2)

            landmarks = predictor(gray, face)
            left_eye = [(landmarks.part(i).x, landmarks.part(i).y) for i in range(36, 42)]
            right_eye = [(landmarks.part(i).x, landmarks.part(i).y) for i in range(42, 48)]
            mouth = [(landmarks.part(i).x, landmarks.part(i).y) for i in range(48, 60)]

            draw_dotted_polyline(frame, left_eye, (255, 255, 0), 1, gap=2)
            draw_dotted_polyline(frame, right_eye, (255, 255, 0), 1, gap=2)
            draw_dotted_polyline(frame, mouth, (0, 255, 255), 1, gap=2)

            ear = (eye_aspect_ratio(left_eye) + eye_aspect_ratio(right_eye)) / 2.0
            mar = mouth_aspect_ratio(mouth)

            # Drowsiness detection
            if ear < EAR_THRESHOLD:
                drowsiness_counter += 1
                if drowsiness_counter >= EAR_CONSEC_FRAMES:
                    if drowsiness_score < 3:
                        drowsiness_score += 1
                    cv2.putText(frame, "DROWSINESS ALERT!", (50, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
                    log_drowsiness("Drowsiness Detected")
                    if not drowsiness_alert_active:
                        speak_alert("Drowsiness alert! Please stay awake.")
                        drowsiness_alert_active = True
            else:
                drowsiness_counter = 0
                drowsiness_alert_active = False

            # Yawning detection
            if mar > MAR_THRESHOLD:
                yawning_counter += 1
                if yawning_counter >= MOUTH_CONSEC_FRAMES:
                    if yawning_score < 3:
                        yawning_score += 1
                    cv2.putText(frame, "YAWNING ALERT!", (50, 100), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)
                    log_yawning("Yawning Detected")
                    if not yawning_alert_active:
                        speak_alert("Yawning detected. Please take a break.")
                        yawning_alert_active = True
            else:
                yawning_counter = 0
                yawning_alert_active = False

    out.write(frame)
    cv2.imshow("Driver Monitoring", frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
out.release()
cv2.destroyAllWindows()
