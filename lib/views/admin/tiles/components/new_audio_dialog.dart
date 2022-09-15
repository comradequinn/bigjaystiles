import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:qinject/qinject.dart';
import 'package:record/record.dart';

enum ImageSourceType { gallery, camera }

class NewAudioDialog extends StatefulWidget {
  final Record _audioRecorder;
  final File? _initialAudioFile;

  NewAudioDialog(Qinjector qinjector, this._initialAudioFile, {super.key})
      : _audioRecorder = qinjector.use<NewAudioDialog, Record>();

  @override
  State<NewAudioDialog> createState() => _NewAudioDialogState();
}

class _NewAudioDialogState extends State<NewAudioDialog> {
  static final _audioPlayer = Qinject.use<NewAudioDialog, AudioPlayer>();
  File? _audioFile;
  bool _playing = false;
  bool _recording = false;
  bool _recordingPermitted = true;

  @override
  void initState() {
    super.initState();
    _audioFile = widget._initialAudioFile;
  }

  @override
  void dispose() async {
    super.dispose();

    if (await widget._audioRecorder.isRecording()) {
      await widget._audioRecorder.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Assign Audio"),
      content: SingleChildScrollView(
          child: Column(
        children: <Widget>[
          GestureDetector(
              onTap: () async {
                final audioFile = _audioFile;

                if (audioFile == null || _playing || _recording) return;

                setState(() => _playing = true);

                final playComplete = _audioPlayer.onPlayerComplete.first;

                await _audioPlayer.play(DeviceFileSource(audioFile.path));

                await playComplete;

                setState(() => _playing = false);
              },
              child: SizedBox(
                  width: 400,
                  height: 200,
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.grey),
                    width: 200,
                    height: 200,
                    child: Icon(
                        color: _recording ? Colors.red : null,
                        _audioFile == null
                            ? Icons.warning_outlined
                            : _playing
                                ? Icons.multitrack_audio
                                : _recording
                                    ? Icons.multitrack_audio
                                    : Icons.play_arrow),
                  ))),
          const SizedBox(height: 20),
          Text(
              _recordingPermitted
                  ? ""
                  : "Warning: cannot record as microphone access was not granted",
              style: const TextStyle(color: Colors.red)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            IconButton(
              icon: Icon(
                  color: Colors.red, _recording ? Icons.square : Icons.circle),
              onPressed: () async {
                if (_playing) return;

                if (!_recording) {
                  final recordingPermitted =
                      await widget._audioRecorder.hasPermission();

                  if ((await widget._audioRecorder.listInputDevices())
                      .isNotEmpty) {
                    debugPrint(
                        "potentially unable to record as audiorecord returns no input devices. this often occurs in an emulator yet recording succeeds");
                    return;
                  }

                  setState(() => _recordingPermitted = recordingPermitted);

                  await widget._audioRecorder.start();
                } else {
                  final audioPath = await widget._audioRecorder.stop();

                  if (audioPath != null) {
                    _audioFile = File(audioPath);
                  }
                }

                setState(() => _recording = !_recording);
              },
            )
          ])
        ],
      )),
      actions: [
        TextButton(
            onPressed: () =>
                Navigator.of(context).pop(widget._initialAudioFile),
            child: const Text('Cancel')),
        TextButton(
            onPressed: () => Navigator.of(context)
                .pop(_audioFile ?? widget._initialAudioFile),
            child: const Text('OK'))
      ],
    );
  }
}
