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

import { LogDomain, LogHelper } from '@ohos/basicutils';
import { LengthMetrics } from '@kit.ArkUI';
import { OverlayIconStyle } from '../model/NotificationContent';
import { NotificationBase } from '../model/NotificationBase';
import { image } from '@kit.ImageKit';
import { ResourceVm } from '../vm/ResourceVm';
import { LiveCardType } from '../live/model/LiveCommonModel';
import { SystemUIUseScene } from '../constants/SystemuiConstants';

const TAG = 'NotificationIconView';
const log = LogHelper.getLogHelper(LogDomain.NC, TAG);

const BIG_ICON_SIZE = 32;
const BIG_ICON_RADIUS = 8;
const LITTLE_ICON_SIZE = 16;
const LITTLE_ICON_RIGHT_BOTTOM_OFFSET = -4;
const LITTLE_ICON_RADIUS = 4;
const CONTAINER_EXPAND_SIZE = 4;

const COLLA_IMAGE_WIDTH: number = 10;
const COLLA_BADGE_WIDTH = BIG_ICON_SIZE * 0.5;
const COLLA_BADGE_RIGHT_BOTTOM_OFFSET = -4;

// 通知图标缩小显示时的比例
export const NOTIFICATION_ICON_SMALL_SCALE = 0.625;

interface NotificationIconViewParams {
  /**
   * 场景
   */
  scene: string;
  /**
   * 通知数据
   */
  ntf: NotificationBase;
  /**
   * 大图标是否仅使用应用图标
   */
  isOnlyUseAppIcon?: boolean;
  /**
   * 是否隐藏右下角小图标
   */
  isHideLittleIcon?: boolean;
  /**
   * 图标整体缩放比例
   */
  scale?: number;
  /**
   * 图标整体透明度
   */
  opacity?: number;
  /**
   * 是否启用缓存组
   */
  renderGroup?: boolean;
  /**
   * 应用图标的透明度
   */
  bigIconOpacity?: number;
  /**
   * 覆盖在右下角的小图标透明度
   */
  littleIconOpacity?:number;
  /**
   * 应用图标的背板可见性
   */
  bigIconBgVisible?: Visibility;
  /**
   * 覆盖在右下角的背板可见性
   */
  littleIconBgVisible?: Visibility;
  /**
   * 应用图标的背板颜色
   */
  bigIconBgColor?: ResourceColor;
  /**
   * 覆盖在右下角的背板颜色
   */
  littleIconBgColor?: ResourceColor;
  /**
   * 是否需要共享转场动画
   */
  needGeometryTransition?: boolean;
  /**
   * 共享转场动画Id
   */
  geometryTransitionId?: string;
  /**
   * 外层属性修饰器
   */
  modifier?: AttributeModifier<CommonAttribute>;
  /**
   * 外层动画
   */
  animation?: AnimateParam;
  /**
   * 图标点击事件
   * @param event
   */
  onClick?: (event: ClickEvent) => void;
}

function getBigIcon($$: NotificationIconViewParams): string | image.PixelMap | undefined {
  if ($$.ntf.overlayIconStyle === OverlayIconStyle.REVERSE) {
    return $$.ntf.getAppIcon();
  }
  // 仅显示应用图标
  if ($$.isOnlyUseAppIcon || $$.scene === SystemUIUseScene.BANNER_MASK) {
    return $$.ntf.getAppIcon(true);
  }
  // 最后有overlay图标则显示，否则显示应用图标或小图标
  return $$.ntf.overlayIcon || $$.ntf.getAppIcon();
}


function getBigIconRadius($$: NotificationIconViewParams): Length {
  if ($$.ntf.overlayIconStyle === OverlayIconStyle.REVERSE) {
    return BIG_ICON_RADIUS * getScale($$);
  }
  // 仅显示应用图标不显示圆角
  if ($$.isOnlyUseAppIcon) {
    return BIG_ICON_RADIUS * getScale($$);
  }
  // 最后有overlay图标则显示为圆角
  return $$.ntf.overlayIcon && $$.ntf.overlayIconStyle === OverlayIconStyle.CIRCLE ?
    '100%' : BIG_ICON_RADIUS * getScale($$);
}

function getLittleIcon($$: NotificationIconViewParams): string | image.PixelMap | undefined {
  if ($$.ntf.isCollaNotification) {
    // 全场景通知不显示右下角设备来源图标场景：1. 导航模板类实况 2. isHideLitterIcon为true
    return ($$.ntf.isLiveView() && $$.ntf.card?.cardType === LiveCardType.NAVIGATION) || $$.isHideLittleIcon ?
      undefined : 'Colla';
  }
  return !$$.isOnlyUseAppIcon && $$.ntf.overlayIcon ? $$.ntf.getAppIcon() : undefined;
}

function getId($$: NotificationIconViewParams, suffix: string): string | undefined {
  if ($$.ntf.isNormalGroup() && $$.ntf.children.length > 0) {
    return `[${$$.scene}]${TAG}_${$$.ntf.children[0].hashCode}_${suffix}`;
  }
  return `[${$$.scene}]${TAG}_${$$.ntf.hashCode}_${suffix}`;
}

function getScale($$: NotificationIconViewParams): number {
  return $$.needGeometryTransition ? ($$.scale ?? 1) : 1;
}

@Builder
function buildLittleIconBg($$: NotificationIconViewParams) {
  if ($$.littleIconBgVisible === Visibility.Visible) {
    Column()
      .width(LITTLE_ICON_SIZE * getScale($$))
      .height(LITTLE_ICON_SIZE * getScale($$))
      .backgroundColor($$.littleIconBgColor)
      .borderRadius(LITTLE_ICON_RADIUS * getScale($$))
      .clip(true)
      .position({
        end: LengthMetrics.vp(LITTLE_ICON_RIGHT_BOTTOM_OFFSET),
        bottom: LengthMetrics.vp(LITTLE_ICON_RIGHT_BOTTOM_OFFSET)
      })
  }
}

/**
 * 全场景标识
 */
@Builder
export function NotificationCollaBadgeView($$: NotificationIconViewParams) {
  Stack({ alignContent: Alignment.Center }) {
    Column()
      .width('100%')
      .height('100%')
      .borderRadius('50%')
      .backgroundBlurStyle(BlurStyle.COMPONENT_REGULAR, { inactiveColor: $r('app.color.notification_colla_badge_bg_color') })

    Image($r('app.media.app_icon_phone_fill'))
      .draggable(false)
      .syncLoad(true)
      .autoResize(false)
      .width(COLLA_IMAGE_WIDTH * getScale($$))
      .height(COLLA_IMAGE_WIDTH * getScale($$))
      .objectFit(ImageFit.Contain)
  }
  .id(getId($$, 'collaBadge'))
  .geometryTransition($$.needGeometryTransition ? getId($$, 'collaBadge') : undefined, {
    hierarchyStrategy: TransitionHierarchyStrategy.NONE
  })
  .width(COLLA_BADGE_WIDTH * getScale($$))
  .height(COLLA_BADGE_WIDTH * getScale($$))
  .position({
    end: LengthMetrics.vp(COLLA_BADGE_RIGHT_BOTTOM_OFFSET * getScale($$)),
    bottom: LengthMetrics.vp(COLLA_BADGE_RIGHT_BOTTOM_OFFSET * getScale($$)),
  })
  .enabled(false)
}

@Builder
export function NotificationIconView($$: NotificationIconViewParams) {
  Row() {
    Stack({ alignContent: Alignment.Center }) {
      if ($$.bigIconBgVisible === Visibility.Visible) {
        Column()
          .width(BIG_ICON_SIZE * getScale($$))
          .height(BIG_ICON_SIZE * getScale($$))
          .visibility($$.bigIconBgVisible)
          .backgroundColor($$.bigIconBgColor)
          .borderRadius(getBigIconRadius($$))
          .clip(true)
      }
      Image(getBigIcon($$))
        .id(getId($$, 'bigIcon'))
        .geometryTransition($$.needGeometryTransition ? ($$.geometryTransitionId ?? getId($$, 'bigIcon')) : '',
          { hierarchyStrategy: TransitionHierarchyStrategy.NONE })
        .transition(TransitionEffect.IDENTITY)
        .draggable(false)
        .syncLoad(true)
        .autoResize(false)
        .objectFit(ImageFit.Contain)
        .interpolation(ImageInterpolation.Medium)
        .width(BIG_ICON_SIZE * getScale($$))
        .height(BIG_ICON_SIZE * getScale($$))
        .borderRadius(getBigIconRadius($$))
        .clip(true)
        .opacity($$.bigIconOpacity)
        .onError((e) => {
          log.showError(`Load big icon error, key: [${$$.scene}]${$$.ntf.hashCode}, message: ${e.message}`);
        })

      if (getLittleIcon($$) === 'Colla') {
        NotificationCollaBadgeView($$)
      } else if (!$$.isHideLittleIcon && getLittleIcon($$)) {
        buildLittleIconBg($$)
        Image(getLittleIcon($$))
          .id(getId($$, 'littleIcon'))
          .geometryTransition($$.needGeometryTransition ? getId($$, 'littleIcon') : '', {
            hierarchyStrategy: TransitionHierarchyStrategy.NONE
          })
          .transition(TransitionEffect.IDENTITY)
          .draggable(false)
          .syncLoad(true)
          .autoResize(false)
          .objectFit(ImageFit.Contain)
          .interpolation(ImageInterpolation.Medium)
          .width(LITTLE_ICON_SIZE * getScale($$))
          .height(LITTLE_ICON_SIZE * getScale($$))
          .borderRadius(LITTLE_ICON_RADIUS * getScale($$))
          .clip(true)
          .opacity($$.littleIconOpacity)
          .position({
            end: LengthMetrics.vp(LITTLE_ICON_RIGHT_BOTTOM_OFFSET * getScale($$)),
            bottom: LengthMetrics.vp(LITTLE_ICON_RIGHT_BOTTOM_OFFSET * getScale($$)),
          })
          .onError((e) => {
            log.showError(`Load little icon error, key: [${$$.scene}]${$$.ntf.hashCode}, message: ${e.message}`);
          })
      }
    }
    .renderGroup($$.renderGroup)
    .width(BIG_ICON_SIZE * getScale($$) + CONTAINER_EXPAND_SIZE)
    .height(BIG_ICON_SIZE * getScale($$) + CONTAINER_EXPAND_SIZE)
    // 设置图标容器的padding用于解决renderGroup开启时littleIcon会被截断的问题
    .padding({ end: LengthMetrics.vp(CONTAINER_EXPAND_SIZE), bottom: LengthMetrics.vp(CONTAINER_EXPAND_SIZE) })
    .scale($$.needGeometryTransition ? undefined : { x: $$.scale, y: $$.scale,
      centerX: ResourceVm.instance.isRTL ? '100%' : 0, centerY: 0 })
  }
  .id(getId($$, 'container'))
  .flexShrink(0)
  .width(BIG_ICON_SIZE * ($$.scale ?? 1))
  .height(BIG_ICON_SIZE * ($$.scale ?? 1))
  .alignItems(VerticalAlign.Top)
  .justifyContent(FlexAlign.Start)
  .attributeModifier($$.modifier)
  .animation($$.animation)
  .opacity($$.opacity)
  .onClick($$.onClick)
}