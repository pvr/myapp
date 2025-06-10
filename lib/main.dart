import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

 final String title;
 @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Initialize _audioPlayer as late final to avoid potential null issues
  late final audioPlayer = AudioPlayer();
  late ConcatenatingAudioSource playlist;

  @override
  void initState() {
    super.initState();

    playlist = ConcatenatingAudioSource(children: [
      AudioSource.uri(
        Uri.parse("https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"),
        tag: MediaItem(
          id: '1',
          album: "SoundHelix",
          title: "SoundHelix-Song-1",
          artist: "SoundHelix",
          artUri: Uri.parse("https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"), // Placeholder
        ),
 ),
      AudioSource.uri(
        Uri.parse("https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3"),
        tag: MediaItem(
          id: '2',
          album: "SoundHelix",
          title: "SoundHelix-Song-2",
          artist: "SoundHelix",
          artUri: Uri.parse("https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3"), // Placeholder
        ),
 ),
      AudioSource.uri(
        Uri.parse("https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3"),
        tag: MediaItem(
          id: '3',
          album: "SoundHelix",
          title: "SoundHelix-Song-3",
          artist: "SoundHelix",
          artUri: Uri.parse("https://www.soundhelix.com/examples/mp3/SoundHelix-Song-3.mp3"), // Placeholder
        ),
 ),
    ]);

    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    await audioPlayer.setAudioSource(playlist);
  }

  @override
  void dispose() {
    audioPlayer.dispose();
  }

  void _playPause() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
  }
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Placeholder for track title and artist
            StreamBuilder<SequenceState?>(
              stream: audioPlayer.sequenceStateStream,
              builder: (context, snapshot) {
                final state = snapshot.data;
                if (state?.sequence.isEmpty ?? true) {
                  return const SizedBox();
                }
                final currentItem = state!.currentSource!.tag as MediaItem;
                return Column(
                  children: [
                    Text(currentItem.title),
                    Text(currentItem.artist ?? ''),
                  ],
                );
              },
            ),
            // Seekbar
            StreamBuilder<Duration>(
              stream: audioPlayer.positionStream,
              builder: (context, snapshot) {
                final position = snapshot.data ?? Duration.zero;
                final duration = audioPlayer.duration ?? Duration.zero;
                return Slider(
                  value: position.inMilliseconds.toDouble(),
                  max: duration.inMilliseconds.toDouble(),
                  onChanged: (value) {
 audioPlayer.seek(Duration(milliseconds: value.toInt()));
 },
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.skip_previous),
                  onPressed: audioPlayer.hasPrevious ? audioPlayer.seekToPrevious : null,
                ),
                IconButton(
                  icon: Icon(audioPlayer.playing ? Icons.pause : Icons.play_arrow),
                  onPressed: _playPause,
                ),
                IconButton(
                  icon: const Icon(Icons.skip_next),
                  onPressed: audioPlayer.hasNext ? audioPlayer.seekToNext : null,
                ),
              ],
            ),
          ],
        ),
      ));
 }
}
