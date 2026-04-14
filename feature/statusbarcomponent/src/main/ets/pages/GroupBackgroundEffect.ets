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

import { LogDomain, Logger } from '@ohos/basicutils';
import { BackGroundEffectType } from '@ohos/systemuicommon/src/main/ets/statusbar/enum/StatusBarEnum';
import uiEffect from '@ohos.graphics.uiEffect';
import { EnvVm, DropdownVm } from '@ohos/systemuicommon/newIndex';
import { StatusBarHeightVm } from '@ohos/systemuicommon/src/main/ets/statusbar/vm/StatusBarHeightVm';
import { DeviceHelper } from '@ohos/frameworkwrapper';

const TAG = 'GroupBackgroundEffect';
const log: Logger = Logger.getLogHelper(LogDomain.SYS_UI);
const ROOT_ANCHOR: string = '__container__';

// UX提供的资源以及配置的不可变区域的数据
const SHADOW_WIDTH: number = 134;
const SHADOW_CENTER_WIDTH: number = 90;
const SHADOW_HEIGHT: number = 58;
const SHADOW_CENTER_HEIGHT: number = 20;
const STATUSBAR_HEIGHT: number = 24;

/**
 * 状态栏图标组的背景效果
 */
@ComponentV2
export struct GroupBackgroundEffect {
  @Param effectName: string = 'default';
  @Param leftAnchorBindId: string = '';
  @Param rightAnchorBindId: string = '';
  @Param effectType: BackGroundEffectType = BackGroundEffectType.backgroundShadow;
  @Local extraWidth: number = 1;
  hotspotImage: Resource = $r('app.media.statusBarShadow');
  @Local topWidth: number = vp2px(SHADOW_HEIGHT - SHADOW_CENTER_HEIGHT) / 2 * (STATUSBAR_HEIGHT / SHADOW_CENTER_HEIGHT);
  @Local leftWidth: number = vp2px(SHADOW_WIDTH - SHADOW_CENTER_WIDTH) / 2 * (STATUSBAR_HEIGHT / SHADOW_CENTER_HEIGHT);

  aboutToAppear(): void {
    log.showInfo(TAG, `aboutToAppear GroupBackgroundEffect ${this.effectName}`);
    this.extraWidth = this.getExtraWidth();
  }

  aboutToDisappear(): void {
    log.showInfo(TAG, `aboutToDisappear GroupBackgroundEffect ${this.effectName}`);
  }

  getExtraWidth(): number {
    if (BackGroundEffectType.backgroundShadow === this.effectType) {
      return px2vp(this.leftWidth);
    }
    return 0;
  }

  /**
   * 获取效果所绑定的描点
   */
  getEffectAnchor(): AlignRuleOption {
    if (this.extraWidth > 0) {
      return {
        top: { anchor: ROOT_ANCHOR, align: VerticalAlign.Top },
        bottom: { anchor: ROOT_ANCHOR, align: VerticalAlign.Bottom },
        left: { anchor: `left_Anchor_${this.effectName}`, align: HorizontalAlign.Start },
        right: { anchor: `right_Anchor_${this.effectName}`, align: HorizontalAlign.End }
      }
    } else {
      return {
        top: { anchor: ROOT_ANCHOR, align: VerticalAlign.Top },
        bottom: { anchor: ROOT_ANCHOR, align: VerticalAlign.Bottom },
        left: { anchor: ROOT_ANCHOR, align: HorizontalAlign.Start },
        right: { anchor: ROOT_ANCHOR, align: HorizontalAlign.End }
      }
    }
  }

  @Builder
  creatEffect() {
    // 依据传入的effectType创建不同的背景效果
    if (BackGroundEffectType.backgroundShadow === this.effectType) {
      Row() {
        Image(this.hotspotImage)
          .height(SHADOW_HEIGHT * (STATUSBAR_HEIGHT / SHADOW_CENTER_HEIGHT) )
          .resizable({
            slice: {
              top: `${this.topWidth}px`,
              left: `${this.leftWidth}px`,
              right: `${this.leftWidth}px`,
              bottom: `${this.topWidth}px`,
            }
          })
          .draggable(false)
          .width('100%')
          /*.advancedBlendMode(uiEffect.createShadowBlender({
            cubicCoeff: 10.48,
            quadraticCoeff: -16.07,
            linearCoeff: 7.59,
            constantTerm: -1.15,
          }), BlendApplyType.FAST)*/
      }

    } else if (BackGroundEffectType.backgroundHover === this.effectType) {
      Row().borderRadius(20).backgroundColor($r('app.color.hover_light_bg_color')).width('100%').height('100%')
    }
  }

  /**
   * 校验颜色文本是否合法
   * @param colorStr 16进制颜色字符出
   */
  isValidRgbColor(colorStr: string): boolean {
    // 3位简写（必须带#）
    const hex3Strict = /^#([0-9A-Fa-f]{3})$/;
    // 4位简写带透明度（必须带#）
    const hex4Strict = /^#([0-9A-Fa-f]{4})$/;
    // 6位十六进制（必须带#）
    const hex6Strict = /^#([0-9A-Fa-f]{6})$/;
    // 8位带透明度（必须带#）
    const hex8Strict = /^#([0-9A-Fa-f]{8})$/;
    return hex3Strict.test(colorStr) || hex4Strict.test(colorStr) || hex6Strict.test(colorStr) ||
    hex8Strict.test(colorStr);
  }

  /**
   * 获取当前文本颜色在HSL颜色空间的L值
   * @returns
   */
  getLightnessValue(colorStr: string): number {
    try {
      if (!this.isValidRgbColor(colorStr)) {
        log.showInfo(TAG, `getLightnessValue colorStr is inValid: ${colorStr}`);
        return 0;
      }
      let hex = colorStr.replace('#', '');
      // 统一到6为RGB颜色
      if (hex.length === 8) {
        hex = hex[2] + hex[3] + hex[4] + hex[5] + hex[6] + hex[7];
      } else if (hex.length === 4) {
        hex = hex[1] + hex[1] + hex[2] + hex[2] + hex[3] + hex[3];
      } else if (hex.length === 3) {
        hex = hex[0] + hex[0] + hex[1] + hex[1] + hex[2] + hex[2];
      }
      if (hex.length !== 6) {
        log.showInfo(TAG, `colorStr is inValid: ${colorStr}`);
        return 0;
      }
      const r = parseInt(hex.substring(0, 2), 16);
      const g = parseInt(hex.substring(2, 4), 16);
      const b = parseInt(hex.substring(4, 6), 16);
      const max = Math.max(r, g, b) / 255;
      const min = Math.min(r, g, b) / 255;
      const lightness = Math.round(((max + min) / 2) * 100);
      log.showInfo(TAG, `LightNess: ${lightness} colorStr: ${colorStr}`);
      return lightness;  // HSL颜色空间中该颜色的亮度
    } catch (error) {
      log.showInfo(TAG, `getLightnessValue error: ${error}`);
    }
    return 0;
  }


  private isNeedShowEffect(): boolean {
    if (BackGroundEffectType.backgroundShadow === this.effectType) {
      // 状态栏背景阴影，在下拉、沉浸式、非白色字体场景下 不显示；
      let result: boolean = true;
      if (this.getLightnessValue(EnvVm.instance.statusBarColor) <= 95) {
        result = false;
      } else if (EnvVm.instance.isImmersive) {
        result = false;
      }
      if (result) {
        StatusBarHeightVm.getInstance().preSetShowHeight(SHADOW_HEIGHT, TAG, false);
      } else {
        StatusBarHeightVm.getInstance().clearShowHeight(TAG);
      }
      if (DeviceHelper.isEmulator()) {
        result = false;
      }
      return result;
    }
    log.showInfo(TAG, `isNeedShowEffect GroupBackgroundEffect topWidth: ${this.topWidth} leftWidth: ${this.leftWidth}`);
    return true;
  }


  build() {
    // 依据传入锚点，与状态栏图标对齐
    if (this.isNeedShowEffect()) {
      RelativeContainer() {
        if (this.extraWidth > 0) {
          Stack()
            .width(this.extraWidth)
            .alignRules({
              top: { anchor: ROOT_ANCHOR, align: VerticalAlign.Top },
              bottom: { anchor: ROOT_ANCHOR, align: VerticalAlign.Bottom },
              right: { anchor: ROOT_ANCHOR, align: HorizontalAlign.Start }
            })
            .id(`left_Anchor_${this.effectName}`)

          Stack()
            .width(this.extraWidth)
            .alignRules({
              top: { anchor: ROOT_ANCHOR, align: VerticalAlign.Top },
              bottom: { anchor: ROOT_ANCHOR, align: VerticalAlign.Bottom },
              left: { anchor: ROOT_ANCHOR, align: HorizontalAlign.End }
            })
            .id(`right_Anchor_${this.effectName}`)
        }
        Stack() {
          this.creatEffect()
        }
        .id(`backgroundEffect_${this.effectName}_${this.effectType}`)
        .alignRules(this.getEffectAnchor())
      }
      .opacity(Math.max(0, 1 - (DropdownVm.instance.dropdownEvent.progress) * 1.1))
      .id(`ground_Background_Effect_${this.effectName}`)
      .alignRules({
        top: { anchor: ROOT_ANCHOR, align: VerticalAlign.Top },
        bottom: { anchor: ROOT_ANCHOR, align: VerticalAlign.Bottom },
        left: { anchor: this.leftAnchorBindId, align: HorizontalAlign.Start },
        right: { anchor: this.rightAnchorBindId, align: HorizontalAlign.End }
      })
    }
  }
}