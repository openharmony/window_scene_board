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

import { OverlayCardInfo, OverlayCardState, OverlayAnimScene } from './OverlayCardInfo';
import { CommonUtils, LogDomain, LogHelper } from '@ohos/basicutils';
import Img from '@ohos.multimedia.image';
import RootCapsule from '../liveview/component/capsule/RootCapsule';
import { LiveCapsuleData } from '../liveview/data/capsule/LiveCapsuleData';
import { SystemUICcmConfig } from '../utils/SystemUICcmConfig';

const TAG = 'OverlayCardComponent';
const log: LogHelper = LogHelper.getLogHelper(LogDomain.SYS_UI, TAG);

/**
 * overlay卡片组件
 * 用于通知卡片、胶囊启动应用页面时的过渡动画
 */
@Component
export struct OverlayCardComponent {
  /**
   * overlay卡片动效属性信息
   */
  @ObjectLink overlayCardState: OverlayCardState;

  /**
   * overlay卡片配置信息
   */
  overlayCardInfo: OverlayCardInfo | null = null;
  /**
   * 是否已经执行过disappear
   */
  isDisappeared: boolean = false;

  /**
   * 卡片截图
   */
  @State cardSnapshot: Img.PixelMap | undefined = undefined;

  aboutToAppear(): void {
    // 启动应用场景，加载卡片内容截图
    if (this.overlayCardInfo?.isTypeStartApp()) {
      this.overlayCardInfo?.getContentSnapshot().then((snapshot) => {
        if (!this.isDisappeared) {
          this.cardSnapshot = snapshot;
          log.showInfo('aboutToAppear load snapshot: ' + this.overlayCardInfo?.startBundleName +
            ', ' + this.overlayCardInfo?.oriCardContentId);
        } else {
          snapshot.release();
        }
      });
    }
  }

  aboutToDisappear(): void {
    this.isDisappeared = true;
    this.cardSnapshot?.release().then(() => {
      log.showInfo('aboutToDisappear release snapshot: ' + this.overlayCardInfo?.startBundleName +
        ', ' + this.overlayCardInfo?.oriCardContentId);
    });
  }

  @Builder
  ContentComponent() {
    // 应用启动场景，卡片截图内容层
    if (this?.overlayCardInfo?.isStartFromIcon()) {
      if (this?.overlayCardInfo?.cardResource) {
        Image(this?.overlayCardInfo?.cardResource)
          .iconAnimStyle()
      } else {
        Image(this.cardSnapshot)
          .iconAnimStyle()
      }
    } else if (this.isTypeStartApp()) {
      if (this.overlayCardInfo?.animScene === OverlayAnimScene.TYPE_START_APP_FROM_LOCK_SCREEN) {
        Image(this.cardSnapshot)
          .contentAnimStyle()
      } else {
        Image(this.cardSnapshot)
          .contentAnimStyle()// 卡片固定位置
          .position({
            x: this.overlayCardInfo?.getContentPositionX(),
            y: this.overlayCardInfo?.getContentPositionY()
          })// 位移参与动效，卡片内容保持相对位置不变
          .translate({
            x: (this.overlayCardState?.overlayCardEndTranX - this.overlayCardState?.containerTranX),
            y: (this.overlayCardState?.overlayCardEndTranY - this.overlayCardState?.containerTranY)
          })
      }
    } else if (this.overlayCardInfo?.isTypeExitCapsule() && !SystemUICcmConfig.instance.isEnabledLive2) { // 应用回胶囊场景
      Stack() {
        RootCapsule({
          capsuleData: this.overlayCardInfo!.capsuleData as LiveCapsuleData,
          animStyle: this.overlayCardInfo!.capsuleStyle
        })
      }
      .contentAnimStyle()
    }
  }

  build() {
    // 启动应用左上，回胶囊居中
    Stack({alignContent: this.getAlignContent()}) {
      // 卡片独立颜色背景层
      if (this.overlayCardInfo?.isShowCardBg) {
        Row() {
        }
        .backgroundColor(this.overlayCardInfo?.cardBgColor)
        .brightness(this.overlayCardInfo?.cardBgBrightness)
        .saturate(this.overlayCardInfo?.cardBgSaturate)
        .backgroundBlurStyle(this.overlayCardInfo?.cardBgBlurStyle, { policy: 1 })
        .backdropBlur(this.overlayCardInfo?.cardBgBackdropBlur)
        .backgroundEffect({ radius: this.overlayCardInfo?.cardEffectRadius, policy: 1 })
        // 宽高由父布局整体动效控制
        .size({
          width: '100%',
          height: '100%'
        })
        // 透明度参与动效
        .opacity(this.overlayCardState?.overlayCardBgAlpha)
      }
      // 内容层
      this.ContentComponent()
    }
    .size({
      width: this.getContainerWidth(),
      height: this.getContainerHeight()
    })
    .borderRadius(this.overlayCardInfo?.cardRadius)
    .clip(true)
  }

  /**
   * 内容层样式
   */
  @Styles
  contentAnimStyle() {
    // 卡片内容固定大小
    .size({
      width: this.overlayCardInfo?.getContentWidth(),
      height: this.overlayCardInfo?.getContentHeight()
    })
    // 透明度参与动效
    .opacity(this.overlayCardState?.overlayCardAlpha)
    // 缩放参与动效
    .scale({
      x: this.overlayCardState?.overlayCardScaleX,
      y: this.overlayCardState?.overlayCardScaleY
    })
  }

  /**
   * startFromIcon内容层样式
   */
  @Styles
  iconAnimStyle() {
    .size({
      width: this.overlayCardState?.iconWidth,
      height: this.overlayCardState?.iconWidth
    })
    .opacity(this.overlayCardState?.overlayCardAlpha)
  }

  getAlignContent(): Alignment {
    if (this.overlayCardInfo?.isStartFromIcon()) {
      return Alignment.Center;
    } else if (this.isTypeStartApp()) {
      return this.overlayCardInfo?.animScene === OverlayAnimScene.TYPE_START_APP_FROM_LOCK_SCREEN ? Alignment.Center :
        Alignment.TopStart;
    } else {
      return Alignment.Center;
    }
  }

  /**
   * 容器宽度
   *
   * @returns 宽度
   */
  private getContainerWidth(): string {
    if (CommonUtils.isInvalid(this.overlayCardState?.containerWidth)) {
      return '100%';
    }
    return CommonUtils.splicePx(this.overlayCardState?.containerWidth!);
  }

  /**
   * 容器高度
   *
   * @returns 高度
   */
  private getContainerHeight(): string {
    if (CommonUtils.isInvalid(this.overlayCardState?.containerHeight)) {
      return '100%';
    }
    return CommonUtils.splicePx(this.overlayCardState?.containerHeight!);
  }

  /**
   * 是否启动APP类型
   *
   * @returns true启动APP
   */
  private isTypeStartApp(): boolean {
    return (this.overlayCardInfo?.isTypeStartApp() ?? false) && !CommonUtils.isInvalid(this.cardSnapshot);
  }
}