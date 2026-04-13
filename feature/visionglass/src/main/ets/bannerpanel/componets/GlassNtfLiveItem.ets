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

import { NotificationEntry } from '@ohos/notificationcomponent/src/main/ets/model/NotificationEntry';
import { LiveSystemTemplate } from '@ohos/systemuicommon/src/main/ets/liveview/data/template/LiveSystemTemplate';
import { LiveButtonData } from '@ohos/systemuicommon/src/main/ets/liveview/data/extend/LiveButtonData';
import { GlassSceneManager } from '../../scene/common/GlassSceneManager';
import { GlassLayoutColor, NtfSize } from '../../common/constants/GlassLayoutConstants';
import { GlassBannerLayoutStyle } from '../view/GlassBannerStyle';
import GlassNtfConstant from '../common/GlassNtfConstant';
import { LogDomain, LogHelper } from '@ohos/basicutils/src/main/ets/TsIndex';

const TAG = 'GlassNtfLiveItem';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.VISION_GLASS, TAG);

@Component
export struct GlassNtfLiveItem {
  @Consume ntf: NotificationEntry | null;

  aboutToAppear(): void {
    log.showInfo('about to appear');
  }

  aboutToDisappear(): void {
    log.showInfo('about to disappear');
  }

  private getLargeIconBoardRadius(): Length {
    if ((this.ntf?.liveViewData?.template as LiveSystemTemplate | undefined)?.hasOverlayIcon()) {
      return GlassBannerLayoutStyle.CARD_LARGE_ICON_RADIUS;
    }
    return GlassBannerLayoutStyle.LEFT_LARGE_ICON_RADIUS;
  }

  @Builder
  buildNtfIcon() {
    if (this.ntf) {
      Stack({ alignContent: Alignment.BottomEnd }) {
        Image((this.ntf.liveViewData?.template as LiveSystemTemplate | undefined)?.getLeftLargeIcon())
          .width(GlassBannerLayoutStyle.ICON_SIZE_64)
          .height(GlassBannerLayoutStyle.ICON_SIZE_64)
          .objectFit(ImageFit.Contain)
          .draggable(false)
          .borderRadius(this.getLargeIconBoardRadius())
          .clip((this.ntf.liveViewData?.template as LiveSystemTemplate | undefined)?.hasOverlayIcon())
          .interpolation(ImageInterpolation.Medium)
          .border({
            width: GlassBannerLayoutStyle.BORDER_WIDTH,
            color: GlassLayoutColor.BORDER_COLOR,
            radius: this.getLargeIconBoardRadius()
          })

        if ((this.ntf.liveViewData?.template as LiveSystemTemplate | undefined)?.hasOverlayIcon()) {
          Image((this.ntf.liveViewData?.template as LiveSystemTemplate | undefined)?.getLeftSmallIcon())
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

  @Builder
  buildNtfContent() {
    if (this.ntf) {
      Row() {
        Column() {
          Text(`${(this.ntf.liveViewData?.template as LiveSystemTemplate | undefined)?.title}`)
            .fontColor(Color.Black)
            .fontSize(GlassBannerLayoutStyle.FONT_SIZE_28)
            .lineHeight(GlassBannerLayoutStyle.FONT_SIZE_37)
            .fontWeight(GlassBannerLayoutStyle.FONT_WEIGHT_500)
            .fontFamily(GlassBannerLayoutStyle.FONT_FAMILY_ohos_BOLD)
            .margin(GlassBannerLayoutStyle.LIVE_CONTENT_TEXT_MARGIN)
          Text(`${(this.ntf.liveViewData?.template as LiveSystemTemplate | undefined)?.content}`)
            .fontColor(GlassLayoutColor.TEXT_CONTENT_COLOR)
            .fontSize(GlassBannerLayoutStyle.FONT_SIZE_28)
            .lineHeight(GlassBannerLayoutStyle.FONT_SIZE_37)
            .fontWeight(GlassBannerLayoutStyle.FONT_WEIGHT_400)
            .fontFamily(GlassBannerLayoutStyle.FONT_FAMILY_ohos_BOLD)
        }
        .alignItems(HorizontalAlign.Start)

        this.buildNtfButton()
      }
      .justifyContent(FlexAlign.SpaceBetween)
      .width(GlassBannerLayoutStyle.LIVE_CONTENT_WIDTH)
    }
  }

  @Builder
  buildNtfButton() {
    if (this.ntf && this.ntf.liveViewData?.getButtonData()?.length) {
      Row() {
        ForEach(this.ntf.liveViewData.getButtonData(), (buttonData: LiveButtonData) => {
          Stack() {
            Column()
              .width(GlassBannerLayoutStyle.ICON_SIZE_80)
              .height(GlassBannerLayoutStyle.ICON_SIZE_80)
            Image(buttonData.getButtonIcon())
              .syncLoad(true)
              .objectFit(ImageFit.Contain)
              .draggable(false)
              .autoResize(false)
              .interpolation(ImageInterpolation.Medium)
          }
          .id(`${TAG}_${this.ntf?.liveViewData?.creatorBundleName}_${this.ntf?.liveViewData?.id}_${buttonData.name}`)
          .accessibilityText(buttonData.accessibilityText)
          .height(GlassBannerLayoutStyle.ICON_SIZE_80)
          .width(GlassBannerLayoutStyle.ICON_SIZE_80)
          .clip(true)
          .margin(GlassBannerLayoutStyle.LIVE_BUTTONS_MARGIN)
          .onClick(() => {
            log.showInfo(`button clicked`);
            buttonData.clickAction?.(buttonData, this.ntf?.liveViewData);
          })
        })
      }
    }
  }

  @Builder
  buildOverlayIcon() {
    if ((this.ntf?.liveViewData?.template as LiveSystemTemplate | undefined)?.hasOverlayIcon()) {
      Image((this.ntf?.liveViewData?.template as LiveSystemTemplate | undefined)?.getLeftSmallIcon())
        .width(NtfSize.HINT_CALL_APP_SIZE)
        .height(NtfSize.HINT_CALL_APP_SIZE)
        .objectFit(ImageFit.Contain)
        .draggable(false)
        .interpolation(ImageInterpolation.Medium)
        .margin(GlassBannerLayoutStyle.LIVE_OVERLAY_ICON_MARGIN)
    }
  }

  @Builder
  buildHintContent() {
    Row() {
      Row({ space: GlassBannerLayoutStyle.INCOME_CALL_TEXT_SPACE }) {
        Text($r('app.string.Incoming_call_title',
          (this.ntf?.liveViewData?.template as LiveSystemTemplate | undefined)?.title))
          .fontColor(GlassLayoutColor.TEXT_TITLE_COLOR)
          .fontSize(GlassBannerLayoutStyle.FONT_SIZE_28)
          .lineHeight(GlassBannerLayoutStyle.FONT_SIZE_33)
          .fontWeight(GlassBannerLayoutStyle.FONT_WEIGHT_700)
          .fontFamily(GlassBannerLayoutStyle.FONT_FAMILY_SANS_SC)

        Text($r('app.string.Incoming_call_prompt'))
          .fontColor(GlassLayoutColor.TEXT_CONTENT_COLOR)
          .fontSize(GlassBannerLayoutStyle.FONT_SIZE_28)
          .lineHeight(GlassBannerLayoutStyle.FONT_SIZE_33)
          .fontWeight(GlassBannerLayoutStyle.FONT_WEIGHT_700)
          .fontFamily(GlassBannerLayoutStyle.FONT_FAMILY_SANS_SC)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .layoutWeight(1)
          .maxLines(1)
      }
      .layoutWeight(1)
    }
    .width(GlassBannerLayoutStyle.BANNER_FOLDS_CONTENT_WIDTH)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  build() {
    if (this.ntf && this.ntf.creatorBundleName === GlassNtfConstant.PHONE_BUNDLE_NAME) {
      if (!GlassSceneManager.getInstance().isAliceAppForeground()) {
        Column() {
          Row() {
            this.buildOverlayIcon();
            this.buildHintContent();
          }
        }
        .width(GlassNtfConstant.HINT_WIDTH)
        .height(GlassNtfConstant.HINT_HEIGHT)
        .backdropBlur(GlassBannerLayoutStyle.BANNER_BLUR)
        .backgroundColor(GlassLayoutColor.BACKGROUND_REGULAR_COLOR)
        .borderRadius(GlassBannerLayoutStyle.BORDER_RADIUS)
        .padding(GlassBannerLayoutStyle.PHONE_HINT_PADDING)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)
      } else {
        Column() {
          Row() {
            this.buildNtfIcon();
            this.buildNtfContent();
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .width('100%')
        }
        .width(GlassNtfConstant.LIVE_WIDTH)
        .height(GlassNtfConstant.LIVE_HEIGHT)
        .backdropBlur(GlassBannerLayoutStyle.BANNER_BLUR)
        .backgroundColor(GlassLayoutColor.BACKGROUND_REGULAR_COLOR)
        .borderRadius(GlassBannerLayoutStyle.BORDER_RADIUS)
        .padding(GlassBannerLayoutStyle.BANNER_PADDING)
        .alignItems(HorizontalAlign.Start)
        .justifyContent(FlexAlign.Center)
      }
    }
  }
}