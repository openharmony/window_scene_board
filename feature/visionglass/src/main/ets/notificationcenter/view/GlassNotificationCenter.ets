/*
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

import { NtfColor, NtfSize } from '../../common/constants/GlassLayoutConstants';
import NotificationConstant from '../common/NotificationConstant';
import { GlassNotificationListItem } from '../components/GlassNotificationListItem';
import { GlassNtfListVm } from '../vm/GlassNtfListVm';
import { NotificationGlassVm, NotificationUtil } from '../vm/NotificationGlassVm';
import { NotificationGlassVmArray } from '../vm/NotificationVmItemArray';
import DateTime from '../../common/utils/DateTime';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { GlassNotificationDate } from '../components/GlassNotificationDate';
import { GlassSystemSceneManager, GlassSystemSceneType } from '../../scene/common/GlassSystemSceneManager';

const TAG = 'GlassNotificationCenter';
const log = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export default struct GlassNotificationCenter {
  @State @Watch('onNtfListChange') ntfGroupList: NotificationGlassVmArray = new NotificationGlassVmArray();
  @Provide mDateTime: DateTime = new DateTime();
  @State buttonVisibility: Visibility = Visibility.Hidden;

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    this.mDateTime.init(getContext(this));
    GlassNtfListVm.getInstance().registerNtfCenterComponent(this);
    GlassNtfListVm.getInstance().init();
  }

  public aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
    this.mDateTime.release();
    GlassNtfListVm.destroyInstance();
  }

  onNtfListChange(): void {
    log.showInfo(`onNtfListChange ntfGroupList num is ${this.ntfGroupList.length}`);
    if (this.ntfGroupList.length > 0) {
      this.buttonVisibility = Visibility.Visible;
    } else {
      this.buttonVisibility = Visibility.Hidden;
    }
  }

  onClose() {
    GlassSystemSceneManager.getInstance().hideSystemView(GlassSystemSceneType.GLASS_NOTIFICATION_CENTER);
  }

  @Builder
  itemEnd(notificationGlassVm: NotificationGlassVm) {
    Button({ type: ButtonType.Circle }) {
      Image($r('app.media.glass_nfscenter_delete'))
        .width(NtfSize.CLEAR_BG_SIZE)
        .height(NtfSize.CLEAR_BG_SIZE)
    }
    .backgroundColor(NtfColor.NTF_CLEAR_BUTTON_COLOR)
    .width(NtfSize.CLEAR_BG_SIZE)
    .height(NtfSize.CLEAR_BG_SIZE)
    .margin({ left: NotificationConstant.NTF_MARGIN_47 })
    .borderRadius(NotificationConstant.BORDERRADIUS_100)
    .onClick(() => {
      log.showInfo(`Click deleteButton to remove ntf ${notificationGlassVm.hashCode}`);
      GlassNtfListVm.getInstance().clearByItemGroup(notificationGlassVm);
    })
  }

  build() {
    Stack() {
      Column()
        .width('100%')
        .height('100%')
        .backgroundBlurStyle(BlurStyle.Thick, {
          scale: 0.7,
          blurOptions: {
            grayscale: [40, 40]
          },
          colorMode: ThemeColorMode.DARK
        })
        .gesture(
          GestureGroup(GestureMode.Exclusive,
            TapGesture()
              .onAction(() => {
                this.onClose();
              }),
            PanGesture()
          )
        )
      Row({ space: NotificationConstant.SPACE_87 }) {
        Column() {
          GlassNotificationDate()
            .width(NotificationConstant.SINGLE_ITEM_WIDTH)
            .margin({
              bottom: NtfSize.NTF_TITLE_BOTTOM_MARGIN
            })

          List({ space: NotificationConstant.NTF_VERTICAL_SPACE }) {
            ForEach(this.ntfGroupList, (item: NotificationGlassVm, index: number) => {
              if (NotificationUtil.checkIsCallNtf(item)) {
                ListItem() {
                  GlassNotificationListItem({ notificationGlassVm: item })
                }
                .transition({ type: TransitionType.Delete, opacity: 0 })
              } else {
                ListItem() {
                  GlassNotificationListItem({ notificationGlassVm: item });
                }
                .transition({ type: TransitionType.Delete, opacity: 0 })
                .swipeAction({
                  end: {
                    builder: () => {
                      this.itemEnd(item);
                    },
                    onAction: () => {
                      animateTo({ duration: 60 }, () => {
                        log.showInfo(`swipeAction to remove ntf ${item.hashCode}`);
                        GlassNtfListVm.getInstance().clearByItemGroup(item);
                      })
                    },
                    actionAreaDistance: 60
                  }
                })
              }
            }, (item: NotificationGlassVm, index: number) => item.getListKey() + index)
          }
          .backgroundColor(Color.Transparent)
          .width(NotificationConstant.SINGLE_ITEM_WIDTH)
          .layoutWeight(1)
          .scrollBar(BarState.Off)
          .hitTestBehavior(HitTestMode.Transparent)
        }
        .alignItems(HorizontalAlign.Start)
        .width(NotificationConstant.SINGLE_ITEM_WIDTH)
        .height(NotificationConstant.NTF_HEIGHT_820)
        .hitTestBehavior(HitTestMode.Transparent)

        Button({ type: ButtonType.Circle }) {
          Image($r('app.media.glass_nfscenter_delete'))
            .width(NtfSize.CLEAR_BG_SIZE)
            .height(NtfSize.CLEAR_BG_SIZE)
        }
        .onClick(() => {
          animateTo({ duration: 250 }, () => {
            GlassNtfListVm.getInstance().clearAllNtf();
          })
        })
        .borderRadius(NotificationConstant.BORDERRADIUS_100)
        .width(NtfSize.CLEAR_BG_SIZE)
        .height(NtfSize.CLEAR_BG_SIZE)
        .visibility(this.buttonVisibility)
        .backgroundColor(NtfColor.NTF_CLEAR_BUTTON_COLOR)
      }
      .justifyContent(FlexAlign.Center)
      .margin({ left: NotificationConstant.NTF_MARGIN_164 })
      .hitTestBehavior(HitTestMode.Transparent)
    }
    .width('100%')
    .height('100%')
  }
}