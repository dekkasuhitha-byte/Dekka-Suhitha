# AI-Powered Driver Drowsiness Detection System

A real-time computer vision system that monitors a driver's eyes and mouth
through a webcam feed and raises an alert the moment it detects signs of
drowsiness — prolonged eye closure or yawning.

## Problem

Driver drowsiness is a major contributor to road accidents worldwide,
especially in long-distance transportation, logistics/fleet operations, and
late-night or continuous-shift driving. Fatigue slows reaction time, reduces
situational awareness, and causes microsleep events — leading to accidents,
vehicle damage, higher insurance costs, and lost productivity.

A lightweight, camera-only drowsiness detector can be integrated into
Advanced Driver Assistance Systems (ADAS), fleet management platforms,
public transit, ride-hailing services, and heavy-equipment operation, where
it flags fatigue before it causes an incident.

## How it works

1. **Face landmark detection** — [MediaPipe FaceMesh](https://google.github.io/mediapipe/solutions/face_mesh.html)
   locates 468 facial landmarks in every webcam frame.
2. **Eye Aspect Ratio (EAR)** — computed from 6 landmarks around each eye.
   EAR drops sharply when the eyes close; if it stays below a threshold for
   ~1 second of consecutive frames, that's flagged as a microsleep rather
   than a normal blink.
3. **Mouth Aspect Ratio (MAR)** — computed from 8 landmarks around the
   mouth. A sustained high MAR indicates yawning.
4. **Alerting** — once either signal crosses its threshold for enough
   consecutive frames, the system overlays a warning on the video feed and
   plays an audible alert.

```
Webcam frame → MediaPipe FaceMesh → landmark extraction
            → EAR (eyes) + MAR (mouth) → threshold + frame-count logic
            → on-screen warning + audio alert
```

## Tech stack

- **Python 3**
- **OpenCV** — video capture, drawing, display
- **MediaPipe** — real-time face mesh / landmark detection
- Standard library `math` (EAR/MAR geometry) and `platform` (cross-platform
  alert sound)

## Project structure

```
driver-drowsiness-detection/
├── drowsiness_detection.py   # main script
├── requirements.txt
└── README.md
```

## Setup

```bash
python -m venv venv
source venv/bin/activate        # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

> **Compatibility note:** `requirements.txt` pins `mediapipe==0.10.21`.
> Newer MediaPipe releases (0.10.30+, and all 1.0.x) removed the legacy
> `mediapipe.solutions` API this script uses — installing an unpinned
> `mediapipe` today will raise `AttributeError: module 'mediapipe' has no
> attribute 'solutions'`. Verified by actually running this project's code
> against several MediaPipe versions.

## Usage

```bash
# Live webcam (press 'q' to quit)
python drowsiness_detection.py

# Run against a pre-recorded video instead of a webcam
python drowsiness_detection.py --video sample_driving.mp4

# Disable the audio alert (useful when just demoing the visual overlay)
python drowsiness_detection.py --no-sound

# Headless mode — no display window (useful on a server/CI box)
python drowsiness_detection.py --no-window

# Save an annotated copy of the video to review later, or use as a demo clip
python drowsiness_detection.py --video sample_driving.mp4 --output annotated.mp4 --no-window
```

### How to test it

1. **Live webcam test (best for a demo recording):** Run
   `python drowsiness_detection.py` with your face in frame. Sit normally
   for a few seconds (baseline, no alert), then deliberately close your
   eyes for ~1–2 seconds — you should see "Driver is Drowsy" appear and
   hear a beep. Open a wide yawn for ~1 second to trigger the mouth-based
   alert the same way. Press `q` to end the session; the console will
   print a summary of every alert with a timestamp.
2. **No webcam handy / want a repeatable test:** record a 20–30 second
   video on your phone of your own face — a few normal blinks, then eyes
   closed for 2 seconds, then a yawn, then normal again — and run
   `python drowsiness_detection.py --video your_clip.mp4 --output annotated.mp4 --no-window`.
   Open `annotated.mp4` afterward to see the overlays, and use the printed
   event log as your ground-truth comparison for the Results section below.

The script prints a session summary on exit: how many drowsiness alerts
were triggered and when, e.g.:

```
Session ended. 3 drowsiness alert(s) triggered.
  - 14:02:11  (eye_closure)
  - 14:05:47  (yawn)
  - 14:09:03  (eye_closure)
```

That log doubles as a simple evaluation artifact — run the script against a
test video with known drowsy/awake segments and compare the triggered
timestamps against ground truth to report a rough precision/recall.

## Results

*(Fill in after testing: e.g. "Correctly flagged 8/9 simulated drowsy
segments in a 10-minute test recording, with 1 false positive during rapid
natural blinking.")*

## Future improvements

- Replace the fixed EAR/MAR thresholds with a short per-driver calibration
  step (thresholds vary with face shape/camera angle).
- Add temporal smoothing (e.g. a rolling average) to reduce false positives
  from single noisy frames.
- Explore a CNN/LSTM sequence model over landmark trajectories for more
  robust fatigue classification, as opposed to hand-tuned thresholds.
- Log sessions to a small dashboard (drowsy events per trip/driver) for a
  fleet-management style use case.

## Author

Suhitha Dekka — [GitHub](https://github.com/dekkasuhitha-byte) · [LinkedIn](https://linkedin.com/in/suhitha-dekka-34a08821b)
