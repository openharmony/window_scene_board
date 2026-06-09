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

import { NotificationBase } from '../model/NotificationBase';
import { SystemUIUseScene } from '../constants/SystemuiConstants';
import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LengthMetrics } from '@kit.ArkUI';
import { LiveViewCommonConstants } from '../liveview/common/LiveConstants';
import { LiveStyle } from '../live/constants/LiveStyle';
import { OverlayIconStyle } from '../model/NotificationContent';

const CARD_LARGE_ICON_SQUARE_RADIUS: string = '8vp';
const CARD_SMALL_ICON_SQUARE_RADIUS: string = '4vp';

interface NotificationAppIconViewParams {
  /**
   * 使用场景
   */
  scene: SystemUIUseScene;
  /**
   * 通知数据
   */
  ntf: NotificationBase;
  /**
   * 图标大小
   */
  iconSize: Length;
  /**
   * 是否仅使用overlay图标，在组通知下的子通知需要传true
   */
  onlyUseOverlay?: boolean;
  /**
   * 覆盖在右下角的小图标大小
   */
  topIconSize?: Length;
  /**
   * 图标点击事件
   * @param event
   */
  onClick?: (event: ClickEvent) => void;
  /**
   * 应用图标的透明度
   */
  iconAlpha?: number;
  /**
   * 覆盖在右下角的小图标透明度
   */
  topIconAlpha?:number;
  /**
   * 应用图标的背板可见性
   */
  iconBgVisible?: Visibility;
  /**
   * 覆盖在右下角的背板可见性
   */
  topIconBgVisible?: Visibility;
  /**
   * 应用图标的背板颜色
   */
  iconBgColor?: ResourceColor;
  /**
   * 覆盖在右下角的背板颜色
   */
  topIconBgColor?: ResourceColor;
}

const TAG = 'NotificationAppIconView';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);

@Builder
export function NotificationAppIconView($$: NotificationAppIconViewParams) {
  if (($$.ntf.overlayIcon && !$$.onlyUseOverlay) || $$.ntf.overlayIconStyle === OverlayIconStyle.REVERSE) {
    Stack({
      alignContent: $$.ntf.overlayIconStyle !== OverlayIconStyle.REVERSE ? Alignment.BottomEnd : Alignment.Center
    }) {
      if ($$.iconBgVisible === Visibility.Visible) {
        Column()
          .width($$.iconSize)
          .height($$.iconSize)
          .visibility($$.iconBgVisible)
          .backgroundColor($$.iconBgColor)
          .borderRadius($$.ntf.overlayIconStyle === OverlayIconStyle.SQUARE ? CARD_LARGE_ICON_SQUARE_RADIUS : '100%')
          .clip(true)
      }
      Image($$.ntf.getBigIcon())
        .id(`${$$.scene}_${TAG}_overlayIcon_${$$.ntf.hashCode}`)
        .draggable(false)
        .syncLoad(true)
        .autoResize(false)
        .objectFit(ImageFit.Contain)
        .interpolation(ImageInterpolation.Medium)
        .width($$.iconSize)
        .height($$.iconSize)
        .borderRadius($$.ntf.overlayIconStyle !== OverlayIconStyle.CIRCLE ? CARD_LARGE_ICON_SQUARE_RADIUS : '100%')
        .clip(true)
        .opacity($$.iconAlpha)
        .onError((e) => {
          log.showError(`Load overlay icon error, hashCode: ${$$.ntf.hashCode}, message: ${e.message}`);
          })

      if ($$.topIconBgVisible === Visibility.Visible) {
        Column()
          .width($$.topIconSize)
          .height($$.topIconSize)
          .visibility($$.topIconBgVisible)
          .backgroundColor($$.topIconBgColor)
          .borderRadius(CARD_SMALL_ICON_SQUARE_RADIUS)
          .clip(true)
          .margin({
            end: LengthMetrics.vp(LiveViewCommonConstants.LIVE_SMALL_ICON_MARGIN),
            bottom: LengthMetrics.vp(LiveViewCommonConstants.LIVE_SMALL_ICON_MARGIN)
          })
      }
      if ($$.ntf.overlayIconStyle !== OverlayIconStyle.REVERSE) {
        Image($$.ntf.getAppIcon())
          .id(`${$$.scene}_${TAG}_NotificationAppIconView_appIcon_${$$.ntf.hashCode}`)
          .draggable(false)
          .syncLoad(true) //解决图标渲染过程中闪的问题，如果造成性能卡顿，可以删除
          .autoResize(false)
          .objectFit(ImageFit.Contain)
          .interpolation(ImageInterpolation.Medium)
          .width($$.topIconSize)
          .height($$.topIconSize)
          .borderRadius(CARD_SMALL_ICON_SQUARE_RADIUS)
          .clip(true)
          .opacity($$.topIconAlpha)
          .margin({
            end: LengthMetrics.vp(LiveViewCommonConstants.LIVE_SMALL_ICON_MARGIN),
            bottom: LengthMetrics.vp(LiveViewCommonConstants.LIVE_SMALL_ICON_MARGIN)
          })
          .onError((e) => {
            log.showError(`Load app icon error, hashCode: ${$$.ntf.hashCode}, message: ${e.message}`);
          })
      }
    }
    .flexShrink(0)
    .width($$.iconSize)
    .height($$.iconSize)
    .onClick($$.onClick)
  } else {
    Stack() {
      if ($$.iconBgVisible === Visibility.Visible) {
        Column()
          .width($$.iconSize)
          .height($$.iconSize)
          .visibility($$.iconBgVisible)
          .backgroundColor($$.iconBgColor)
          .borderRadius(LiveStyle.LEFT_LARGE_ICON_RADIUS)
          .clip(true)
      }
      Image($$.ntf.getAppIcon())
        .id(`${$$.scene}_${TAG}_NotificationAppIconView_appIcon_${$$.ntf.hashCode}`)
        .draggable(false)
        .syncLoad(true) //解决图标渲染过程中闪的问题，如果造成性能卡顿，可以删除
        .autoResize(false)
        .objectFit(ImageFit.Contain)
        .interpolation(ImageInterpolation.Medium)
        .width($$.iconSize)
        .height($$.iconSize)
        .borderRadius(LiveStyle.LEFT_LARGE_ICON_RADIUS)
        .clip(true)
        .onClick($$.onClick)
        .opacity($$.iconAlpha)
        .onError((e) => {
          log.showError(`Load app icon error, hashCode: ${$$.ntf.hashCode}, message: ${e.message}`);
        })
    }
  }
}