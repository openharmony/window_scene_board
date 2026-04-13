/*
 * Copyright (c) Huawei Technologies Co., Ltd. 2024-2025. All rights reserved.
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

import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';
import { LiveButtonData } from '@ohos/systemuicommon/src/main/ets/liveview/data/extend/LiveButtonData';
import { LiveSystemTemplate } from '@ohos/systemuicommon/src/main/ets/liveview/data/template/LiveSystemTemplate';
import { GlassBannerLayoutStyle } from '../../bannerpanel/view/GlassBannerStyle';
import { GlassLiveTimeComponent } from '../../common/component/GlassLiveTimeComponent';
import { GlassLayoutColor, GlassLayoutSize, NtfColor, NtfSize } from '../../common/constants/GlassLayoutConstants';
import NotificationConstant from '../common/NotificationConstant';
import { GlassNtfListVm } from '../vm/GlassNtfListVm';
import { NotificationGlassVm, NotificationUtil } from '../vm/NotificationGlassVm';

const TAG = 'GlassNotificationLiveItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export default struct GlassNotificationLiveItem {
  @ObjectLink @Watch('onButtonNumChange') notificationGlassVm: NotificationGlassVm | null;
  @Prop glassBorderRadius: string;
  @State @Watch('onButtonNumChange') phoneButtonData: LiveButtonData | undefined = new LiveButtonData();
  @State isCallInStatus: boolean = false;

  aboutToAppear(): void {
    log.showInfo(`aboutToAppear`);
    let phoneButtonDatas = this.notificationGlassVm?.liveViewData?.getButtonData();
    if (phoneButtonDatas) {
      this.phoneButtonData = phoneButtonDatas[1];
      this.isCallInStatus = phoneButtonDatas.length === NotificationConstant.CALL_BUTTON_NUMBER;
    }
  }

  aboutToDisappear(): void {
    log.showInfo(`aboutToDisappear`);
  }

  build() {
    if (this.notificationGlassVm &&
      this.notificationGlassVm.creatorBundleName === NotificationConstant.PHONE_BUNDLE_NAME) {
      Column() {
        Row() {
          this.buildNtfIcon();
          if (this.isCallInStatus) {
            this.buildNtfContent();
          } else {
            this.buildPhoneContent();
          }
        }
        .justifyContent(FlexAlign.SpaceBetween)
        .width('100%')
      }
      .width(NotificationConstant.SINGLE_ITEM_WIDTH)
      .height(NotificationConstant.NTF_HEIGHT_122)
      .backgroundColor(NtfColor.NTF_BACKGROUND_COLOR)
      .borderRadius(this.glassBorderRadius)
      .padding(NotificationConstant.NTF_PADDING_24)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)
      .onClick(() => {
        log.showInfo(`click to handle ntf ${this.notificationGlassVm?.hashCode}`);
        NotificationUtil.clickNft(this.notificationGlassVm);
      })
    }
  }

  @Builder
  buildPhoneContent() {
    if (this.notificationGlassVm) {
      Row() {
        Column({ space: NotificationConstant.SPACE_20 }) {
          Text(`${(this.notificationGlassVm.liveViewData?.template as LiveSystemTemplate | undefined)?.title}`)
            .fontColor(NtfColor.NTF_TITLE_FONT_COLOR)
            .fontSize(GlassLayoutSize.FONT_SIZE_24)
            .lineHeight(GlassLayoutSize.FONT_SIZE_24)
            .margin(GlassBannerLayoutStyle.LIVE_CONTENT_TEXT_MARGIN)
          GlassLiveTimeComponent({
            timeData: this.notificationGlassVm?.liveViewData?.getTimerData(),
            viewFontSize: $r('app.float.glass_call_ntf_time_fontsize'),
            viewFontColor: NtfColor.NTF_TIME_FONT_COLOR,
          })
        }
        .height('100%')
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Start)

        if (this.phoneButtonData) {
          Row() {
            Stack() {
              Column()
                .width(NotificationConstant.BUTTON_SIZE_80)
                .height(NotificationConstant.BUTTON_SIZE_80)
              Image(this.phoneButtonData.getButtonIcon())
                .syncLoad(true)
                .objectFit(ImageFit.Contain)
                .draggable(false)
                .autoResize(false)
                .interpolation(ImageInterpolation.Medium)
                .id(`${TAG}_${this.notificationGlassVm.liveViewData?.creatorBundleName}_${this.notificationGlassVm.liveViewData?.id}_${this.phoneButtonData.name}`)
                .accessibilityText(this.phoneButtonData.accessibilityText)
                .height(NotificationConstant.BUTTON_SIZE_80)
                .width(NotificationConstant.BUTTON_SIZE_80)
                .clip(true)
                .margin(GlassBannerLayoutStyle.LIVE_BUTTONS_MARGIN)
                .onClick(() => {
                  log.info(`button clicked`);
                  this.phoneButtonData?.clickAction?.(this.phoneButtonData, this.notificationGlassVm?.liveViewData);
                  if (this.notificationGlassVm) {
                    GlassNtfListVm.getInstance().clearByItemGroup(this.notificationGlassVm);
                  }
                })
            }
          }
        }
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width(NotificationConstant.NTF_WIDTH_988)
    }
  }

  @Builder
  buildNtfButton() {
    if (this.notificationGlassVm && this.notificationGlassVm.liveViewData?.getButtonData()?.length) {
      Row() {
        ForEach(this.notificationGlassVm.liveViewData.getButtonData(), (buttonData: LiveButtonData) => {
          Stack() {
            Column()
              .width(NotificationConstant.BUTTON_SIZE_80)
              .height(NotificationConstant.BUTTON_SIZE_80)
            Image(buttonData.getButtonIcon())
              .syncLoad(true)
              .objectFit(ImageFit.Contain)
              .draggable(false)
              .autoResize(false)
              .interpolation(ImageInterpolation.Medium)
          }
          .id(`${TAG}_${this.notificationGlassVm?.liveViewData?.creatorBundleName}_${this.notificationGlassVm?.liveViewData?.id}_${buttonData.name}`)
          .accessibilityText(buttonData.accessibilityText)
          .height(NotificationConstant.BUTTON_SIZE_80)
          .width(NotificationConstant.BUTTON_SIZE_80)
          .clip(true)
          .margin(GlassBannerLayoutStyle.LIVE_BUTTONS_MARGIN)
          .onClick(() => {
            log.info(`button clicked`);
            buttonData.clickAction?.(buttonData, this.notificationGlassVm?.liveViewData);
            if (this.notificationGlassVm) {
              GlassNtfListVm.getInstance().clearByItemGroup(this.notificationGlassVm);
            }
          })
        })
      }
    }
  }

  @Builder
  buildNtfContent() {
    if (this.notificationGlassVm) {
      Row() {
        Column() {
          Text(`${(this.notificationGlassVm.liveViewData?.template as LiveSystemTemplate | undefined)?.title}`)
            .fontColor(NtfColor.NTF_TITLE_FONT_COLOR)
            .fontSize(GlassLayoutSize.FONT_SIZE_24)
            .lineHeight(GlassLayoutSize.FONT_SIZE_24)
            .margin(GlassBannerLayoutStyle.LIVE_CONTENT_TEXT_MARGIN)
          Text(`${(this.notificationGlassVm.liveViewData?.template as LiveSystemTemplate | undefined)?.content}`)
            .fontColor(NtfColor.NTF_CONTENT_FONT_COLOR)
            .fontSize(GlassLayoutSize.FONT_SIZE_24)
            .lineHeight(GlassLayoutSize.FONT_SIZE_24)
        }
        .alignItems(HorizontalAlign.Start)

        this.buildNtfButton()
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width(NotificationConstant.NTF_WIDTH_988)
    }
  }

  @Builder
  buildNtfIcon() {
    if (this.notificationGlassVm) {
      Stack({ alignContent: Alignment.BottomEnd }) {
        Image((this.notificationGlassVm.liveViewData?.template as LiveSystemTemplate | undefined)?.getLeftLargeIcon())
          .width(GlassBannerLayoutStyle.ICON_SIZE_64)
          .height(GlassBannerLayoutStyle.ICON_SIZE_64)
          .objectFit(ImageFit.Contain)
          .draggable(false)
          .borderRadius(this.getLargeIconBoardRadius())
          .clip((this.notificationGlassVm.liveViewData?.template as LiveSystemTemplate | undefined)?.hasOverlayIcon())
          .interpolation(ImageInterpolation.Medium)
          .border({
            width: GlassBannerLayoutStyle.BORDER_WIDTH,
            color: GlassLayoutColor.BORDER_COLOR,
            radius: this.getLargeIconBoardRadius()
          })

        if ((this.notificationGlassVm.liveViewData?.template as LiveSystemTemplate | undefined)?.hasOverlayIcon()) {
          Image((this.notificationGlassVm.liveViewData?.template as LiveSystemTemplate | undefined)?.getLeftSmallIcon())
            .width(NtfSize.APP_ICON_SIZE)
            .height(NtfSize.APP_ICON_SIZE)
            .margin(GlassBannerLayoutStyle.OVERLAY_ICON_MARGIN)
            .objectFit(ImageFit.Contain)
            .draggable(false)
            .interpolation(ImageInterpolation.Medium)
        }
      }
      .margin(GlassBannerLayoutStyle.NTF_ICON_MARGIN)
    }
  }

  private onButtonNumChange(): void {
    log.showInfo(`onButtonNumChange, current button num is ${this.notificationGlassVm?.liveViewData?.getButtonData()?.length}`);
    this.isCallInStatus =
      this.notificationGlassVm?.liveViewData?.getButtonData()?.length === NotificationConstant.CALL_BUTTON_NUMBER;
  }

  private getLargeIconBoardRadius(): Length {
    if ((this.notificationGlassVm?.liveViewData?.template as LiveSystemTemplate | undefined)?.hasOverlayIcon()) {
      return GlassBannerLayoutStyle.CARD_LARGE_ICON_RADIUS;
    }
    return GlassBannerLayoutStyle.LEFT_LARGE_ICON_RADIUS;
  }
}