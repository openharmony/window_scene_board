/**
 * Copyright (c) Huawei Device Co., Ltd. 2024-2025. All rights reserved.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { CardMediaController } from '../../Controller/CardMediaController';
import AnimationIconLocal from './AnimationIconLocal';
import AVSessionManager from '@ohos.multimedia.avsession';
import { globalStorage } from '../../Util/GlobalStorage';
import I18n from '@ohos.i18n';

const TAG = 'MediaSinks_debug';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

@Component
export struct MediaSinks {
  private controller: CardMediaController = CardMediaController.getInstance();
  @State isCanPlayPrevious: boolean = true;
  @State isCanPlayNext: boolean = true;
  @StorageLink('MediaTitle') title: string = '';
  @StorageLink('MediaArtist') artist: string = '';
  @StorageLink('MediaPlayState') playState : number = 0;
  @State isNarrow: boolean = false;
  private isSink: boolean = false;
  private readonly BTN_SIZE = 32;
  private readonly BIG_BTN_SIZE = 64;
  private readonly BTN_NEXT_SIZE = 24;
  private readonly BIG_BTN_NEXT_SIZE = 40;

  aboutToAppear() {
    this.isSink = true;
    AppStorage.setOrCreate('isSink', true)
    log.showInfo('aboutToAppear sinks' + this.isSink + 'isNarrow' + this.isNarrow + AppStorage.get('MediaType'));
  }
  aboutToDisappear() {
    AppStorage.setOrCreate('isSink', false)
    log.showInfo('aboutToDisappear sinks' + this.isSink);
  }

  isPlaying() {
    return !!((this.playState === AVSessionManager.PlaybackState.PLAYBACK_STATE_PLAY) ||
      (this.playState === AVSessionManager.PlaybackState.PLAYBACK_STATE_BUFFERING));
  }

  build() {
    if (AppStorage.get('MediaType') === 'audio') {
      if (this.isNarrow) {
        Row() {
          this.TitleComponent()
          this.SinkAudioComponent()
        }
      } else {
        Column() {
          this.TitleComponent()
          this.SinkAudioComponent()
        }
      }
    }
  }

  /**
   * 标题、副标题
   */
  @Builder TitleComponent() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
      Marquee({
        start: true,
        step: 6,
        loop: -1,
        src: this.title
      })
        .draggable(false)
        .fontColor($r('app.color.media_control_center_text_primary'))
        .fontSize(18 + 'vp')
        .fontWeight(600)
        .align(Alignment.Center)
        .clip(true)
        .visibility(this.isPlaying() && this.title ? Visibility.Visible : Visibility.None)
      Text(this.title)
        .draggable(false)
        .fontColor($r('app.color.media_control_center_text_primary'))
        .fontSize(18 + 'vp')
        .fontWeight(600)
        .textAlign(TextAlign.Center)
        .clip(true)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .visibility(this.isPlaying() && this.title ? Visibility.None : Visibility.Visible)

      Marquee({
        start: true,
        step: 6,
        loop: -1,
        src: this.artist
      })
        .draggable(false)
        .fontColor('#99FFFFFF')
        .fontSize(14 + 'vp')
        .fontWeight(FontWeight.Regular)
        .align(Alignment.Center)
        .clip(true)
        .margin({ top: this.isNarrow ? 2 : 0 })
        .visibility(this.isPlaying() && this.artist ? Visibility.Visible : Visibility.None)
      Text(this.artist)
        .draggable(false)
        .fontColor('#99FFFFFF')
        .fontSize(14 + 'vp')
        .fontWeight(FontWeight.Regular)
        .textAlign(TextAlign.Center)
        .clip(true)
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .margin({ top: this.isNarrow ? 2 : 0 })
        .visibility(this.isPlaying() && this.artist ? Visibility.None : Visibility.Visible)

    }
    .height(40)
    .width(this.isNarrow ? 144 : 100)
  }

  @Builder SinkAudioComponent() {
    Button() {
      AnimationIconLocal({
        active: this.isCanPlayPrevious,
        isControlCenter: 'sinks'
      })
        .size({ width: this.BTN_NEXT_SIZE, height: this.BTN_NEXT_SIZE })
        .rotate({ angle: 180 })
    }
    .onClick(() => {
      setTimeout(() => {
        globalStorage.setStringByKey('scenesType', 'cover');
        this.controller.callShowingPrevious();
      }, 166)
    })
    .size({ width: this.BIG_BTN_NEXT_SIZE, height: this.BIG_BTN_NEXT_SIZE })
    .backgroundColor(this.isNarrow ? '#00FFFFFF' : '#333333')
    .borderRadius('50%')
    .align(Alignment.Center)
    .margin({ top: this.isNarrow ? 0 : 36, left: this.isNarrow ?
      I18n.isRTL(I18n.System.getSystemLanguage()) ? 0 : 32 : 0,
      right: I18n.isRTL(I18n.System.getSystemLanguage()) && this.isNarrow ? 36 : 0 })

    Button() {
      Image(this.isPlaying() ? $r('app.media.ic_sink_pause') : $r('app.media.ic_sing_play'))
        .size({ width: this.BTN_NEXT_SIZE, height: this.BTN_NEXT_SIZE })
        .draggable(false)
        .fillColor('#FFFFFFFF')
        .rotate({ angle: I18n.isRTL(I18n.System.getSystemLanguage()) ? 180 : 0 })
    }
    .onClick(() => {
      log.showInfo(`mediaskins on play/pause click:`);
      if (this.isPlaying()) {
        globalStorage.setStringByKey('scenesType', 'cover');
        this.controller.callShowingPause();
      } else {
        globalStorage.setStringByKey('scenesType', 'cover');
        this.controller.callShowingPlay(false);
      }
    })
    .size({ width: this.BIG_BTN_SIZE, height: this.BIG_BTN_SIZE })
    .backgroundColor(this.isNarrow ? '#00FFFFFF' : '#333333')
    .margin({top: this.isNarrow ? 0 : 62, bottom: this.isNarrow ? 0 : 62,
      left: this.isNarrow ? 48 : 0, right: this.isNarrow ? 48 : 0})
    .borderRadius('50%')
    .align(Alignment.Center)

    Button() {
      AnimationIconLocal({
        active: this.isCanPlayNext,
        isControlCenter: 'sinks'
      })
        .size({ width: this.BTN_NEXT_SIZE, height: this.BTN_NEXT_SIZE })
    }
    .onClick(() => {
      setTimeout(() => {
        globalStorage.setStringByKey('scenesType', 'cover');
        this.controller.callShowingNext();
      }, 166)
    })
    .size({ width: this.BIG_BTN_NEXT_SIZE, height: this.BIG_BTN_NEXT_SIZE })
    .backgroundColor(this.isNarrow ? '#00FFFFFF' : '#333333')
    .borderRadius('50%')
    .align(Alignment.Center)
  }
}