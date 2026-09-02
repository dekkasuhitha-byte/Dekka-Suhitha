"""
AI-Powered Driver Drowsiness Detection System
----------------------------------------------
Real-time detection of driver drowsiness using facial landmark tracking.

Approach
--------
1. MediaPipe FaceMesh detects 468 facial landmarks per webcam frame.
2. Eye Aspect Ratio (EAR) is computed from eye landmarks to detect
   prolonged eye closure (microsleep / drowsy blinking).
3. Mouth Aspect Ratio (MAR) is computed from mouth landmarks to detect
   yawning.
4. If EAR stays below threshold, or MAR stays above threshold, for a
   sustained number of frames, an audible + on-screen "Driver is Drowsy"
   alert is triggered.

Usage
-----
    python drowsiness_detection.py                     # use default webcam
    python drowsiness_detection.py --video sample.mp4   # run on a video file
    python drowsiness_detection.py --no-sound            # disable audio alert
    python drowsiness_detection.py --no-window           # headless (no cv2.imshow), useful on servers
    python drowsiness_detection.py --video sample.mp4 --output annotated.mp4 --no-window
                                                           # save an annotated copy to review later
"""

import argparse
import math
import platform
import time

import cv2
import mediapipe as mp

# Landmark indices into MediaPipe FaceMesh's 468-point model
LEFT_EYE = [33, 160, 158, 133, 153, 144]
RIGHT_EYE = [362, 385, 387, 263, 373, 380]
MOUTH = [61, 81, 13, 311, 291, 308, 402, 14]

EAR_THRESHOLD = 0.2          # below this, eyes are considered closed
MAR_THRESHOLD = 0.3          # above this, mouth is considered open (yawn)
EYE_CLOSED_FRAMES_LIMIT = 30  # consecutive frames before raising a drowsy alert (~1s @ 30fps)
YAWN_FRAMES_LIMIT = 15        # consecutive frames of yawning before raising an alert


def eye_aspect_ratio(points):
    """EAR from 6 (x, y) eye landmark points, per Soukupova & Cech (2016)."""
    a = math.dist(points[1], points[5])
    b = math.dist(points[2], points[4])
    c = math.dist(points[0], points[3])
    return (a + b) / (2 * c)


def mouth_aspect_ratio(points):
    """MAR from 8 (x, y) mouth landmark points."""
    a = math.dist(points[1], points[7])
    b = math.dist(points[2], points[6])
    c = math.dist(points[3], points[5])
    d = math.dist(points[0], points[4])
    return (a + b + c) / (3 * d)


def play_alert():
    """Cross-platform alert beep. Falls back to a printed alert if no
    audio backend is available (e.g. a headless server or CI run)."""
    system = platform.system()
    try:
        if system == "Windows":
            import winsound
            winsound.Beep(2000, 500)
        elif system == "Darwin":
            import os
            os.system("afplay /System/Library/Sounds/Glass.aiff")
        else:
            import os
            os.system('printf "\\a"')
    except Exception:
        print("ALERT: Driver drowsiness detected!")


def run(source=0, use_sound=True, show_window=True, output_path=None):
    """Run the detector on a webcam index or a video file path.

    If output_path is given, writes an annotated copy of the video (with
    the same overlays you'd see live) to that path -- handy for reviewing
    results without a display, or for a portfolio demo clip.

    Returns a list of (timestamp, event_type) tuples logging every
    drowsiness alert raised during the session -- useful as a simple
    evaluation summary (e.g. "3 alerts over a 5-minute test clip").
    """
    face_mesh = mp.solutions.face_mesh.FaceMesh(
        static_image_mode=False,
        max_num_faces=1,
        refine_landmarks=False,
        min_detection_confidence=0.5,
        min_tracking_confidence=0.5,
    )

    video = cv2.VideoCapture(source)
    if not video.isOpened():
        raise RuntimeError(f"Could not open video source: {source}")

    writer = None
    if output_path:
        fps = video.get(cv2.CAP_PROP_FPS) or 30
        width = int(video.get(cv2.CAP_PROP_FRAME_WIDTH))
        height = int(video.get(cv2.CAP_PROP_FRAME_HEIGHT))
        fourcc = cv2.VideoWriter_fourcc(*"mp4v")
        writer = cv2.VideoWriter(output_path, fourcc, fps, (width, height))

    eye_closed_frames = 0
    yawn_frames = 0
    drowsy_events = []

    while video.isOpened():
        success, frame = video.read()
        if not success:
            break

        rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        results = face_mesh.process(rgb)

        if results.multi_face_landmarks:
            for detection in results.multi_face_landmarks:
                h, w = frame.shape[:2]
                landmarks = [(int(p.x * w), int(p.y * h)) for p in detection.landmark]

                left_eye = [landmarks[i] for i in LEFT_EYE]
                right_eye = [landmarks[i] for i in RIGHT_EYE]
                mouth = [landmarks[i] for i in MOUTH]

                avg_ear = (eye_aspect_ratio(left_eye) + eye_aspect_ratio(right_eye)) / 2
                mar = mouth_aspect_ratio(mouth)

                eye_closed_frames = eye_closed_frames + 1 if avg_ear < EAR_THRESHOLD else 0
                yawn_frames = yawn_frames + 1 if mar > MAR_THRESHOLD else 0

                if yawn_frames == 1:
                    cv2.putText(frame, "Yawning", (30, 80), cv2.FONT_HERSHEY_DUPLEX, 1, (0, 0, 255))

                if eye_closed_frames > EYE_CLOSED_FRAMES_LIMIT or yawn_frames > YAWN_FRAMES_LIMIT:
                    cv2.putText(frame, "Driver is Drowsy", (30, 80), cv2.FONT_HERSHEY_DUPLEX, 1, (0, 0, 255))
                    if use_sound:
                        play_alert()
                    event_type = "eye_closure" if eye_closed_frames > EYE_CLOSED_FRAMES_LIMIT else "yawn"
                    drowsy_events.append((time.time(), event_type))

        if writer is not None:
            writer.write(frame)

        if show_window:
            cv2.imshow("Driver Drowsiness Detection", frame)
            if cv2.waitKey(1) & 0xFF == ord('q'):
                break

    video.release()
    if writer is not None:
        writer.release()
    if show_window:
        cv2.destroyAllWindows()

    return drowsy_events


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Real-time driver drowsiness detection")
    parser.add_argument("--video", type=str, default=None, help="Path to a video file (default: webcam index 0)")
    parser.add_argument("--no-sound", action="store_true", help="Disable audio alert")
    parser.add_argument("--no-window", action="store_true", help="Run headless, without opening a display window")
    parser.add_argument("--output", type=str, default=None, help="Save an annotated copy of the video to this path")
    args = parser.parse_args()

    source = args.video if args.video else 0
    events = run(
        source=source,
        use_sound=not args.no_sound,
        show_window=not args.no_window,
        output_path=args.output,
    )

    print(f"\nSession ended. {len(events)} drowsiness alert(s) triggered.")
    for ts, kind in events:
        print(f"  - {time.strftime('%H:%M:%S', time.localtime(ts))}  ({kind})")
