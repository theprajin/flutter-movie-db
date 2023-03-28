import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pod_player/pod_player.dart';

import 'package:movies_db/models/movie.dart';
import 'package:movies_db/providers/video_provider.dart';

class DetailScreen extends StatelessWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    //print(movie.id);
    return Scaffold(
      body: Consumer(
        builder: (context, ref, child) {
          final videoData = ref.watch(videoProvider(movie.id));
          //print('the video data is $videoData');

          return ListView(
            children: [
              videoData.when(
                data: (data) {
                  //print(data[0]);
                  return data.isEmpty
                      ? const Center(child: Text('no keys were found'))
                      : Container(
                          height: 300,
                          child: PlayVideoFromNetwork(
                            videoKey: data[0],
                          ),
                        );
                },
                error: (err, s) => Text('$err'),
                loading: () => Container(),
              )
            ],
          );
        },
      ),
    );
  }
}

class PlayVideoFromNetwork extends StatefulWidget {
  final String videoKey;
  const PlayVideoFromNetwork({Key? key, required this.videoKey})
      : super(key: key);

  @override
  State<PlayVideoFromNetwork> createState() => _PlayVideoFromNetworkState();
}

class _PlayVideoFromNetworkState extends State<PlayVideoFromNetwork> {
  late final PodPlayerController controller;

  @override
  void initState() {
    // controller = PodPlayerController(
    //   playVideoFrom: PlayVideoFrom.youtube('https://youtu.be/${widget.key}'),
    //   podPlayerConfig: const PodPlayerConfig(
    //     autoPlay: true,
    //     isLooping: false,
    //     videoQualityPriority: [1080, 720],
    //   )
    // )..initialise();
    controller = PodPlayerController(
        playVideoFrom:
            PlayVideoFrom.youtube('https://youtu.be/${widget.videoKey}'),
        podPlayerConfig: const PodPlayerConfig(
          autoPlay: true,
          isLooping: false,
          //videoQualityPriority: [1080, 720, 360],
        ))
      ..initialise();
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PodVideoPlayer(controller: controller),
    );
  }
}
