import 'package:audioplayers/audioplayers.dart';
import 'package:mama/src/data.dart';
import 'package:mobx/mobx.dart';

part 'player.g.dart';

class AudioPlayerStore extends _AudioPlayerStore with _$AudioPlayerStore {
  AudioPlayerStore();
}

abstract class _AudioPlayerStore with Store {
  final AudioPlayer player = AudioPlayer();

  @observable
  PlayerState? playerState;

  @observable
  Source? source;

  @computed
  bool get isPlaying => playerState == PlayerState.playing;

  @computed
  bool get isPaused => playerState == PlayerState.paused;

  @computed
  bool get isStopped => playerState == PlayerState.stopped;

  @computed
  bool get isCompleted => playerState == PlayerState.completed;

  @observable
  Duration? duration;

  @observable
  Duration? position;

  _AudioPlayerStore() {
    player.onPlayerStateChanged.listen((state) {
      runInAction(() => playerState = state);
    });

    player.onDurationChanged.listen((duration) {
      runInAction(() => this.duration = duration);
    });

    player.onPositionChanged.listen((position) {
      runInAction(() => this.position = position);
    });
  }

  @action
  Future<void> seek(Duration position) async {
    await player.seek(position);
  }

  @action
  Future<void> play(Source musicSource) async {
    try {
      if (source != null && source != musicSource) {
        await player.stop();
      }
      source = musicSource;
      await player.play(musicSource);
    } catch (e) {
      logger.error('Error playing audio: $e');
    }
  }

  Future<void> resume() async {
    await player.resume();
  }

  Future<void> pause() async {
    await player.pause();
  }

  @action
  Future<void> stop() async {
    await player.stop();
    source = null;
  }

  void dispose() {
    player.dispose();
  }
}
