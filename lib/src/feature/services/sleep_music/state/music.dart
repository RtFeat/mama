import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:mama/src/data.dart';

import 'package:mobx/mobx.dart';
import 'package:skit/skit.dart';

part 'music.g.dart';

class MusicStore extends _MusicStore with _$MusicStore {
  MusicStore({
    required super.audioPlayerStore,
    required super.apiClient,
    required super.faker,
  });
}

abstract class _MusicStore extends PaginatedListStore<TrackModel> with Store {
  final AudioPlayerStore audioPlayerStore;
  _MusicStore({
    required this.audioPlayerStore,
    required super.apiClient,
    required super.faker,
  }) : super(
          testDataGenerator: () {
            return TrackModel(
              id: faker.datatype.uuid(),
              title: faker.lorem.word(),
              description: faker.lorem.text(),
              author: MusicAuthorModel(
                id: faker.datatype.uuid(),
                name: faker.name.fullName(),
              ),
              duration: faker.datatype.float(max: 1000),
              createdAt: faker.date.past(DateTime.now()),
            );
          },
          basePath: Endpoint.music,
          fetchFunction: (params, path) =>
              apiClient.get('$path/music', queryParams: params),
          transformer: (raw) {
            final List<TrackModel>? data = (raw['music'] as List?)
                ?.map((e) => TrackModel.fromJson(e))
                .toList();
            // return data ?? [];
            return {
              'main': data ?? [],
            };
          },
        ) {
    _playerStateSub = audioPlayerStore.player.onPlayerStateChanged.listen(
      (event) {
        if (event == PlayerState.completed && isLooping) {
          runInAction(() {
            nextMusic();
            if (selectedMusic?.source != null) {
              audioPlayerStore.play(selectedMusic!.source!);
            }
            audioPlayerStore.playerState = event;
          });
        }
      },
    );

    _sourceReaction = reaction<Source?>(
      (_) => audioPlayerStore.source,
      (source) {
        if (source == null) {
          setSelectedMusic(null);
        } else {
          _syncSelectedMusicWithPlayer(source);
        }
      },
      fireImmediately: true,
    );

    _listDataReaction = reaction<int>(
      (_) => listData.length,
      (_) {
        final Source? currentSource = audioPlayerStore.source;
        if (selectedMusic == null && currentSource != null) {
          _syncSelectedMusicWithPlayer(currentSource);
        }
      },
    );
  }

  StreamSubscription<PlayerState>? _playerStateSub;
  ReactionDisposer? _sourceReaction;
  ReactionDisposer? _listDataReaction;

  void _syncSelectedMusicWithPlayer(Source source) {
    if (source is! UrlSource) return;
    final Uri? uri = Uri.tryParse(source.url);
    if (uri == null || uri.pathSegments.isEmpty) return;
    final String trackId = uri.pathSegments.last;
    if (selectedMusic?.id == trackId) {
      return;
    }
    for (final TrackModel track in listData) {
      if (track.id == trackId) {
        setSelectedMusic(track);
        break;
      }
    }
  }

  @computed
  bool get isStopped => audioPlayerStore.isStopped;

  @observable
  TrackModel? selectedMusic;

  @action
  void setSelectedMusic(TrackModel? music) => selectedMusic = music;

  @observable
  bool isLooping = false;

  @action
  void toggleIsLooping() => isLooping = !isLooping;

  @computed
  bool get isMusicSelected => selectedMusic != null;

  @computed
  int get _index => listData.indexOf(selectedMusic!);

  @computed
  bool get isHasNextMusic =>
      selectedMusic != null &&
      listData.length > 1 &&
      _index < listData.length - 1;

  @action
  void nextMusic() {
    if (selectedMusic != null) {
      if (_index < listData.length - 1) {
        setSelectedMusic(listData[_index + 1]);
      } else if (isLooping) {
        setSelectedMusic(listData[0]);
      }
    }
  }

  @action
  void stopMusic() {
    if (selectedMusic != null) {
      setSelectedMusic(null);
    }
  }

  void dispose() {
    _playerStateSub?.cancel();
    _sourceReaction?.call();
    _listDataReaction?.call();
  }
}
