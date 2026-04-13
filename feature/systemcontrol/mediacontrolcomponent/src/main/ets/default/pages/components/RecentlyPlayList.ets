/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { MediaInfoListData } from '../../viewmodel/MediaInfoListData';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/utils/LogHelper';
import { image } from '@kit.ImageKit';
import JumpingNotes from './JumpingNotes';
import Constants from '../../Util/Constants';
import { ThreadUtil } from '@ohos/basicutils/src/main/ets/utils/ThreadUtil';
import { SysConfigData } from '../../viewmodel/SysConfigData';
import { MediaViewModelManager, MediaVMType } from '../../viewmodel/MediaViewModelManager';
import { ResourceVm } from '@ohos/systemuicommon/src/main/ets/vm/ResourceVm';
import Curves from '@ohos.curves';

const TAG: string = 'RecentlyPlayList';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.MC, TAG);

@Component
export struct RecentlyPlayList {
  @StorageLink('mediaInfoListData')  mediaInfoListData: MediaInfoListData[] = [];
  @State isFromExpandDevice: boolean = false;
  @Prop isControlCenterOpen: boolean = false;
  public clickAvQueueItem: (bundleName: string, queueId: string, sessionId: string) => void = () => {};
  public startAimApp: (sessionId: string) => void = () => {};
  public startDefaultAppNow: (sessionId: string, isFromSessionCreate: boolean, callPlay: boolean) => void = () => {};
  public clickActiveApp: (sessionId: string, isPlaying: boolean) => void = () => {};
  public listItemClicked: (click: boolean) => void = () => {};

  build() {
    List({ space: 12 }) {
      ForEach(this.mediaInfoListData, (mediaInfo: MediaInfoListData) => {
        ListItem() {
          RecentlyPlayItem({
            mediaInfoData: mediaInfo,
            clickAvQueueItem: this.clickAvQueueItem,
            startAimApp: this.startAimApp,
            startDefaultAppNow: this.startDefaultAppNow,
            clickActiveApp: this.clickActiveApp,
            listItemClicked: this.listItemClicked,
            isFromExpandDevice: this.isFromExpandDevice,
            isControlCenterOpen: this.isControlCenterOpen,
          })
        }
      })
    }
  }
}

@Component
struct RecentlyPlayItem {
  @ObjectLink mediaInfoData: MediaInfoListData;
  @Prop isFromExpandDevice: boolean = false;
  @Prop isControlCenterOpen: boolean = false;
  public clickAvQueueItem: (bundleName: string, queueId: string, sessionId: string) => void = () => {};
  public startAimApp: (sessionId: string) => void = () => {};
  public startDefaultAppNow: (sessionId: string, isFromSessionCreate: boolean, callPlay: boolean) => void = () => {};
  public clickActiveApp: (sessionId: string, isPlaying: boolean) => void = () => {};
  public listItemClicked: (click: boolean) => void = () => {};
  @Consume('maxTextFontScale') maxTextFontScale: number;
  @State sysConfigData: SysConfigData | undefined = ThreadUtil.isMainThread ?
    MediaViewModelManager.getData(MediaVMType.SYS_CONFIG_DATA, true) as SysConfigData : undefined;
  @State itemScale: number = 1;
  private uiContext: UIContext = this.getUIContext();

  isRTL() {
    // 隔离主线程调用
    return ThreadUtil.isMainThread ? !!this.sysConfigData?.isRTL : ResourceVm.instance.isRTL;
  }

  @Builder
  noImageBuilder() {
    Column() {
      Image($r('app.media.ic_nomusic_img'))
        .fillColor($r('app.color.media_control_icon_disable'))
        .width(40)
        .height(40)
        .borderRadius(8)
        .draggable(false)
    }
    .width(40)
    .height(40)
    .borderRadius(8)
    .backgroundColor($r('app.color.media_control_default_img_bgc'))
  }

  @Builder
  imageBuilder(imageResource: image.PixelMap | string) {
    Image(imageResource)
      .fillColor($r('app.color.media_control_icon_disable'))
      .width(40)
      .height(40)
      .borderRadius(8)
      .draggable(false)
  }

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
      Stack({ alignContent: Alignment.BottomEnd }) {
        if (this.mediaInfoData.hasMedia) {
          if (!this.mediaInfoData.album || this.mediaInfoData.album === '') {
            this.noImageBuilder();
          } else {
            this.imageBuilder(this.mediaInfoData.album);
          }
        } else {
          if (!this.mediaInfoData.queueAlbum || this.mediaInfoData.queueAlbum === '') {
            this.noImageBuilder();
          } else {
            this.imageBuilder(this.mediaInfoData.queueAlbum);
          }
        }

        Image(this.mediaInfoData.appIcon)
          .width(12)
          .height(12)
          .draggable(false)
      }
      .flexGrow(0)
      .flexShrink(0)
      .flexBasis('auto')
      .onClick(() => {
        let sessionId = this.mediaInfoData.sessionId;
        this.startAimApp(sessionId);
        log.showInfo(`jump app ${this.mediaInfoData.title}, avqueueName: ${this.mediaInfoData.queueName}, appName:
           ${this.mediaInfoData.appName}`);
      })
      .accessibilityGroup(true)
      .accessibilityLevel('yes')
      .accessibilityText($r('app.string.access_cover_image'))

      Column() {
        if (this.mediaInfoData.hasMedia) {
          Column() {
            Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center }) {
              Text(this.mediaInfoData.title)
                .fontSize(14)
                .fontColor(this.mediaInfoData.isPlaying ? $r('sys.color.icon_emphasize') : $r('sys.color.font_primary'))
                .fontWeight($r('sys.string.ohos_id_text_font_family_medium'))
                .maxLines(2)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
                .flexBasis('auto')
                .constraintSize({ maxWidth: Constants.RECENTLY_PLAY_TEXT_MAX_LENGTH })
                .maxFontScale(this.maxTextFontScale)
                .direction(this.isRTL() ? Direction.Rtl : Direction.Ltr)

              if (this.isFromExpandDevice ? this.isControlCenterOpen && this.mediaInfoData.isPlaying :
                this.mediaInfoData.isPlaying) {
                JumpingNotes({
                  lottieFileName: 'jumping_notes.json',
                  isPlaying: this.mediaInfoData.isPlaying
                })
                  .margin({ left: this.isRTL() ? 0 : 4, right: this.isRTL() ? 4 : 0 })
                  .width(16)
                  .height(12)
              }
            }

            Text(this.mediaInfoData.author)
              .width('100%')
              .fontSize(12)
              .fontColor(this.mediaInfoData.isPlaying ? $r('sys.color.icon_emphasize') : $r('sys.color.font_secondary'))
              .fontWeight($r('sys.string.ohos_id_text_font_family_regular'))
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({ top: 2 })
              .maxFontScale(this.maxTextFontScale)
              .direction(this.isRTL() ? Direction.Rtl : Direction.Ltr)
          }
          .justifyContent(FlexAlign.Start)
        } else if (this.mediaInfoData.queueName && this.mediaInfoData.queueName !== '') {
          Text(this.mediaInfoData.queueName)
            .fontSize(14)
            .fontColor($r('sys.color.font_primary'))
            .fontWeight($r('sys.string.ohos_id_text_font_family_medium'))
            .maxLines(2)
            .textOverflow({ overflow: TextOverflow.Ellipsis })
            .maxFontScale(this.maxTextFontScale)
            .direction(this.isRTL() ? Direction.Rtl : Direction.Ltr)
            .width('100%')
            .constraintSize({ minHeight: 40 })
        } else {
          Column() {
            Text($r('app.string.recently_played_songs'))
              .fontSize(14)
              .fontColor($r('sys.color.font_primary'))
              .fontWeight($r('sys.string.ohos_id_text_font_family_medium'))
              .maxLines(2)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .maxFontScale(this.maxTextFontScale)
              .direction(this.isRTL() ? Direction.Rtl : Direction.Ltr)

            Text(this.mediaInfoData.appName)
              .fontSize(12)
              .fontColor($r('sys.color.font_secondary'))
              .fontWeight($r('sys.string.ohos_id_text_font_family_regular'))
              .margin({ top: 2 })
              .maxFontScale(this.maxTextFontScale)
              .direction(this.isRTL() ? Direction.Rtl : Direction.Ltr)
          }
          .width('100%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Start)
          .constraintSize({ minHeight: 40 })
        }
      }
      .flexBasis('auto')
      .justifyContent(FlexAlign.Center)
      .padding({ left: this.isRTL() ? 0 : 12, right: this.isRTL() ? 12 : 0 })
      .onClick(() => {
        if (this.mediaInfoData.hasMedia) {
          this.clickActiveApp(this.mediaInfoData.sessionId, this.mediaInfoData.isPlaying);
          log.showInfo(`click active app ${this.mediaInfoData.title}`);
        } else if (this.mediaInfoData.isAVQueue) {
          this.clickAvQueueItem(this.mediaInfoData.bundleName, this.mediaInfoData.avQueueId,
            this.mediaInfoData.sessionId);
          log.showInfo(`click avqueue item ${this.mediaInfoData.queueName}`);
        } else {
          this.startDefaultAppNow(this.mediaInfoData.sessionId, false, true);
          log.showInfo(`click start app ${this.mediaInfoData.appName}`);
        }
        this.listItemClicked(true);
      })
    }
    .width('100%')
    .scale({x: this.itemScale, y: this.itemScale, z: this.itemScale, centerX: '50%', centerY: '50%'})
    .onTouch((event: TouchEvent) => {
      if (TouchType.Up === event.type) {
        this.uiContext.animateTo({
          curve: Curves.interpolatingSpring(1, 1, 410, 38),
        }, () => {
          this.itemScale = 1;
        });
      }
      if (TouchType.Down === event.type) {
        this.uiContext.animateTo({
          curve: Curves.interpolatingSpring(1, 1, 410, 38),
        }, () => {
          this.itemScale = 0.95;
        });
      }
    })
  }
}